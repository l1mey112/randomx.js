import fma from './fma.wat?embed'
import simd from './simd.wat?embed'

export type Feature =
	| 'js'   // JS only (asm.js where possible)
	| 'simd' // JS + WASM + SIMD + BULK MEMORY
	| 'fma'  // JS + WASM + SIMD + BULK MEMORY + RELAXED SIMD + WORKING FMA

export async function detect(): Promise<Feature> {
	try {
		if (!WebAssembly.validate(simd)) {
			return 'js' // no SIMD
		}
	} catch {
		return 'js' // JS only
	}

	try {
		const t = await WebAssembly.instantiate(fma)

		if (!!(t.instance.exports.d as CallableFunction)()) {
			return 'fma' // WORKING FMA
		} else {
			return 'simd' // no WORKING FMA
		}
	} catch {
		return 'simd' // JS + WASM + SIMD
	}
}
