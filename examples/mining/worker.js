import { randomx_create_vm } from './lib.js'

self.onmessage = (e) => {
	const cache = e.data
	const randomx = randomx_create_vm(cache)

	while (true) {
		const hash = randomx.calculate_hex_hash('Lorem ipsum dolor sit amet')
		self.postMessage(hash)
	}
}
