import esbuild from 'esbuild'
import type { BuildOptions } from 'esbuild'
import { dtsPlugin } from 'esbuild-plugin-d.ts'
import { $ } from 'bun'
import path from 'node:path'

let wat_plugin = {
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

const opt: BuildOptions = {
	entryPoints: ['src/index.ts'],
	sourcemap: true,
	minify: true,
	bundle: true,
	plugins: [wat_plugin]
}

await esbuild.build({
	...opt,
	outdir: 'dist/web',
	target: ['chrome58', 'firefox57', 'safari11'],
	format: 'iife',
	platform: 'browser',
	globalName: 'randomx'
})

await esbuild.build({
	...opt,
	outdir: 'dist/cjs',
	target: ['node19'],
	platform: 'neutral',
	format: 'cjs',
})

await esbuild.build({
	...opt,
	outdir: 'dist/esm',
	target: ['node19'],
	platform: 'node',
	format: 'esm'
})
