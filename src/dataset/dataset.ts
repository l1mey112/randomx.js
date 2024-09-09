import { env_npf_putc } from '../printf/printf'
import { locate_import } from '../wasm_prefix'
import wasm from './dataset.wasm'
import wasm_pages from './dataset.wasm.pages'

type DatasetModule = {
	b(): number
	K(key_length: number): number
}

// can be shared between threads safely if shared memory is enabled
export type Cache = {
	memory: WebAssembly.Memory // backing ArrayBuffer or SharedArrayBuffer
	thunk: Uint8Array // WASM JIT code
}

function adjust_imported_shared_memory(binary: Uint8Array, needle: string, shared: boolean) {
	// the import section is near the start, no need to step over the entire binary
	// indexOf doesn't work on Uint8Array

	let p = locate_import(binary, needle)

	// 0x02 memtype

	// memtype ::= limits
	// limits  ::= 0x00 n:u32         => { min n }
	//           | 0x01 n:u32 m:u32   => { min n, max m }
	//           | 0x03 n:u32 m:u32   => { min n, max m, shared }

	if (binary[p] !== 0x02) {
		throw new Error('Expected memtype')
	}
	p += 1 // 0x02

	if (binary[p] === 0x00) {
		throw new Error('Cannot patch in place')
	}

	binary[p] = shared ? 0x03 : 0x01
}

export async function randomx_construct_cache_oneshot(K?: Uint8Array | undefined | null, conf?: { shared?: boolean, hard_block?: boolean } | undefined | null): Promise<Cache> {
	K ??= new Uint8Array()

	if (K.length > 60) {
		throw new Error('Key length is too long (max 60 bytes)')
	}

	if (conf?.hard_block) {
		throw new Error()
	}

	const is_shared = !!conf?.shared
	adjust_imported_shared_memory(wasm, '\x03env\x06memory', is_shared) // patch in place

	const memory = new WebAssembly.Memory({ initial: wasm_pages, maximum: wasm_pages, shared: is_shared })
	const module = await WebAssembly.instantiate(wasm, {
		e: {
			ch: env_npf_putc
		},
		env: {
			memory
		},
	})

	const exports = module.instance.exports as DatasetModule

	const jit_begin = exports.b()
	const key_buffer = new Uint8Array(memory.buffer, jit_begin, 60)
	key_buffer.set(K)

	const jit_size = exports.K(K.length) // long blocking
	const jit_buffer = new Uint8Array(memory.buffer, jit_begin, jit_size)

	return {
		memory,
		thunk: jit_buffer,
	}
}

type SuperscalarHash = (item_index: bigint) => [bigint, bigint, bigint, bigint, bigint, bigint, bigint, bigint]
type SuperscalarHashModule = {
	d: SuperscalarHash
}

export async function randomx_superscalarhash(cache: Cache): Promise<SuperscalarHash> {
	const module = await WebAssembly.instantiate(cache.thunk, {
		e: {
			m: cache.memory
		}
	})

	const exports = module.instance.exports as SuperscalarHashModule
	return exports.d
}
