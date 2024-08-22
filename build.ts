import esbuild from 'esbuild'
import type { BuildOptions } from 'esbuild'
import { dtsPlugin } from 'esbuild-plugin-d.ts'
import { $ } from 'bun'
import path from 'node:path'

const wat_plugin: esbuild.Plugin = {
	name: 'wat-embed',
	setup(build: esbuild.PluginBuild) {
		build.onResolve({ filter: /\.wat\?embed$/ }, args => {
			if (args.resolveDir === '') {
				return
			}

			args.path = args.path.replace(/\?embed$/, '')
			
			return {
				path: path.isAbsolute(args.path) ? args.path : path.join(args.resolveDir, args.path),
				namespace: 'wat-embed-import',
			}
		})

		build.onLoad({ filter: /.*/, namespace: 'wat-embed-import' }, async (args) => {
			const k = await $`wat2wasm --enable-all ${args.path} --output=-`.arrayBuffer()

			return {
				contents: Buffer.from(k),
				loader: 'binary'
			}
		})
	}
}


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
}

await esbuild.build({
	...opt,
	outdir: 'dist/web',
	target: ['chrome61', 'firefox60', 'safari11'],
	platform: 'browser',
	format: 'esm',
	splitting: true,
	plugins: [wat_plugin]
})

await esbuild.build({
	...opt,
	outdir: 'dist/cjs',
	target: ['node19'],
	platform: 'neutral',
	format: 'esm',
	splitting: true,
	metafile: true,
	plugins: [wat_plugin, esm_to_cjs]
})

await esbuild.build({
	...opt,
	outdir: 'dist/esm',
	target: ['node19'],
	platform: 'node',
	format: 'esm',
	splitting: true,
	plugins: [wat_plugin]
}) 
