// @ts-ignore
import fma from './fma.wasm'
// @ts-ignore
import simd from './simd.wasm'

export type JitFeature = number

export const JIT_BASELINE = 0 // SIMD and bulk memory instructions
export const JIT_RELAXED_SIMD = 1 // relaxed SIMD instructions
export const JIT_FMA = 2 // working fused multiply-add (assumes JIT_RELAXED_SIMD)

export function jit_detect(): JitFeature {
	try {
		if (!WebAssembly.validate(simd)) {
			throw null
		}
	} catch {
		throw new Error('WebAssembly not available, or SIMD and bulk memory not supported. randomx.js requires these baseline features to run')
	}

	try {
		const wm = new WebAssembly.Module(fma)
		const wi = new WebAssembly.Instance(wm)

		if (!!(wi.exports.d as CallableFunction)()) {
			return JIT_FMA | JIT_RELAXED_SIMD // working FMA
		} else {
			return JIT_RELAXED_SIMD // no working FMA
		}
	} catch {
		return JIT_BASELINE // no relaxed SIMD
	}
}

export function jit_feature_stringify(feature: JitFeature): string {
	let s = 'baseline'

	if (feature & JIT_RELAXED_SIMD) {
		s += ' + relaxed-simd'
	}

	if (feature & JIT_FMA) {
		s += ' + fma'
	}

	return s
}
