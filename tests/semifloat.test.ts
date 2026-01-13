import { test, expect } from 'vitest'
import { execSync } from 'node:child_process'

test('semifloat', async () => {
	expect(() => execSync(`${import.meta.dirname}/semifloat/semifloat`)).not.toThrow()
})
