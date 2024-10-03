const { randomx_init_cache, randomx_superscalarhash } = require('../pkg-randomx.js/dist/cjs/index')

const cache = randomx_init_cache()
const hash = randomx_superscalarhash(cache.handle)

function part(value) {
	return hash(BigInt(value)).map(value => '0x' + BigInt.asUintN(64, value).toString(16))
}

console.log('item 0', part(0))
console.log('item 1', part(1))
console.log('item 2', part(2))
