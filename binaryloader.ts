#!/usr/bin/env bun

import { plugin } from "bun"

await plugin({
	name: "binaryloader",
	async setup(build) {
		build.onLoad({ filter: /\.(wasm)$/ }, async (args) => {
			const buffer = await Bun.file(args.path).arrayBuffer()

			return {
				exports: { default: buffer },
				loader: "object",
			}
		})
	},
})
