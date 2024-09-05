import { test, expect } from 'bun:test'
import { argon2fill } from './harness'
import { $ } from 'bun'

test('semifloat', async () => {
	await $`${import.meta.dirname}/semifloat/semifloat`
})
