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

// 000002 func[0] <umul128hi64>:
//  000003: 03 7e                      | local[2..4] type=i64
//  000005: 20 01                      | local.get 1
//  000007: 42 20                      | i64.const 32
//  ......
//  00005c: 0b                         | end

// find func[*] <the_function>:
// extract all lines until end

const obj = await $`wasm-objdump --section-offsets -d ${file_wasm}`.text()
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

	// JIT parameters
	if (the_function.startsWith('P_')) {
		continue
	}

	const stamps = func[0].split('\n').splice(1)

	// 000003: 03 7e  | local[2..4] type=i64
	// extract the hex, then extract everything after pipe
	// everything after the colon is hex, everything after the pipe is the instruction
	// extract bytes and instruction comments

	// the objdump output doesn't include the amount of local entries in the vector
	// so we have to manually add it

	let local_entries = 0

	type Thunk = {
		name: string
		hex: string[][]
		comment: string[]
	}

	const bytes_and_comments: Thunk[] = []
	let current_thunk: Thunk = {
		name: the_function,
		hex: [],
		comment: [],
	}

	for (const stamp of stamps) {
		const [bytes, comment] = stamp.split('|').map((s) => s.trim())
		const hex_spaces = bytes.split(' ').slice(1).join(' ')

		// "03 7e" ->  "0x03, 0x7e,"
		const hex = hex_spaces.split(' ').map((h) => `0x${h}`)

		// 0x10, 0x00, // call 0 <mul128hi>
		//       ^^^^ -> F(0x00) - replace with function offset

		if (comment.startsWith('call') || comment.startsWith('return_call')) {			
			// call 1 <P_ssh_code>

			// extract the parameter P_
			const param = comment.match(/<P_(\w+)>/)
			if (!param) {
				hex[hex.length - 1] = `F(${hex[hex.length - 1]})`
			} else {
				const param_name = param[1]
				// start a new thunk
				bytes_and_comments.push(current_thunk)
				current_thunk = {
					name: the_function + '.' + param_name.slice(1),
					hex: [],
					comment: [],
				}
				continue
			}
		}

		if (comment.startsWith('local[')) {
			local_entries += 1
		}

		current_thunk.hex.push(hex)
		current_thunk.comment.push(comment)
	}
	bytes_and_comments.push(current_thunk)

	if (local_entries > 127) {
		console.error('TODO: implement LEB128 encoding for local entries')
		console.error('      you probably have too many anyway')
		process.exit(1)
	}

	let j = 0
	for (const thunk of bytes_and_comments) {
		console.log(`// ${thunk.name}`)
		let thunk_name = thunk.name
		if (j != 0) {
			thunk_name = the_function + `_${j}`
		}

		console.log(`static const uint8_t STUB_${thunk_name.toUpperCase()}[] = {`)

		let byte_length, largest_to_pad = 0
		const hex_strings: string[] = []

		for (let i = 0; i < thunk.hex.length; i++) {
			const hex = thunk.hex[i]

			const hex_string = hex.join(', ') + ','
			byte_length = hex.length

			if (hex_string.length > largest_to_pad) {
				largest_to_pad = hex_string.length
			}

			hex_strings.push(hex_string)
		}
		
		// needs local entries
		if (j == 0) {
			const local_entries_comment = `local[${local_entries}]`
			const local_entries_hex = `0x${local_entries.toString(16).padStart(2, '0')},`

			if (local_entries_comment.length > largest_to_pad) {
				largest_to_pad = local_entries_comment.length
			}

			console.log(`\t${local_entries_hex.padEnd(largest_to_pad)} // ${local_entries_comment}`)
		}

		for (let i = 0; i < thunk.hex.length; i++) {
			const comment = thunk.comment[i]

			const hex_string = hex_strings[i]
			const line = `\t${hex_string.padEnd(largest_to_pad)} // ${comment}`
			console.log(line)
		}

		console.log('};')

		console.log()
		
		j++
	}

	i++
}

console.log(`#undef F
#undef FUNC_OFFSET`)
