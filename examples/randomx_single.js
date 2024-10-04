const { randomx_create_vm, randomx_init_cache, randomx_machine_id } = require('../pkg-randomx.js/dist/cjs/index.js')

console.log('machine id:', randomx_machine_id())

// cache construction takes on average 1 second

let cache = null

{
	const time_now = performance.now()
	cache = randomx_init_cache('test key 000')
	const time = performance.now() - time_now

	console.log(`cache construction time ${time.toFixed(1)} ms`)
}

const randomx = randomx_create_vm(cache)

const time_now = performance.now()
const hash = randomx.calculate_hex_hash('Lorem ipsum dolor sit amet')
const time = performance.now() - time_now

console.log(`time ${time.toFixed(1)} ms`)
