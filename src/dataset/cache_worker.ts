declare var self: Worker

import { create_module, initialise } from './dataset'

const [memory, exports] = await create_module(true)

self.onmessage = (event: MessageEvent<Uint8Array>) => {
	const key = event.data

	const cache = initialise(key, memory, exports)
	self.postMessage(cache)
}
