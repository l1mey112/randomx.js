#!/usr/bin/env bun

import esbuild from 'esbuild'
import type { BuildOptions, Plugin } from 'esbuild'
import { $ } from 'bun'

const PRODUCTION = !!process.env.PRODUCTION

const k = await $`PRODUCTION=${+PRODUCTION} make -j$(nproc)`.nothrow() // make all

if (k.exitCode !== 0) {
	process.exit(k.exitCode)
}

// change `production.ts` to export a boolean depending on the condition at build time
const production_intercept_plugin: Plugin = {
	name: 'production_intercept',
	setup(build) {
		build.onResolve({ filter: /production$/ }, async (args) => {
			return {
				path: args.path,
				namespace: 'production',
			}
		})

		build.onLoad({ filter: /production$/, namespace: 'production' }, async (args) => {
			return {
				contents: `export default ${PRODUCTION}`,
				loader: 'js',
			}
		})
	}
}

const opt: BuildOptions = {
	sourcemap: true,
	minify: true,
	bundle: true,
	entryPoints: ['src/index.ts'],
	loader: {
		'.wasm': 'binary',
	},
	plugins: [production_intercept_plugin],
	define: {
		'PRODUCTION': JSON.stringify(PRODUCTION),
	},
}

await Promise.all([
	esbuild.build({
		...opt,
		outdir: 'dist/web',
		target: ['chrome91', 'firefox89', 'safari16'],
		platform: 'browser',
		format: 'esm',
	}),

	esbuild.build({
		...opt,
		outdir: 'dist/cjs',
		target: ['node17'],
		platform: 'node',
		format: 'cjs',
	}),

	esbuild.build({
		...opt,
		outdir: 'dist/esm',
		target: ['node17'],
		platform: 'node',
		format: 'esm',
	}),

	$`bunx dts-bundle-generator -o dist/index.d.ts --no-banner src/index.ts`.nothrow().then(
		() => $`cp dist/index.d.ts dist/cjs/index.d.ts; cp dist/index.d.ts dist/esm/index.d.ts`
	),
])
