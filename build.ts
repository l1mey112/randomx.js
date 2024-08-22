import esbuild from 'esbuild'
import type { BuildOptions } from 'esbuild'
import { dtsPlugin } from 'esbuild-plugin-d.ts'
import { $ } from 'bun'

const k = await $`make`.nothrow() // make all

if (k.exitCode !== 0) {
	process.exit(k.exitCode)
}

await $`rm -rf dist`

const com: BuildOptions = {
	sourcemap: true,
	minify: true,
	bundle: true,
}

const esm_to_cjs: esbuild.Plugin = {
	name: 'esm-to-cjs',
	setup(build) {
		build.onEnd(async (result) => {
			const out_files = Object.keys(result.metafile?.outputs ?? {})
			const js_files = out_files.filter((f) => f.endsWith('js'))

			await esbuild.build({
				...com,
				outdir: build.initialOptions.outdir,
				entryPoints: js_files,
				allowOverwrite: true,
				format: 'cjs',
				logLevel: 'error',
			})
		})
	},
}

const opt: BuildOptions = {
	...com,
	entryPoints: ['src/index.ts'],
	loader: {
		'.wasm': 'binary',
	}
}

const plug = []

await esbuild.build({
	...opt,
	outdir: 'dist/web',
	target: ['chrome61', 'firefox60', 'safari11'],
	platform: 'browser',
	format: 'esm',
	splitting: true,
	plugins: [...plug]
})

await esbuild.build({
	...opt,
	outdir: 'dist/cjs',
	target: ['node19'],
	platform: 'neutral',
	format: 'esm',
	splitting: true,
	metafile: true,
	plugins: [...plug, esm_to_cjs]
})

await esbuild.build({
	...opt,
	outdir: 'dist/esm',
	target: ['node19'],
	platform: 'node',
	format: 'esm',
	splitting: true,
	plugins: [...plug]
}) 
