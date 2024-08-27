import { FEATURE_FMA, FEATURE_SIMD, type Feature } from '../../include/configuration'
import fma from './fma.wasm'
import simd from './simd.wasm'

export async function detect(): Promise<Feature> {
	try {
		if (!WebAssembly.validate(simd)) {
			throw null
		}
	} catch {
		throw new Error('no WASM, SIMD, ATOMICS, or BULK MEMORY')
	}

	try {
		const t = await WebAssembly.instantiate(fma)

		if (!!(t.instance.exports.d as CallableFunction)()) {
			return FEATURE_FMA // WORKING FMA
		} else {
			return FEATURE_SIMD // no WORKING FMA
		}
	} catch {
		return FEATURE_SIMD // no RELAXED SIMD
	}
}
