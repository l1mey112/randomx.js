import { randomx_init_cache, type RxCache } from '../dataset/dataset'
import { jit_detect } from '../detect/detect'
import type { JobMessage, Result } from '../vm_miner/worker'

// @ts-ignore
import WORKER_URL from 'url:../vm_miner/worker'

type Job = {
	blob: string
	job_id: string
	target: string
	height: number
	seed_hash: string
}

const feature = jit_detect()

let current_job: Job | undefined
let cache!: RxCache

function tobin(hex: string): Uint8Array {
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
function to_target(hex: string): bigint {
	const bin = tobin(hex)

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

declare var ENVIRONMENT: 'node' | 'browser'

let new_worker: () => Worker
if (ENVIRONMENT !== 'browser') {
	var Worker = require('worker_threads').Worker
}

function message(e: any) {
	const data: Result = (ENVIRONMENT === 'browser' ? e.data : e) as any

	if (data.type === 'hash') {
		const time = data.mining_end - data.mining_begin
		console.log(`hashes: ${data.hashes} ${(data.hashes / (time / 1000)).toFixed(1)}H/s`)
		return
	}

	if (data.type === 'result') {
		console.log(data)

		// dispose all
		for (const miner of miners) {
			miner.postMessage({ type: 'dispose' })
		}
	}
}

function on_job(job: Job) {
	let dirty_cache = false

	if (cache === undefined || current_job?.seed_hash !== job.seed_hash) {
		// convert hex strings to Uint8Array
		const seed_hash = tobin(job.seed_hash)
		if (seed_hash === undefined) {
			return
		}

		if (cache !== undefined) {
			// reuse memory
			cache = randomx_init_cache(seed_hash, cache)
		} else {
			cache = randomx_init_cache(seed_hash, { shared: true })
		}

		dirty_cache = true
	}

	current_job = job

	const blob = tobin(job.blob)
	if (blob === undefined) {
		return
	}

	const target = to_target(job.target)

	const job_message: JobMessage = {
		type: 'job',
		job_id: job.job_id,
		blob,
		target: target,
		nonce: 0,
		nonce_end: 0xffff, // temporary nonce space
		cache: dirty_cache ? cache.handle : undefined,
		jit_feature: feature,
	}

	// distribute jobs to workers
	const nonce_space = Math.ceil(0xffffffff / miners.length)
	let nonce = 0
	for (const miner of miners) {
		job_message.nonce = nonce
		job_message.nonce_end = nonce + nonce_space
		if (job_message.nonce_end > 0xffffffff) {
			job_message.nonce_end = 0xffffffff
		}
		nonce += nonce_space

		console.log(`posting job, nonce space [${job_message.nonce}, ${job_message.nonce_end}]`)
		miner.postMessage(job_message)
	}

	function ask_for_hashrate() {
		for (const miner of miners) {
			miner.postMessage({ type: 'hash' })
		}
	}

	setInterval(ask_for_hashrate, 5000)
}

const miners: Worker[] = []

for (let i = 0; i < 8; i++) {
	const miner = new Worker(WORKER_URL)
	
	if (ENVIRONMENT === 'node') {
		miner.on('message', message)
	} else {
		miner.onmessage = message
	}
	
	miners.push(miner)
}

const job: Job = {
	"blob": "1010f7f2e4b70618f1fe647153b5a337098080ed8f90eee987ad4dd78bc0f3aa59bf3a53c991660000000081b6ec64f730565a0ac1dd619427aa884bf4cf8aeef7f901b00074d8390c075847",
	"job_id": "785297",
	"target": "ffffff00",
	"height": 3248070,
	"seed_hash": "3b0d5af1cdc3827e2f42f03e93661a252086f8d4e35dc65a9d3ea48e240cc795"
}

on_job(job)
