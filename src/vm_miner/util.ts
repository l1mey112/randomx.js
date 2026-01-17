import type { JitFeature } from "../detect/detect"

export const bc = new BroadcastChannel('12313131 miner channel')

export type Config = {
	target_threads?: number
}

export function sleep(ms: number): Promise<void> {
	return new Promise((resolve) => setTimeout(resolve, ms))
}

export function hex2bin(hex: string): Uint8Array {
	if (hex.length & 1) {
		throw new Error('invalid hex length')
	}

	const bin = new Uint8Array(hex.length / 2)

	for (let i = 0; i < hex.length / 2; i++) {
		let lut = '0123456789abcdef'
		const hb = lut.indexOf(hex[i * 2])
		const lb = lut.indexOf(hex[i * 2 + 1])

		if (hb === -1 || lb === -1) {
			throw new Error('invalid hex character')
		}

		bin[i] = (hb << 4) | lb
	}

	return bin
}

// src/base/net/stratum/Job.cpp:111
export function hex2target(hex: string): bigint {
	const bin = hex2bin(hex)

	if (bin.length === 4) {
		// convert to 4 bytes
		const u32 = new Uint32Array(bin.buffer)[0]
		return 0xFFFFFFFFFFFFFFFFn / (0xFFFFFFFFn / BigInt(u32))
	} else if (bin.length === 8) {
		const u64 = new BigUint64Array(bin.buffer)[0]
		return u64
	}
	throw new Error('invalid target byte length')
}

export type Job = {
	blob: string
	job_id: string
	target: string
	height: number
	seed_hash: string
}

// It is assumed that when 'new_cache' comes in, the main worker would have
// already finished overwriting the caches memory. Hence, for a moment between
// the writes and the 'new_cache', the worker is wasting cycles mining on
// garbage data.
//
// That's probably okay, it's just that the main worker needs to ignore the
// 'result' messages in between regenerating the cache.
//
export type WorkerMessageNewCache = {
	type: 'init_cache'

	// cache: WebAssembly.Memory
	thunk: WebAssembly.Module
}

export type NonceSpace = {
	miner_id: string
	
	// [nonce, nonce_end)
	nonce: number
	nonce_end: number
}

export type WorkerMessageMine = {
	type: 'mine'

	job_id: string
	blob: Uint8Array
	target: bigint // 64 bits

	// if you get 'mine' and your miner_id is not in work_allocation,
	// this is equivalent to a 'die'
	work_allocation: Record<string, NonceSpace>
}

// the job of the worker is to repeatedly send pongs
export type WorkerPong = {
	type: 'pong'

	miner_id: string

	stats: {
		hashes_per_second: number
		hashes_total: number
	}
}

// workers initially start paused until they get more work.
// pause them, and they are unpaused when they get 'mine'
export type WorkerGlobalDispose = {
	type: 'dispose'
}

export type WorkerMessageResult = {
	type: 'result'

	miner_id: string

	job_id: string
	nonce: number
	result: Uint8Array
}

export type ToWorker =
	| WorkerMessageNewCache
	| WorkerMessageMine
	| WorkerGlobalDispose

export type FromWorker =
	| WorkerMessageResult
	| WorkerPong

export type WorkerMessageInit = {
	type: 'init'

	// this is a random string, one per worker initialised when they're created
	miner_id: string
	jit_feature: JitFeature

	// backing SharedArrayBuffer allocated once, the thunk/ssh will be sent later
	cache: WebAssembly.Memory
	vm: WebAssembly.Module
}
