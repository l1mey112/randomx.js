import { test, expect } from 'vitest'
import { program_vm } from "./rx_harness"

// this tests blake2b, scratchpad initialisation (fillAes1Rx4),
// program generation (fillAes4Rx4), and vm initialisation

test('program vm 0', () => {
	const vm = program_vm(new TextEncoder().encode('hello'))

	expect(vm.a_bin[0]).toEqual(0x41bb3c3cc307de8en)
	expect(vm.a_bin[1]).toEqual(0x40dd3e1623ac96cen)
	expect(vm.a_bin[2]).toEqual(0x40509b760afefc60n)
	expect(vm.a_bin[3]).toEqual(0x414099d4886d7891n)
	expect(vm.a_bin[4]).toEqual(0x410e2dde8c8596cbn)
	expect(vm.a_bin[5]).toEqual(0x41916795a9272b03n)
	expect(vm.a_bin[6]).toEqual(0x4186629f5638d640n)
	expect(vm.a_bin[7]).toEqual(0x406f9e23743f7f1fn)

	expect(vm.ma).toEqual(378651456)
	expect(vm.mx).toEqual(1483856981)
	expect(vm.read_reg0).toEqual(1)
	expect(vm.read_reg1).toEqual(3)
	expect(vm.read_reg2).toEqual(5)
	expect(vm.read_reg3).toEqual(7)

	expect(vm.dataset_offset).toEqual(29711616n)

	expect(vm.emask[0]).toEqual(0x320000000031d61dn)
	expect(vm.emask[1]).toEqual(0x34000000001c292dn)

	expect(vm.fprc).toEqual(0)
})

test('program vm 1', () => {
	const vm = program_vm(new TextEncoder().encode('testing hello'))

	expect(vm.a_bin[0]).toEqual(0x40efd5a5d3b7938an)
	expect(vm.a_bin[1]).toEqual(0x40d6b7c3aaef5503n)
	expect(vm.a_bin[2]).toEqual(0x3ff7a8c8e4c03e2cn)
	expect(vm.a_bin[3]).toEqual(0x40779729a3eafc24n)
	expect(vm.a_bin[4]).toEqual(0x416f9dc08e1500e4n)
	expect(vm.a_bin[5]).toEqual(0x4170e528b88771b8n)
	expect(vm.a_bin[6]).toEqual(0x41a985a0fe16c16an)
	expect(vm.a_bin[7]).toEqual(0x415ad3bcf8e3cdc3n)

	expect(vm.ma).toEqual(1447797056)
	expect(vm.mx).toEqual(3437775971)
	expect(vm.read_reg0).toEqual(0)
	expect(vm.read_reg1).toEqual(2)
	expect(vm.read_reg2).toEqual(4)
	expect(vm.read_reg3).toEqual(7)

	expect(vm.dataset_offset).toEqual(8800512n)

	expect(vm.emask[0]).toEqual(0x33000000001d3ea7n)
	expect(vm.emask[1]).toEqual(0x38000000003865ecn)

	expect(vm.fprc).toEqual(0)
})
