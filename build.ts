import esbuild from 'esbuild';
import type { BuildOptions } from 'esbuild';
import { dtsPlugin } from 'esbuild-plugin-d.ts'

const opt: BuildOptions = {
	entryPoints: ['src/index.ts'],
	sourcemap: true,
	minify: true,
	bundle: true,
	plugins: [dtsPlugin()],
	loader: {
		'.wasm': 'binary',
	}
}

let wat_plugin = {
	name: 'wat',
	setup(build: esbuild.PluginBuild) {
		build.onResolve({ filter: /\.wat$/ }, args => {
			
		})
	}
}

await esbuild.build({
	...opt,
	outdir: 'dist/web',
	target: ['chrome58', 'firefox57', 'safari11', 'edge16'],
	format: 'iife',
	platform: 'browser',
	globalName: 'randomx'
});

await esbuild.build({
	...opt,
	outdir: 'dist/cjs',
	target: ['node19'],
	platform: 'neutral',
	format: 'cjs',
});

await esbuild.build({
	...opt,
	outdir: 'dist/esm',
	target: ['node19'],
	platform: 'node',
	format: 'esm'
});
