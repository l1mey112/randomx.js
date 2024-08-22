import esbuild from 'esbuild'
import type { BuildOptions } from 'esbuild'
import { dtsPlugin } from 'esbuild-plugin-d.ts'
import { $ } from 'bun'
import path from 'node:path'

const k = await $`make`.nothrow() // make all

if (k.exitCode !== 0) {
	process.exit(k.exitCode)
}

const wat_plugin: esbuild.Plugin = {
	name: 'wat-embed',
	setup(build: esbuild.PluginBuild) {
		const cache = new Map<string, Buffer>()
		
		build.onResolve({ filter: /\.wat\?embed$/ }, (args) => {
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
			if (!cache.has(args.path)) {
				const k = await $`wat2wasm --enable-all ${args.path} --output=-`.arrayBuffer()
				cache.set(args.path, Buffer.from(k))
			}

			return {
				contents: cache.get(args.path),
				loader: 'binary'
			}
		})
	}
}

const c_plugin: esbuild.Plugin = {
	name: 'c-compile',
	setup(build: esbuild.PluginBuild) {
		build.onResolve({ filter: /\.c$/ }, async (args) => {			
			if (args.resolveDir === '') {
				return
			}

			// 1. compile c to wasm (with opt)
			// 2. convert wasm to js (with opt)
			// 3. return wasm module path
			// 4. return js module path
			// 5. possibly cache the whole thing

			return {
				path: path.isAbsolute(args.path) ? args.path : path.join(args.resolveDir, args.path),
				namespace: 'c-compile-needs-build',
			}
		})

		build.onLoad({ filter: /.*/, namespace: 'c-compile-needs-build' }, async (args) => {			
			console.log(args)

			await $`clang --target=wasm32 -nostdlib -fno-builtin -I./include \\
				-Oz -msimd128 -mbulk-memory \\
				-Wl,--no-entry -Wl,-z,stack-size=8192 \\
				${args.path} -o example.wasm`

			return { contents: 'console.log("hello")' }
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
	loader: {
		'.wasm': 'binary',
	}
}

const plug = [] /* [wat_plugin, c_plugin] */

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
