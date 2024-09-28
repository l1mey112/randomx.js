import { env_npf_putc } from '../printf/printf'
import { adjust_imported_shared_memory } from '../wasm_prefix'

// @ts-ignore
import wasm, { wasm_pages } from 'dataset.wasm'

// @ts-ignore
import vm_wasm from 'vm.wasm'

declare var INSTRUMENT: number

let _vm_handle: WebAssembly.Module | null = null

type DatasetModule = {
	c(pages: number): number
	K(key_length: number, is_shared: boolean): number
}

// can be shared between threads safely if shared memory is enabled
export type RxCache = {
	memory: WebAssembly.Memory // backing ArrayBuffer or SharedArrayBuffer
	thunk: WebAssembly.Module // WASM JIT code
	vm: WebAssembly.Module // handle to memoised randomx VM, to avoid recomplilation when sent over threads
}

function create_module(is_shared: boolean): [WebAssembly.Memory, DatasetModule] {
	// we cannot cache this module because we need to adjust the memory import
	adjust_imported_shared_memory(wasm, '\x03env\x06memory', is_shared) // patch in place

	const memory = new WebAssembly.Memory({ initial: wasm_pages, maximum: wasm_pages, shared: is_shared })
	const wm = new WebAssembly.Module(wasm)

	const wi_imports = !INSTRUMENT ? {
		env: {
			memory
		}
	} : {
		env: {
			memory
		},
		e: {
			ch: env_npf_putc
		}
	}
	const wi = new WebAssembly.Instance(wm, wi_imports as Record<string, any>)

	const exports = wi.exports as DatasetModule
	return [memory, exports]
}

function initialise(K: Uint8Array, memory: WebAssembly.Memory, exports: DatasetModule, is_shared: boolean): RxCache {
	const jit_begin = exports.c(wasm_pages)
	const key_buffer = new Uint8Array(memory.buffer, jit_begin, 60)
	key_buffer.set(K)

	const jit_size = exports.K(K.length, is_shared) // long blocking
	const jit_buffer = new Uint8Array(memory.buffer, jit_begin, jit_size)

	if (!_vm_handle) {
		_vm_handle = new WebAssembly.Module(vm_wasm)
	}

	return {
		memory,
		thunk: new WebAssembly.Module(jit_buffer),
		vm: _vm_handle,
	}
}

type RxCacheOptions = { shared?: boolean }

export function randomx_init_cache(K?: string | Uint8Array | undefined | null, conf?: RxCacheOptions | undefined | null): RxCache {
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

export type RxSuperscalarHash = (item_index: bigint) => [bigint, bigint, bigint, bigint, bigint, bigint, bigint, bigint]

export function randomx_superscalarhash(cache: RxCache): RxSuperscalarHash {
	const wi = new WebAssembly.Instance(cache.thunk, {
		e: {
			m: cache.memory
		}
	})

	type SuperscalarHashModule = {
		d: RxSuperscalarHash
	}

	const exports = wi.exports as SuperscalarHashModule
	return exports.d
}
