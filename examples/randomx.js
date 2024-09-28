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

const samples = []

const avg = () => samples.reduce((a, b) => a + b) / samples.length

let i = 0
while (i < 100) {
	const time_now = performance.now()
	const hash = randomx.calculate_hex_hash('Lorem ipsum dolor sit amet')
	const time = performance.now() - time_now
	if (hash !== '300a0adb47603dedb42228ccb2b211104f4da45af709cd7547cd049e9489c969') {
		console.error('hash mismatch', hash)
	}
	samples.push(time)

	if (i % 4 === 0) {
		console.log(`time ${time.toFixed(1)} ms, ${(1000 / avg()).toFixed(1)} H/s`)
	}

	i++
}

console.log(`average hashrate: ${(1000 / avg()).toFixed(1)} H/s`)
