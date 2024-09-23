import { module }  from './harness'

const samples = []

// measure WASM call overhead
while (true) {
	// module.call_overhead()

	const time_now = performance.now()
	const k = module.call_overhead()
	const time = performance.now() - time_now

	samples.push(time)

	if (samples.length >= 10000) {
		break
	}
}

const avg = samples.reduce((a, b) => a + b) / samples.length
console.log(`time ${avg * 1e6}ns`)
