#!/usr/bin/env bun

import { $ } from 'bun'

// wasm-objdump --section-offsets -d $file_wasm
// find function with name $file_no_ext

// use regex to extract the function body, then take hex
// return a header file which contains the wasm bytecode

// 0x03, 0x7e // | local[2..4] type=i64

const file_wasm = process.argv[2]

if (!file_wasm) {
	console.error('usage: ./stubgen.ts <file.wasm>')
	process.exit(1)
}

const obj = await $`wasm-objdump --section-offsets -d ${file_wasm}`.text()

// 000002 func[0] <umul128hi64>:
//  000003: 03 7e                      | local[2..4] type=i64
//  000005: 20 01                      | local.get 1
//  000007: 42 20                      | i64.const 32
//  ......
//  00005c: 0b                         | end

// find func[*] <the_function>:
// extract all lines until end

const funcs = obj.matchAll(new RegExp(/func\[\d+\] <(\w+)>:[\s\S]+?end/g))

console.log('#pragma once')
console.log()
console.log('#include <stdint.h>')
console.log()

console.log(`#ifndef FUNC_OFFSET
#define FUNC_OFFSET 0
#endif

#define F(x) (x + FUNC_OFFSET)
`)

let i = 0
for (const func of funcs) {
	const the_function = func[1]
	const stamps = func[0].split('\n').splice(1)

	// 000003: 03 7e  | local[2..4] type=i64
	// extract the hex, then extract everything after pipe
	// everything after the colon is hex, everything after the pipe is the instruction
	// extract bytes and instruction comments

	// the objdump output doesn't include the amount of local entries in the vector
	// so we have to manually add it

	let largest_to_pad = 0
	let byte_length = 0
	let local_entries = 0
	const bytes_and_comments = stamps.map((stamp) => {
		const [bytes, comment] = stamp.split('|').map((s) => s.trim())
		const hex_spaces = bytes.split(' ').slice(1).join(' ')

		// "03 7e" ->  "0x03, 0x7e,"
		const hex = hex_spaces.split(' ').map((h) => `0x${h}`)

		// 0x10, 0x00, // call 0 <mul128hi>
		//       ^^^^ -> F(0x00) - replace with function offset

		if (comment.startsWith('call') || comment.startsWith('return_call')) {
			hex[hex.length - 1] = `F(${hex[hex.length - 1]})`
		}

		const hex_string = hex.join(', ') + ','
		byte_length += hex.length

		if (hex_string.length > largest_to_pad) {
			largest_to_pad = hex_string.length
		}

		if (comment.startsWith('local[')) {
			local_entries += 1
		}

		return [hex_string, comment]
	})

	if (local_entries > 127) {
		console.error('TODO: implement LEB128 encoding for local entries')
		console.error('      you probably have too many anyway')
		process.exit(1)
	}

	// prepend the local entries
	const local_entries_comment = `local[${local_entries}]`
	bytes_and_comments.unshift([`0x${local_entries.toString(16).padStart(2, '0')},`, local_entries_comment])
	if (local_entries_comment.length > largest_to_pad) {
		largest_to_pad = local_entries_comment.length
	}

	if (i > 0) {
		console.log()
	}

	console.log(`// ${the_function}`)
	console.log(`static const uint8_t STUB_${the_function.toUpperCase()}[] = {`)

	for (const [hex, comment] of bytes_and_comments) {
		const line = `\t${hex.padEnd(largest_to_pad)} // ${comment}`
		console.log(line)
	}

	console.log(`};`)

	i++
}

console.log()

console.log(`#undef F
#undef FUNC_OFFSET`)