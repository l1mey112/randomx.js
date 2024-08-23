import { test, expect } from 'bun:test'
import { blake2b } from "../src/blake2b/blake2b";
import { blakegenerator } from "../src/blake2b/blakegenerator";
import { detect } from "../src/detect/detect";

const feature = await detect()
const blake = await blake2b(feature)

test('blakegenerator', () => {
	const generator = blakegenerator(blake)
	let hash = generator.state()

	expect(generator.bytes4()).toEqual(hash.subarray(0, 4))

	// skip over the rest, 60 bytes
	for (let i = 0; i < 60; i++) {
		generator.byte()
	}

	hash = blake.hash512(hash)

	expect(generator.bytes4()).toEqual(hash.subarray(0, 4))
})
