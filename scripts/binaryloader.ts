#!/usr/bin/env bun

import { plugin, type BunPlugin } from "bun"

export const binayloader: BunPlugin = {
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

await plugin(binayloader)
