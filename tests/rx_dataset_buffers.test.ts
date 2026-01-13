import { test, expect } from 'vitest'
import { randomx_init_cache as randomx_init_cache_unshared, type RxCache } from '../pkg-randomx.js/dist/esm/index.mjs'
import { randomx_init_cache as randomx_init_cache_shared } from '../pkg-randomx.js-shared/dist/esm/index.mjs'
import type { RxCacheHandle } from '../src/dataset/dataset'

type RxSuperscalarHash = (item_index: bigint) => [bigint, bigint, bigint, bigint, bigint, bigint, bigint, bigint]

// implementation detail
function randomx_superscalarhash(cache: RxCacheHandle): RxSuperscalarHash {
	const wi = new WebAssembly.Instance(cache.thunk, {
		e: {
			m: cache.memory
		}
	})

	type SuperscalarHashModule = {
		d: RxSuperscalarHash
	}

	const exports = wi.exports as SuperscalarHashModule
	return exports.d
}

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

	n = randomx_init_cache_unshared('test key 000', { shared: false })
	expect(n.handle.memory.buffer).toBeInstanceOf(ArrayBuffer)
	test_with(n.handle)
	n = randomx_init_cache_shared('test key 000', { shared: true })
	expect(n.handle.memory.buffer).toBeInstanceOf(SharedArrayBuffer)
	test_with(n.handle)
})
