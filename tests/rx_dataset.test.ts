import { test, expect } from 'bun:test'
import { buffer, module }  from './rx_harness'
import { randomx_init_cache, randomx_superscalarhash, type RxCache } from '../pkg-randomx.js/dist/esm/index.mjs'
import type { RxCacheHandle } from '../src/dataset/dataset'

test('chained programs', () => {
	const key = new TextEncoder().encode('test key 000')
	
	buffer.set(key)
	module.ssh_init_newblake(key.length)

	const superscalar = [
		Buffer.from("d3a4a6623738756f77e6104469102f082eff2a3e60be7ad696285ef7dfc72a61", 'hex'),
		Buffer.from("f5e7e0bbc7e93c609003d6359208688070afb4a77165a552ff7be63b38dfbc86", 'hex'),
		Buffer.from("85ed8b11734de5b3e9836641413a8f36e99e89694f419c8cd25c3f3f16c40c5a", 'hex'),
		Buffer.from("5dd956292cf5d5704ad99e362d70098b2777b2a1730520be52f772ca48cd3bc0", 'hex'),
		Buffer.from("6f14018ca7d519e9b48d91af094c0f2d7e12e93af0228782671a8640092af9e5", 'hex'),
		Buffer.from("134be097c92e2c45a92f23208cacd89e4ce51f1009a0b900dbe83b38de11d791", 'hex'),
		Buffer.from("268f9392c20c6e31371a5131f82bd7713d3910075f2f0468baafaa1abd2f3187", 'hex'),
		Buffer.from("c668a05fd909714ed4a91e8d96d67b17e44329e88bc71e0672b529a3fc16be47", 'hex'),
		Buffer.from("99739351315840963011e4c5d8e90ad0bfed3facdcb713fe8f7138fbf01c4c94", 'hex'),
		Buffer.from("14ab53d61880471f66e80183968d97effd5492b406876060e595fcf9682f9295", 'hex'),
	]

	for (let i = 0; i < 10; ++i) {
		module.ssh_generate_hash256()
		const hash = Buffer.from(buffer.slice(0, 32))
		expect(hash).toEqual(superscalar[i])
	}
})

test('dataset initialisation', () => {
	function test_with(cache: RxCacheHandle) {
		const hash = randomx_superscalarhash(cache)

		const dataset_items_0 = hash(0n)
		const dataset_items_10000000 = hash(10000000n)
		const dataset_items_20000000 = hash(20000000n)
		const dataset_items_30000000 = hash(30000000n)

		expect(dataset_items_0[0]).toEqual(BigInt.asIntN(64, 0x680588a85ae222dbn))
		expect(dataset_items_10000000[0]).toEqual(BigInt.asIntN(64, 0x7943a1f6186ffb72n))
		expect(dataset_items_20000000[0]).toEqual(BigInt.asIntN(64, 0x9035244d718095e1n))
		expect(dataset_items_30000000[0]).toEqual(BigInt.asIntN(64, 0x145a5091f7853099n))
	}
	
	let n: RxCache

	n = randomx_init_cache('test key 000')
	expect(n.handle.memory.buffer).toBeInstanceOf(ArrayBuffer)
	test_with(n.handle)
	n = randomx_init_cache('test key 000', { shared: true })
	expect(n.handle.memory.buffer).toBeInstanceOf(SharedArrayBuffer)
	test_with(n.handle)
})
