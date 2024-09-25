import { randomx_create_vm } from 'https://cdn.jsdelivr.net/npm/randomx.js/dist/web/index.js'

self.onmessage = (e) => {
	const cache = e.data
	const randomx = randomx_create_vm(cache)

	while (true) {
		const hash = randomx.calculate_hex_hash('Lorem ipsum dolor sit amet')
		self.postMessage(hash)
	}
}
