import { FEATURE_FMA, FEATURE_JS, FEATURE_SIMD, type Feature } from '../../include/configuration'
import fma from './fma.wasm'
import simd from './simd.wasm'

export async function detect(): Promise<Feature> {
	if (!WebAssembly.validate(simd)) {
		return FEATURE_JS // no SIMD or BULK MEMORY
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
