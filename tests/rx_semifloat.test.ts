import { test, expect } from 'bun:test'
import { $ } from 'bun'

test('semifloat', async () => {
	const p = await $`${import.meta.dirname}/rx_semifloat/rx_semifloat`.nothrow()

	expect(p.exitCode).toBe(0)
})
