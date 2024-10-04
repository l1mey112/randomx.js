import { env_npf_putc } from '../printf/printf'
import { adjust_imported_shared_memory } from '../wasm_prefix'

// @ts-ignore
import wasm, { wasm_pages } from 'dataset.wasm'

// @ts-ignore
import vm_wasm from 'vm.wasm'

declare var INSTRUMENT: number

let _vm_handle: WebAssembly.Module | null = null

type DatasetModule = {
	c(pages: number, is_shared: boolean): number
	K(key_length: number): number
}

// can be shared between threads safely if shared memory is enabled
/* export type RxCache = {
	memory: WebAssembly.Memory // backing ArrayBuffer or SharedArrayBuffer
	thunk: WebAssembly.Module // WASM JIT code
	vm: WebAssembly.Module // handle to memoised randomx VM, to avoid recomplilation when sent over threads
	K(K: number): number
} */

export type RxCacheHandle = {
	memory: WebAssembly.Memory
	thunk: WebAssembly.Module
	vm: WebAssembly.Module
}

export class RxCache {
	/**
	 * @internal
	 */
	memory: WebAssembly.Memory
	/**
	 * @internal
	 */
	thunk: WebAssembly.Module
	/**
	 * @internal
	 */
	vm: WebAssembly.Module
	/**
	 * @internal
	 */
	exports: DatasetModule

	/**
	 * @internal
	 */
	constructor(memory: WebAssembly.Memory, thunk: WebAssembly.Module, vm: WebAssembly.Module, exports: DatasetModule) {
		this.memory = memory
		this.thunk = thunk
		this.vm = vm
		this.exports = exports
	}

	get shared(): boolean {
		return this.memory.buffer instanceof SharedArrayBuffer
	}

	get handle(): RxCacheHandle {
		return {
			memory: this.memory,
			thunk: this.thunk,
			vm: this.vm
		}
	}
}

function create_module(is_shared: boolean): [WebAssembly.Memory, DatasetModule] {
	// we cannot cache this module because we need to adjust the memory import
	adjust_imported_shared_memory(wasm, '\x03env\x06memory', is_shared) // patch in place

	const memory = new WebAssembly.Memory({ initial: wasm_pages, maximum: wasm_pages, shared: is_shared })
	const wm = new WebAssembly.Module(wasm)

	const wi_imports: Record<string, Record<string, WebAssembly.ImportValue>> = {
		env: {
			memory
		}
	}

	if (INSTRUMENT) {
		wi_imports.e = {}
		wi_imports.e.ch = env_npf_putc

		if (INSTRUMENT == 2) {
			wi_imports.e.b = function (){}
		}
	}

	const wi = new WebAssembly.Instance(wm, wi_imports as Record<string, any>)

	const exports = wi.exports as DatasetModule
	return [memory, exports]
}

function initialise(K: Uint8Array, memory: WebAssembly.Memory, exports: DatasetModule, is_shared: boolean): RxCache {
	const jit_begin = exports.c(wasm_pages, is_shared)
	const key_buffer = new Uint8Array(memory.buffer, jit_begin, 60)
	key_buffer.set(K)

	const jit_size = exports.K(K.length) // long blocking
	const jit_buffer = new Uint8Array(memory.buffer, jit_begin, jit_size)

	if (!_vm_handle) {
		_vm_handle = new WebAssembly.Module(vm_wasm)
	}

	return new RxCache(memory, new WebAssembly.Module(jit_buffer), _vm_handle, exports)
}

type RxCacheOptions = { shared?: boolean }

export function randomx_init_cache(K: string | Uint8Array | undefined | null, cache: RxCache): RxCache
export function randomx_init_cache(K?: string | Uint8Array | undefined | null, conf?: RxCacheOptions | undefined | null): RxCache

export function randomx_init_cache(K?: string | Uint8Array | undefined | null, conf?: RxCache | RxCacheOptions | undefined | null): RxCache {
	if (typeof K === 'string') {
		K = new TextEncoder().encode(K)
	}
	K ??= new Uint8Array()

	if (K.length > 60) {
		throw new Error('Key length is too long (max 60 bytes)')
	}

	if (conf instanceof RxCache) {
		const cache = conf
		return initialise(K, cache.memory, cache.exports, cache.shared)
	}

	const is_shared = !!conf?.shared
	const [memory, exports] = create_module(is_shared)
	return initialise(K, memory, exports, is_shared)
}

export type RxSuperscalarHash = (item_index: bigint) => [bigint, bigint, bigint, bigint, bigint, bigint, bigint, bigint]

export function randomx_superscalarhash(cache: RxCache | RxCacheHandle): RxSuperscalarHash {
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
