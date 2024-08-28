import { RANDOMX_ARGON_MEMORY } from '../../include/configuration'
import { env_npf_putc } from '../printf/printf'
import wasm from './dataset.wasm'
import wasm_pages from './dataset.wasm.pages'

type DatasetModule = {
	memory: WebAssembly.Memory

	Kb(): number // key buffer
	Cb(): number // cache
	K(key_length: number): void
}

export type Dataset = {
	buffer: Uint8Array // backing ArrayBuffer or SharedArrayBuffer
	thunk?: Uint8Array
}

export default async function dataset(K: Uint8Array, conf?: { shared?: boolean }): Promise<Dataset> {
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

	const memory = new WebAssembly.Memory({ initial: wasm_pages, maximum: wasm_pages, shared: !!conf?.shared  })

	const module = await WebAssembly.instantiate(wasm, {
		e: {
			ch: env_npf_putc
		},
		env: {
			memory
		},
	})

	const exports = module.instance.exports as DatasetModule

	const key_begin = exports.Kb()
	const key_buffer = new Uint8Array(memory.buffer, key_begin, 60)

	key_buffer.set(K)
	exports.K(K.length) // long blocking

	const cache_begin = exports.Cb()
	const cache_buffer = new Uint8Array(memory.buffer, cache_begin, RANDOMX_ARGON_MEMORY * 1024)

	return {
		buffer: cache_buffer,
		// TODO: implement thunk
	}
}

const g = await dataset(new Uint8Array())
console.log(g)
