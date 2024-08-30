import { test, expect } from 'bun:test'
import { blake2b_generator, hash512 } from './harness'
import { random } from 'nanoid'

test('blake2b_generator', () => {
	for (let i = 0; i < 1024; i++) {
		const key = random(i == 0 ? 0 : 60)

		const assumed_key = new Uint8Array(64)
		assumed_key.set(key)
		
		const generator = blake2b_generator(key)
		let initial = hash512(assumed_key)


		// check start
		expect(generator.i32()).toEqual(new Int32Array(initial.buffer, 0, 1)[0])

		// skip over the rest, 60 bytes
		for (let i = 0; i < 60; i++) {
			generator.u8()
		}

		initial = hash512(initial)
		expect(generator.i32()).toEqual(new Int32Array(initial.buffer, 0, 4)[0])
	}
})
