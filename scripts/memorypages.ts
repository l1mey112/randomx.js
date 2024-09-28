#!/usr/bin/env bun

import { $ } from "bun"

const file_wasm = process.argv[2]

if (!file_wasm) {
	console.error('usage: ./memorypages.ts <file.wasm>')
	process.exit(1)
}

const wasm_objdump = await $`wasm-objdump -x ${file_wasm}`.text()

// extract the memory
//  - memory[0] pages: initial=4097 <- env.memory
//                             ^^^^
const memory = wasm_objdump.match(/.*memory.*initial=([0-9]+).*/)

if (!memory) {
	console.error('memory not found')
	process.exit(1)
}

console.log(memory[1])
