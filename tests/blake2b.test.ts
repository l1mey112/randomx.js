import { test, expect } from 'bun:test'
import { blake2b } from '../src/blake2b/blake2b'
import { random } from 'nanoid'

const wasm_module = await blake2b('simd')
const js_module = await blake2b('js')

test('wasm.256', () => {
	for (let i = 0; i < 1024; i++) {
		const bytes = random(i)
		
		const bun_256 = new Bun.CryptoHasher('blake2b256')
		bun_256.update(bytes)
		const bun_out = bun_256.digest()

		const module_out = Buffer.from(wasm_module.hash256(bytes))

		expect(bun_out).toEqual(module_out)
	}
})

test('wasm.512', () => {
	for (let i = 0; i < 1024; i++) {
		const bytes = random(i)
		
		const bun_512 = new Bun.CryptoHasher('blake2b512')
		bun_512.update(bytes)
		const bun_out = bun_512.digest()

		const module_out = Buffer.from(wasm_module.hash512(bytes))

		expect(bun_out).toEqual(module_out)
	}
})

test('js.256', () => {
	for (let i = 0; i < 1024; i++) {
		const bytes = random(i)
		
		const bun_256 = new Bun.CryptoHasher('blake2b256')
		bun_256.update(bytes)
		const bun_out = bun_256.digest()

		const module_out = Buffer.from(js_module.hash256(bytes))

		expect(bun_out).toEqual(module_out)
	}
})

test('js.512', () => {
	for (let i = 0; i < 1024; i++) {
		const bytes = random(i)
		
		const bun_512 = new Bun.CryptoHasher('blake2b512')
		bun_512.update(bytes)
		const bun_out = bun_512.digest()

		const module_out = Buffer.from(js_module.hash512(bytes))

		expect(bun_out).toEqual(module_out)
	}
})
