import { detect, type Feature } from './detect/detect'

type Cache = {}

export async function calculate_cache(key: Uint8Array): Promise<Cache> {
	if (key.length > 60) {
		throw Error('Key length must be from 0-60')
	}

	return {}
}

// returns 32 byte Uint8Array
export async function calculate_hash(input: Uint8Array, cache?: Cache | null, features?: Feature | null): Promise<Uint8Array> {
	if (!features) {
		features = await detect()
	}

	if (features === 'js') {
		throw Error('Unimplemented for `js` featureset')
	}

	if (!cache) {
		cache = await calculate_cache(new Uint8Array(0))
	}

	/* const Hash256 = blake2b(32)
	const Hash512 = blake2b(64) */

	return new Uint8Array(32)
}

calculate_hash(new Uint8Array([3, 2]))
