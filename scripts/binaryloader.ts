#!/usr/bin/env bun

import { plugin, type BunPlugin } from "bun"

export const binayloader: BunPlugin = {
	name: "binaryloader",
	async setup(build) {
		// create a toBinary module, one per build
		build.onLoad({ filter: /^__toBinary$/ }, async (args) => {
			return {
				contents: `export default /* @__PURE__ */ (() => {
					var table = new Uint8Array(128);
					for (var i = 0; i < 64; i++) table[i < 26 ? i + 65 : i < 52 ? i + 71 : i < 62 ? i - 4 : i * 4 - 205] = i;
					return (base64) => {
						var n = base64.length, bytes = new Uint8Array((n - (base64[n - 1] == "=") - (base64[n - 2] == "=")) * 3 / 4 | 0);
						for (var i2 = 0, j = 0; i2 < n; ) {
							var c0 = table[base64.charCodeAt(i2++)], c1 = table[base64.charCodeAt(i2++)];
							var c2 = table[base64.charCodeAt(i2++)], c3 = table[base64.charCodeAt(i2++)];
							bytes[j++] = c0 << 2 | c1 >> 4;
							bytes[j++] = c1 << 4 | c2 >> 2;
							bytes[j++] = c2 << 6 | c3;
						}
						return bytes;
					};
				})();`,
			}
		})

		build.onLoad({ filter: /\.(wasm)$/ }, async (args) => {
			const buffer = await Bun.file(args.path).arrayBuffer()

			/* return {
				exports: { default: new Uint8Array(buffer) },
				loader: "object",
			} */
			return {
				contents: `import __toBinary from "__toBinary";
					export default __toBinary("${Buffer.from(buffer).toString('base64')}");`,
			}
		})
	},
}

await plugin(binayloader)
