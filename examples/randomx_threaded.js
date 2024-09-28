const { Worker, isMainThread, parentPort } = require('worker_threads')
const { randomx_create_vm, randomx_init_cache, randomx_machine_id } = require('../pkg-randomx.js/dist/cjs/index')
const { availableParallelism } = require('os')

const threads = availableParallelism()

if (isMainThread) {
	console.log('machine id:', randomx_machine_id())
	const cache = randomx_init_cache('test key 000', { shared: true })

	let hashes = 0

	function onmessage(hash) {
		if (hash !== '300a0adb47603dedb42228ccb2b211104f4da45af709cd7547cd049e9489c969') {
			console.error('hash mismatch', hash)
		}

		hashes++
	}

	for (let i = 0; i < threads; i++) {
		console.log(`initialising thread ${i}`)
		const worker = new Worker(__filename)

		worker.postMessage(cache)
		worker.on('message', onmessage)
	}

	let start_time = performance.now()

	setInterval(() => {
		const time = performance.now()
		const elapsed = (time - start_time) / 1000
		const hashrate = hashes / elapsed
		console.log(`average hashrate: ${hashrate.toFixed(1)} H/s`)
		hashes = 0
		start_time = time
	}, 1000)
} else {
	parentPort.on('message', (cache) => {
		const randomx = randomx_create_vm(cache)

		while (true) {
			const hash = randomx.calculate_hex_hash('Lorem ipsum dolor sit amet')
			parentPort.postMessage(hash)
		}
	})
}
