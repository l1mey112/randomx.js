#!/usr/bin/env bun

import esbuild from 'esbuild'
import type { BuildOptions, Plugin } from 'esbuild'
import { $ } from 'bun'

// 0: production
// 1: single step VM by breakpoint (with printf)
// 2: performance counters (with printf)
const INSTRUMENT = parseInt(process.env.INSTRUMENT || '0') || 0
const k = await $`INSTRUMENT=${INSTRUMENT} make -j$(nproc)`.nothrow() // make all

if (k.exitCode !== 0) {
	process.exit(k.exitCode)
}

const BASEPATHS = ['pkg-randomx.js', 'pkg-randomwow.js']

async function compile_for(PATH: string) {
	const INDEX = `${PATH}/index.ts`

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
		},
	}

	const opt: BuildOptions = {
		sourcemap: true,
		minify: INSTRUMENT === 0,
		bundle: true,
		entryPoints: [INDEX],
		loader: {
			'.wasm': 'binary',
		},
		external: ['os'],
		plugins: [wasm_plugin],
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
	
		$`bunx dts-bundle-generator --project tsconfig.build.json -o ${PATH}/dist/index.d.ts --no-banner ${INDEX}`.nothrow().then(
			() => $`cp ${PATH}/dist/index.d.ts ${PATH}/dist/cjs/index.d.ts; cp ${PATH}/dist/index.d.ts ${PATH}/dist/esm/index.d.mts`
		),
	])
}

await Promise.all(BASEPATHS.map(compile_for))
