#!/usr/bin/env bun

import { plugin, type BunPlugin } from "bun"

export const binaryloader: BunPlugin = {
	name: "binaryloader",
	async setup(build) {
		build.onLoad({ filter: /\.(wasm)$/ }, async (args) => {
			const buffer = await Bun.file(args.path).arrayBuffer()

			return {
				exports: { default: new Uint8Array(buffer) },
				loader: "object",
			}
		})
	},
}

// build tools
global.INSTRUMENT = 1
global.FORMAT = "esm"
global.ENVIRONMENT = "node"

await plugin(binaryloader)
