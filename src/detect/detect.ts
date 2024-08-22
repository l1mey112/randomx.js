import fma from './fma.wasm'
import simd from './simd.wasm'

/* type FeatureBase =
	| 'js'   // JS only (asm.js where possible)
	| 'simd' // JS + WASM + SIMD + BULK MEMORY
	| 'fma'  // JS + WASM + SIMD + BULK MEMORY + WORKING FMA

export type Feature =
	| FeatureBase
	| 'simd+tail' | 'fma+tail' // TAIL CALLS */

export type Feature =
	| 'js'   // JS only (asm.js where possible)
	| 'simd' // JS + WASM + SIMD + BULK MEMORY
	| 'fma'  // JS + WASM + SIMD + BULK MEMORY + WORKING FMA

export async function detect(): Promise<Feature> {
	if (!WebAssembly.validate(simd)) {
		return 'js' // no SIMD or BULK MEMORY
	}

	try {
		const t = await WebAssembly.instantiate(fma)

		if (!!(t.instance.exports.d as CallableFunction)()) {
			return 'fma' // WORKING FMA
		} else {
			return 'simd' // no WORKING FMA
		}
	} catch {
		return 'simd' // no RELAXED SIMD
	}
}
