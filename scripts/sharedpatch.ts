#!/usr/bin/env bun

import { adjust_imported_shared_memory } from '../src/wasm_prefix'

// will patch wasm binaries to use shared memory

const file_wasm = process.argv[2]
const line = process.argv[3]

// sharedpatch.ts file.wasm '\x03env\x06memory'

if (!file_wasm || !line) {
	console.error('usage: ./sharedpatch.ts <file.wasm> <prefix>')
	process.exit(1)
}

if (!Bun.file(file_wasm).exists()) {
	console.error('file not found')
	process.exit(1)
}

const binary = new Uint8Array(await Bun.file(file_wasm).arrayBuffer())

// \xXX convert to actual hex

const line_real = line.replace(/\\x([0-9A-Fa-f]{2})/g, (_, hex) => String.fromCharCode(parseInt(hex, 16)))


adjust_imported_shared_memory(binary, line_real, true)

console.log(`patched successfully to 0x03 (shared)`)

await Bun.write(file_wasm, binary)
