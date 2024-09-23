import { test, expect } from 'bun:test'
import { randomx_create_vm, randomx_init_cache } from '../src'

test('no crashes', async () => {
	const randomx_cache = randomx_init_cache()
	const randomx = randomx_create_vm(randomx_cache)

	randomx.calculate_hex_hash('hello world')
})
