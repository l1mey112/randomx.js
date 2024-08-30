import { test, expect } from 'bun:test'
import { random } from 'nanoid'
import { hash256, hash512 } from './harness'

test('hash256', () => {
	for (let i = 0; i < 1024; i++) {
		const bytes = random(i)
		
		const bun_256 = new Bun.CryptoHasher('blake2b256')
		bun_256.update(bytes)
		const bun_out = bun_256.digest()

		const module_out = Buffer.from(hash256(bytes))

		expect(bun_out).toEqual(module_out)
	}
})

test('hash512', () => {
	for (let i = 0; i < 1024; i++) {
		const bytes = random(i)
		
		const bun_512 = new Bun.CryptoHasher('blake2b512')
		bun_512.update(bytes)
		const bun_out = bun_512.digest()

		const module_out = Buffer.from(hash512(bytes))

		expect(bun_out).toEqual(module_out)
	}
})
