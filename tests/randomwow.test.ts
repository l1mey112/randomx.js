import { test, expect } from 'vitest'
import { randomx_create_vm, randomx_init_cache } from '../pkg-randomwow.js/dist/esm/index.mjs'

test('test key 000', async () => {
	const randomx_cache = randomx_init_cache('test key 000')
	const randomx = randomx_create_vm(randomx_cache)

	expect(randomx.calculate_hex_hash('This is a test')).toBe('aad997cb7bca0aa57d9fa6b3175381ece70766f882c5c925912793a9a6c569d9')
	expect(randomx.calculate_hex_hash('Lorem ipsum dolor sit amet')).toBe('84f5ba1556e3a81993233dda57352e3a06c8838e8a3a1b4a186c580f818cd3e7')
	expect(randomx.calculate_hex_hash('sed do eiusmod tempor incididunt ut labore et dolore magna aliqua')).toBe('228255acd473d5cd1ae6490eed87a383c53a171cfa04e7e1158fbd45cc30719f')
})
