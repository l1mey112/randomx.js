#!/usr/bin/env bun

import esbuild from 'esbuild'
import type { BuildOptions } from 'esbuild'
import { $ } from 'bun'

// 0: production
// 1: single step VM by breakpoint (with printf)
// 2: performance counters (with printf)
const INSTRUMENT = parseInt(process.env.INSTRUMENT || '0') || 0
const k = await $`INSTRUMENT=${INSTRUMENT} make -j$(nproc)`.nothrow() // make all

if (k.exitCode !== 0) {
	process.exit(k.exitCode)
}

const opt: BuildOptions = {
	sourcemap: true,
	minify: true,
	bundle: true,
	entryPoints: ['src/index.ts'],
	loader: {
		'.wasm': 'binary',
	},
	external: ['os'],
}

await Promise.all([
	esbuild.build({
		...opt,
		outdir: 'dist/web',
		target: ['chrome91', 'firefox89', 'safari16'],
		platform: 'browser',
		format: 'esm',
		define: {
			INSTRUMENT: JSON.stringify(INSTRUMENT),
			ENVIRONMENT: '"browser"',
			FORMAT: '"esm"',
		}
	}),

	esbuild.build({
		...opt,
		outdir: 'dist/cjs',
		target: ['node17'],
		platform: 'node',
		format: 'cjs',
		define: {
			INSTRUMENT: JSON.stringify(INSTRUMENT),
			ENVIRONMENT: '"node"',
			FORMAT: '"cjs"',
		}
	}),

	esbuild.build({
		...opt,
		outdir: 'dist/esm',
		target: ['node17'],
		platform: 'node',
		format: 'esm',
		outExtension: { '.js': '.mjs' },
		define: {
			INSTRUMENT: JSON.stringify(INSTRUMENT),
			ENVIRONMENT: '"node"',
			FORMAT: '"esm"',
		}
	}),

	// fuck this shit - dts-bundle-generator doesn't even care about global types or modules
	// https://github.com/timocov/dts-bundle-generator/discussions/232

	$`bunx dts-bundle-generator -o dist/index.d.ts --no-banner src/index.ts`.nothrow().then(
		() => $`cp dist/index.d.ts dist/cjs/index.d.ts; cp dist/index.d.ts dist/esm/index.d.ts`
	),
])
