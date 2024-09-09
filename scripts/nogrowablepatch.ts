#!/usr/bin/env bun

import { locate_import } from '../src/wasm_prefix'

// will patch wasm binaries that import memory with an unlimited growable limit to a non-growable limit

const file_wasm = process.argv[2]
const line = process.argv[3]

// nogrowablepatch.ts file.wasm '\x03env\x06memory'

if (!file_wasm || !line) {
	console.error('usage: ./nogrowablepatch.ts <file.wasm> <prefix>')
	process.exit(1)
}

if (!Bun.file(file_wasm).exists()) {
	console.error('file not found')
	process.exit(1)
}

const binary = new Uint8Array(await Bun.file(file_wasm).arrayBuffer())

// \xXX convert to actual hex

const line_real = line.replace(/\\x([0-9A-Fa-f]{2})/g, (_, hex) => String.fromCharCode(parseInt(hex, 16)))

let p = locate_import(binary, line_real)

// 0x02 memtype

// memtype ::= limits
// limits  ::= 0x00 n:u32         => { min n }
//           | 0x01 n:u32 m:u32   => { min n, max m }
//           | 0x03 n:u32 m:u32   => { min n, max m, shared }

if (binary[p] !== 0x02) {
	console.error('expected memtype')
	process.exit(1)
}

p += 1 // 0x02

if (binary[p] !== 0x00) {
	console.log('already patched')
	process.exit(0)
}

function u32p(buf: Uint8Array, p: number): [n: number, p: number] {
	let num = 0
	let shift = 0
	while (true) {
		const byt = buf[p++]
		num |= (byt & 0x7f) << shift
		if (byt >> 7 === 0) {
			break
		} else {
			shift += 7
		}
	}
	return [num, p]
}

// find import section

let im_found = false
let im = 8 // skip magic and version
while (im < binary.length) {
	if (binary[im] === 0x02) {
		im_found = true
		break
	}
	im++

	const [n, imp] = u32p(binary, im)
	im = imp + n
}

if (!im_found) {
	console.error('import section not found')
	process.exit(1)
}

if (im >= p) {
	console.error('import section after memtype')
	process.exit(1)
}

im += 1 // switch to u32p

// 0x00 n:u32
//      ^^^^^ duplicate this number twice, change to 0x01

const tagb = p++
const [n, p2] = u32p(binary, p)
const nlen = p2 - p

// insert a copy of this number from p-p2 right after p2
// insert more bytes
// need to also patch the import section

const newbuf = new Uint8Array(binary.length + nlen)
newbuf.set(binary.subarray(0, p2), 0)
newbuf.set(binary.subarray(p, p2), p2)
newbuf.set(binary.subarray(p2), p2 + nlen)

newbuf[im] += nlen // you need to patch the u32 LEB128, but im not bothered tbh

newbuf[tagb] = 0x01

// print indicies
console.log(`patched successfully to 0x01, page size of ${n}`)

await Bun.write(file_wasm, newbuf)
