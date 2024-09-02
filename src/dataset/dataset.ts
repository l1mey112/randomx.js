import { env_npf_putc } from '../printf/printf'
import wasm from './dataset.wasm'
import wasm_pages from './dataset.wasm.pages'

type DatasetModule = {
	memory: WebAssembly.Memory

	b(): number // jit
	K(key_length: number): number
}

// can be shared between threads safely if shared memory is enabled
type Cache = {
	memory: WebAssembly.Memory // backing ArrayBuffer or SharedArrayBuffer
	thunk: Uint8Array // WASM JIT code
}

export async function randomx_cache(K?: Uint8Array, conf?: { shared?: boolean }): Promise<Cache> {
	K ??= new Uint8Array()

	if (K.length > 60) {
		throw new Error('Key length is too long (max 60 bytes)')
	}

	// TODO: implement this later
	if (conf?.shared) {
		throw new Error('Shared memory is not implemented yet')
	}

	// to enable shared memory
	// 1. memory must not be growable, initial = maximum
	//    - must be completed on the host side and binary
	//    - use --no-growable-memory (not available in debian builds of clang)
	// 2. memory import must be set to shared
	//    - can be patched based if needed

	const memory = new WebAssembly.Memory({ initial: wasm_pages, maximum: wasm_pages, shared: !!conf?.shared })
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
