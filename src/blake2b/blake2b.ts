import { type Feature } from '../detect/detect';
import main from './main'

export type Blake2b = {
	hash256(data: Uint8Array, key?: Uint8Array): Uint8Array;
	hash512(data: Uint8Array, key?: Uint8Array): Uint8Array;
}

async function create_blake2b(feature: Feature): Promise<Blake2b> {
	const module = await main(feature)

	// #define SCRATCH_SIZE 52 * 1024
	// alignas(128) uint8_t scratch_buffer[SCRATCH_SIZE];

	const SCRATCH_SIZE = 52 * 1024
	const scratch_ptr = module.blake2b_scratch()	
	const buffer = new Uint8Array(module.memory.buffer, scratch_ptr, SCRATCH_SIZE)

	function hash(data: Uint8Array, hash_length: number , key?: Uint8Array) {
		if (key && key.length > 64) {
			throw new Error('assertion failed: key.length <= 64')
		}

		if (key) {
			buffer.set(key)
		}

		module.blake2b_init(hash_length, key?.length ?? 0)

		let p = 0
		while (p < data.length) {
			const chunk = data.subarray(p, p + SCRATCH_SIZE)
			p += SCRATCH_SIZE
			buffer.set(chunk)
			module.blake2b_update(chunk.length)
		}

		module.blake2b_finalise()

		const hash = new Uint8Array(hash_length)
		hash.set(buffer.subarray(0, hash_length))

		return hash
	}

	return {
		hash256(data: Uint8Array, key?: Uint8Array) {
			return hash(data, 32, key)
		},
		hash512(data: Uint8Array, key?: Uint8Array) {
			return hash(data, 64, key)
		}
	}
}

let cache_js: any
let cache_wasm: any

export async function blake2b(feature: Feature): Promise<Blake2b> {
	if (feature === 'js') {
		if (!cache_js) {
			cache_js = await create_blake2b('js')
		}
		return cache_js
	}
	if (!cache_wasm) {
		cache_wasm = await create_blake2b(feature)
	}
	return cache_wasm
}
