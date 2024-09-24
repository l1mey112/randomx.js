import { env_npf_putc } from '../printf/printf'
import { adjust_imported_shared_memory } from '../wasm_prefix'

// @ts-ignore
import wasm from './dataset.wasm'
import wasm_pages from './dataset.wasm.pages'

type DatasetModule = {
	c(): number
	K(key_length: number, is_shared: boolean): number
}

// can be shared between threads safely if shared memory is enabled
export type Cache = {
	memory: WebAssembly.Memory // backing ArrayBuffer or SharedArrayBuffer
	thunk: WebAssembly.Module // WASM JIT code
}

function create_module(is_shared: boolean): [WebAssembly.Memory, DatasetModule] {
	// we cannot cache this module because we need to adjust the memory import
	adjust_imported_shared_memory(wasm, '\x03env\x06memory', is_shared) // patch in place

	const memory = new WebAssembly.Memory({ initial: wasm_pages, maximum: wasm_pages, shared: is_shared })
	const wm = new WebAssembly.Module(wasm)
	const wi = new WebAssembly.Instance(wm, {
		e: {
			ch: env_npf_putc
		},
		env: {
			memory
		},
	})

	const exports = wi.exports as DatasetModule
	return [memory, exports]
}

function initialise(K: Uint8Array, memory: WebAssembly.Memory, exports: DatasetModule, is_shared: boolean): Cache {
	const jit_begin = exports.c()
	const key_buffer = new Uint8Array(memory.buffer, jit_begin, 60)
	key_buffer.set(K)

	const jit_size = exports.K(K.length, is_shared) // long blocking
	const jit_buffer = new Uint8Array(memory.buffer, jit_begin, jit_size)

	return {
		memory,
		thunk: new WebAssembly.Module(jit_buffer)
	}
}

type CacheOptions = { shared?: boolean }

export function randomx_init_cache(K?: string | Uint8Array | undefined | null, conf?: CacheOptions | undefined | null): Cache {
	if (typeof K === 'string') {
		K = new TextEncoder().encode(K)
	}
	K ??= new Uint8Array()

	if (K.length > 60) {
		throw new Error('Key length is too long (max 60 bytes)')
	}

	const is_shared = !!conf?.shared
	const [memory, exports] = create_module(is_shared)
	return initialise(K, memory, exports, is_shared)
}

export type SuperscalarHash = (item_index: bigint) => [bigint, bigint, bigint, bigint, bigint, bigint, bigint, bigint]

export function randomx_superscalarhash(cache: Cache): SuperscalarHash {
	const wi = new WebAssembly.Instance(cache.thunk, {
		e: {
			m: cache.memory
		}
	})

	type SuperscalarHashModule = {
		d: SuperscalarHash
	}

	const exports = wi.exports as SuperscalarHashModule
	return exports.d
}
