const { Worker, isMainThread, parentPort } = require('worker_threads')
const { randomx_create_vm, randomx_init_cache, randomx_machine_id } = require('../pkg-randomx.js-shared/dist/cjs/index')
const { availableParallelism } = require('os')

const threads = availableParallelism()

if (isMainThread) {
	console.log('machine id:', randomx_machine_id())
	const cache = randomx_init_cache('test key 000')
	let hashes = 0

	function onmessage(hash) {
		hashes++
	}

	for (let i = 0; i < threads; i++) {
		console.log(`initialising thread ${i}`)
		const worker = new Worker(__filename)

		worker.postMessage(cache.handle)
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
		let nonce = 0

		while (true) {
			const hash = randomx.calculate_hex_hash('Lorem ipsum dolor sit amet' + nonce++)
			parentPort.postMessage(hash)
		}
	})
}
