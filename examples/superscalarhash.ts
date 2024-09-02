import { randomx_cache, randomx_superscalarhash } from '../src/dataset/dataset'

const cache = await randomx_cache()
const hash = await randomx_superscalarhash(cache)

for (let i = 0n; i < 10n; ++i) {
	const parts = hash(i).map(value => '0x' + BigInt.asUintN(64, value).toString(16))
	console.log(parts)
}
