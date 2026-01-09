import { env_npf_putc } from '../printf/printf'
import { adjust_imported_shared_memory, check_imported_shared_memory } from '../wasm_prefix'

// @ts-ignore
import wasm, { wasm_pages, is_shared as dataset_is_shared } from 'dataset.wasm'

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

function create_module(): [WebAssembly.Memory, DatasetModule] {
	const memory = new WebAssembly.Memory({ initial: wasm_pages, maximum: wasm_pages, shared: dataset_is_shared })
	const wm = new WebAssembly.Module(wasm as any)

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

function initialise(K: Uint8Array, memory: WebAssembly.Memory, exports: DatasetModule): RxCache {
	const jit_begin = exports.c(wasm_pages, dataset_is_shared)
	const key_buffer = new Uint8Array(memory.buffer, jit_begin, 60)
	key_buffer.set(K)

	const jit_size = exports.K(K.length) // long blocking
	const jit_buffer = new Uint8Array(memory.buffer, jit_begin, jit_size)

	if (!_vm_handle) {
		_vm_handle = new WebAssembly.Module(vm_wasm as any)
	}

	return new RxCache(memory, new WebAssembly.Module(jit_buffer), _vm_handle, exports)
}

type RxCacheOptions = {
	/**
	* @deprecated This has no effect, now that there are separate libraries to actually do this.
	* 	          Use 'randomx.js-shared' or 'randomwow.js-shared' for shared memory.
	*/
	shared?: boolean
}

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
		return initialise(K, cache.memory, cache.exports)
	}

	// is_shared has no effect, it's merely an assertion now
	if (dataset_is_shared !== (conf?.shared ?? dataset_is_shared)) {
		throw new Error(`Deprecated: 'shared' option has no effect, and is an assertion now (expected shared=${dataset_is_shared})`)
	}
	
	const [memory, exports] = create_module()
	return initialise(K, memory, exports)
}
