import { env_npf_putc } from '../printf/printf'
import { adjust_imported_shared_memory } from '../wasm_prefix'
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

async function create_module(is_shared: boolean): Promise<[WebAssembly.Memory, DatasetModule]> {
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
	return [memory, exports]
}

function initialise(K: Uint8Array, memory: WebAssembly.Memory, exports: DatasetModule): Cache {
	const jit_begin = exports.b()
	const key_buffer = new Uint8Array(memory.buffer, jit_begin, 60)
	key_buffer.set(K)

	const jit_size = exports.K(K.length) // long blocking
	const jit_buffer = new Uint8Array(memory.buffer, jit_begin, jit_size)

	return {
		memory,
		thunk: jit_buffer
	}
}

export async function randomx_construct_cache(K?: Uint8Array | undefined | null, conf?: { shared?: boolean } | undefined | null): Promise<Cache> {
	K ??= new Uint8Array()

	if (K.length > 60) {
		throw new Error('Key length is too long (max 60 bytes)')
	}

	const [memory, exports] = await create_module(!!conf?.shared)
	return initialise(K, memory, exports)
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
