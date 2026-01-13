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
		const wm = new WebAssembly.Module(fma as any)
		const wi = new WebAssembly.Instance(wm)

		if ((wi.exports.d as () => number)()) {
			return JIT_FMA | JIT_RELAXED_SIMD // working FMA
		}
		return JIT_RELAXED_SIMD // no working FMA
	} catch {
		return JIT_BASELINE // no relaxed SIMD
	}
}

function jit_feature_stringify(feature: JitFeature): string[] {
	const s = []

	if (feature & JIT_RELAXED_SIMD) {
		s.push('relaxed-simd')
	}

	if (feature & JIT_FMA) {
		s.push('fma')
	}

	return s
}

// Node.js/v18.20.4 (linux x64) -------------------------------------------- AMD Ryzen 7 3800X 8-Core Processor
// Bun/1.1.29 (linux x64) -------------------------------------------------- AMD Ryzen 7 3800X 8-Core Processor
// Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0 -- Generic 16-Thread CPU

// Generic 16-Thread CPU [rx/0+relaxed-simd+fma] Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0

// ignore this retardation - trying to get imports reliably per platform on esbuild is stupid
declare var ENVIRONMENT: 'node' | 'browser'
declare var FORMAT: 'cjs' | 'esm'

declare var require: (module: string) => any
declare var process: {
	isBun: boolean
	version: string
	platform: string
	arch: string
}
declare var Bun: {
	version: string
}

let node_os: any

// @ts-ignore
if (ENVIRONMENT === 'node') {
	// @ts-ignore
	if (FORMAT === 'esm') {
		// @ts-ignore
		node_os = /* @__PURE__ */ await import('os')
	} else {
		node_os = /* @__PURE__ */ require('os')
	}
}

// CPU [algo+features...] User-Agent
export function machine_id(feature: JitFeature): string {
	const features = jit_feature_stringify(feature)
	let ua: string | undefined
	let cpu_model: string | undefined

	if (ENVIRONMENT === 'node') {
		if (!process.isBun) {
			// navigator added in Node v21.0.0, provide more accurate useragent anyway
			ua = `Node.js/${process.version} (${process.platform} ${process.arch})`
		} else {
			// Bun has had navigator since release, provide more accurate useragent anyway
			ua = `Bun/${Bun.version} (${process.platform} ${process.arch})`	
		}
		cpu_model = node_os.cpus()[0].model as string
	}
	
	if (ENVIRONMENT === 'browser') {
		ua = navigator.userAgent
		cpu_model = `Generic ${navigator.hardwareConcurrency}-Thread CPU`
	}

	return `${cpu_model} [rx/0${features.length ? '+' : ''}${features.join('+')}] ${ua}`
}
