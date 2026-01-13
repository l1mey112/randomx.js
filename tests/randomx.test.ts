import { test, expect } from 'vitest'
import { randomx_create_vm, randomx_init_cache } from '../pkg-randomx.js/dist/esm/index.mjs'

test('test key 000', async () => {
	const randomx_cache = randomx_init_cache('test key 000')
	const randomx = randomx_create_vm(randomx_cache)

	expect(randomx.calculate_hex_hash('This is a test')).toBe('639183aae1bf4c9a35884cb46b09cad9175f04efd7684e7262a0ac1c2f0b4e3f')
	expect(randomx.calculate_hex_hash('Lorem ipsum dolor sit amet')).toBe('300a0adb47603dedb42228ccb2b211104f4da45af709cd7547cd049e9489c969')
	expect(randomx.calculate_hex_hash('sed do eiusmod tempor incididunt ut labore et dolore magna aliqua')).toBe('c36d4ed4191e617309867ed66a443be4075014e2b061bcdaf9ce7b721d2b77a8')
})

test('test key 001', async () => {
	const randomx_cache = randomx_init_cache('test key 001')
	const randomx = randomx_create_vm(randomx_cache)

	expect(randomx.calculate_hex_hash('sed do eiusmod tempor incididunt ut labore et dolore magna aliqua')).toBe('e9ff4503201c0c2cca26d285c93ae883f9b1d30c9eb240b820756f2d5a7905fc')
	expect(randomx.calculate_hex_hash(Buffer.from('0b0b98bea7e805e0010a2126d287a2a0cc833d312cb786385a7c2f9de69d25537f584a9bc9977b00000000666fd8753bf61a8631f12984e3fd44f4014eca629276817b56f32e9b68bd82f416', 'hex'))).toBe('c56414121acda1713c2f2a819d8ae38aed7c80c35c2a769298d34f03833cd5f1')
})
