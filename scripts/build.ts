#!/usr/bin/env bun

import esbuild from 'esbuild'
import type { BuildOptions, Plugin } from 'esbuild'
import { $ } from 'bun'
import path from 'node:path'

// 0: production
// 1: single step VM by breakpoint (with printf)
// 2: performance counters (with printf)
const INSTRUMENT = parseInt(process.env.INSTRUMENT || '0') || 0
const k = await $`INSTRUMENT=${INSTRUMENT} make -j$(nproc)`.nothrow() // make all

if (k.exitCode !== 0) {
	process.exit(k.exitCode)
}

/* const BASEPATHS = [
	'pkg-randomx.js/index.ts',
	'pkg-randomwow.js/index.ts',
	'pkg-xmr-rx-webminer/index.ts',
] */

const BASEPATHS = {
	'pkg-randomx.js': ['index.ts'],
	'pkg-randomwow.js': ['index.ts'],
	'pkg-xmr-rx-webminer': ['index.ts'],
}

async function compile_for(PATH: string, INDICES: string[]) {
	// set INDICES to PATH/INDICES
	for (let i = 0; i < INDICES.length; i++) {
		INDICES[i] = `${PATH}/${INDICES[i]}`
	}

	const wasm_plugin: Plugin = {
		name: 'wasm',
		setup(build) {
			build.onResolve({ filter: /(vm|dataset)\.wasm$/ }, (args) => {
				if (args.namespace === 'wasm-stub') {
					return {
						path: args.path,
						namespace: 'wasm-binary',
					}
				}
				return {
					path: args.path,
					namespace: 'wasm-stub',
				}
			})

			build.onLoad({ filter: /.*/, namespace: 'wasm-stub' }, async (args) => {
				const wasm_pages = await $`scripts/memorypages.ts ${PATH}/${args.path}`.text()

				return {
					contents: `import wasm from "${args.path}"
						export default wasm
						export const wasm_pages = ${wasm_pages}`,
					loader: 'ts',
				}
			})

			build.onLoad({ filter: /.*/, namespace: 'wasm-binary' }, async (args) => {
				const file = await Bun.file(`${PATH}/${args.path}`).arrayBuffer()

				return {
					contents: new Uint8Array(file),
					loader: 'binary',
				}
			})
		}
	}

	const url_plugin: Plugin = {
		name: 'url',
		setup(build) {
			const simplecache = new Map<string, string>()
			
			build.onResolve({ filter: /^url:/ }, (args) => {
				return {
					path: path.resolve(args.resolveDir, args.path.slice(4)),
					namespace: 'url-import',
				}
			})

			build.onLoad({ filter: /.*/, namespace: 'url-import' }, async (args) => {
				if (simplecache.has(args.path)) {
					return {
						contents: simplecache.get(args.path),
						loader: 'dataurl',
					}
				}

				const opt: BuildOptions = {
					...build.initialOptions,
					entryPoints: [args.path],
					bundle: true,
					format: 'esm',
					write: false,
					sourcemap: false,
				}

				// @ts-expect-error
				opt.define.FORMAT = '"esm"'

				const built = await esbuild.build(opt as { write: false })

				const text = built.outputFiles[0].text
				simplecache.set(args.path, JSON.stringify(text))

				const dataurl = `data:application/javascript;utf8,${encodeURIComponent(text)}`

				return {
					loader: 'js',
					contents: `export default new URL(${JSON.stringify(dataurl)})`,
				}
			})
		}		
	}

	const opt: BuildOptions = {
		sourcemap: true,
		minify: INSTRUMENT === 0,
		bundle: true,
		entryPoints: INDICES,
		loader: {
			'.wasm': 'binary',
		},
		external: ['os', 'worker_threads'],
		plugins: [wasm_plugin, url_plugin],
	}

	await Promise.all([
		esbuild.build({
			...opt,
			outdir: `${PATH}/dist/web`,
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
			outdir: `${PATH}/dist/cjs`,
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
			outdir: `${PATH}/dist/esm`,
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
	
		$`bunx dts-bundle-generator --project tsconfig.build.json -o ${PATH}/dist/index.d.ts --no-banner ${INDICES[0]}`.nothrow().then(
			() => $`cp ${PATH}/dist/index.d.ts ${PATH}/dist/cjs/index.d.ts; cp ${PATH}/dist/index.d.ts ${PATH}/dist/esm/index.d.mts`
		),
	])
}

const promises: Promise<any>[] = []

for (const [PATH, ENTRYPOINTS] of Object.entries(BASEPATHS)) {
	promises.push(compile_for(PATH, ENTRYPOINTS))
}

await Promise.all(promises)
