import { test, expect } from 'bun:test'
import { module } from './rx_harness'

test('reciprocal', () => {
	expect(module.jit_reciprocal(3n)).toEqual(BigInt.asIntN(64, 12297829382473034410n))
	expect(module.jit_reciprocal(13n)).toEqual(BigInt.asIntN(64, 11351842506898185609n))
	expect(module.jit_reciprocal(33n)).toEqual(BigInt.asIntN(64, 17887751829051686415n))
	expect(module.jit_reciprocal(65537n)).toEqual(BigInt.asIntN(64, 18446462603027742720n))
	expect(module.jit_reciprocal(15000001n)).toEqual(BigInt.asIntN(64, 10316166306300415204n))
	expect(module.jit_reciprocal(3845182035n)).toEqual(BigInt.asIntN(64, 10302264209224146340n))
	expect(module.jit_reciprocal(0xffffffffn)).toEqual(BigInt.asIntN(64, 9223372039002259456n))
})
