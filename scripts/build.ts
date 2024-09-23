#!/usr/bin/env bun

import esbuild from 'esbuild'
import type { BuildOptions } from 'esbuild'
import { $ } from 'bun'
import { binayloader } from './binaryloader'

/* const k = await $`make -j$(nproc)`.nothrow() // make all

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
	}
}

await Promise.all([
	esbuild.build({
		...opt,
		outdir: 'dist/web',
		target: ['chrome58', 'firefox57', 'safari11'],
		format: 'iife',
		platform: 'browser',
		globalName: 'randomx'
	}),

	esbuild.build({
		...opt,
		outdir: 'dist/cjs',
		target: ['node19'],
		platform: 'neutral',
		format: 'cjs',
	}),

	esbuild.build({
		...opt,
		outdir: 'dist/esm',
		target: ['node19'],
		platform: 'node',
		format: 'esm'
	}),

	$`bunx dts-bundle-generator -o dist/index.d.ts --no-banner src/index.ts`.nothrow().then(
		() => $`cp dist/index.d.ts dist/cjs/index.d.ts; cp dist/index.d.ts dist/esm/index.d.ts`
	),
]) */

await Bun.build({
	entrypoints: ['src/index.ts'],
	outdir: 'dist',
	plugins: [binayloader],
})
