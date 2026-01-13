import { test, expect } from 'vitest'
import { argon2fill } from './rx_harness'

test('argon2fill', () => {
	const items = argon2fill(new TextEncoder().encode('test key 000'))

	expect(items[0]).toEqual(0x191e0e1d23c02186n)
	expect(items[1568413]).toEqual(0xf1b62fe6210bf8b1n)
	expect(items[33554431]).toEqual(0x1f47f056d05cd99bn)
})
