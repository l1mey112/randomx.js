import { randomx_superscalarhash, type RxCacheHandle } from '../dataset/dataset'
import { jit_detect, type JitFeature } from '../detect/detect'

// @ts-ignore
import { wasm_pages } from 'vm.wasm'

// return number of hashes
export type HashMessage = {
	type: 'hash'
}

// send cache when keys change, otherwise keep mining
export type JobMessage = {
	type: 'job'

	cache?: RxCacheHandle // new K adjustment
	jit_feature: JitFeature

	job_id: string

	blob: Uint8Array
	target: bigint // 64 bits

	// [nonce, nonce_end)
	nonce: number
	nonce_end: number
}

export type DisposeMessage = {
	type: 'dispose'
}

export type ResultMessage = {
	type: 'result'

	job_id: string
	nonce: number
	result: Uint8Array
}

export type HashResultMessage = {
	type: 'hash'
	mining_begin: number
	mining_end: number
	hashes: number
}

export type Message = HashMessage | JobMessage | DisposeMessage
export type Result = ResultMessage | HashResultMessage

type VmModule = {
	i(feature: JitFeature): number // returns scratch buffer
	B(blob_length: number, target: bigint, nonce: number, nonce_end: number): number // begin mining
	R(): number // iterate virtual machine
	h(): number // get number of hashes
	n(): bigint // get nonce
}

const wi_memory = new WebAssembly.Memory({ initial: wasm_pages, maximum: wasm_pages })

let wi_exports!: VmModule
let jit_imports!: Record<string, Record<string, WebAssembly.ImportValue>>
let scratch!: Uint8Array

let mining_begin = 0 // performance.now()
let is_mining = false
let job!: JobMessage

declare var ENVIRONMENT: 'node' | 'browser'

type RxSuperscalarHash = (item_index: bigint) => [bigint, bigint, bigint, bigint, bigint, bigint, bigint, bigint]

function randomx_superscalarhash(cache: RxCacheHandle): RxSuperscalarHash {
	const wi = new WebAssembly.Instance(cache.thunk, {
		e: {
			m: cache.memory
		}
	})

	type SuperscalarHashModule = {
		d: RxSuperscalarHash
	}

	const exports = wi.exports as SuperscalarHashModule
	return exports.d
}

function message(e: any) {
	const data: Message = (ENVIRONMENT === 'browser' ? e.data : e) as any

	if (data.type === 'hash') {
		const hashes = wi_exports.h()
		const hash_end: HashResultMessage = {
			type: 'hash',
			mining_begin,
			mining_end: performance.now(),
			hashes
		}
		postMessage(hash_end)
		return
	}

	if (data.type === 'dispose') {
		is_mining = false
		return
	}

	if (data.cache) {
		const wi_imports: Record<string, Record<string, WebAssembly.ImportValue>> = {
			env: {
				memory: wi_memory
			}
		}

		const cache = data.cache
		const superscalarhash = randomx_superscalarhash(cache)

		const wi = new WebAssembly.Instance(cache.vm, wi_imports)
		wi_exports = wi.exports as VmModule
		jit_imports = {
			e: {
				m: wi_memory,
				d: superscalarhash,
			}
		}

		const scratch_ptr = wi_exports.i(data.jit_feature)
		scratch = new Uint8Array(wi_memory.buffer, scratch_ptr, 16 * 1024)
	}

	job = data
	scratch.set(job.blob)

	console.log(`job ${job.job_id} nonce space [${job.nonce}, ${job.nonce_end}], target ${job.target}`)

	// begin mining, reinitialise everything
	wi_exports.B(job.blob.length, job.target, job.nonce, job.nonce_end)

	if (!is_mining) {
		is_mining = true
		mining_begin = performance.now()
		setImmediate(iterate)
	}
}

function iterate() {
	if (!is_mining) {
		return
	}
	
	// tick 64 times
	let iter = 0
	while (iter++ < 64) {
		const jit_size = wi_exports.R()

		switch (jit_size) {
			case 0:
			// exhausted nonce space
			console.log(`job ${job.job_id} exhausted nonce space [${job.nonce}, ${job.nonce_end}]`)
			is_mining = false
			return
		case 1:
			const result: ResultMessage = {
				type: 'result',
				job_id: job.job_id,
				nonce: Number(wi_exports.n()),
				result: scratch.slice(0, 32) // R = Hash256()
			}

			console.log(`fonud after ${wi_exports.h()} hashes, nonce ${result.nonce} result ${scratch.slice(0, 32)}`)

			postMessage(result)
			is_mining = false
			return
		}

		// iterate virtual machine
		const jit_wm = new WebAssembly.Module(scratch.subarray(0, jit_size))
		const jit_wi = new WebAssembly.Instance(jit_wm, jit_imports)
		const jit_exports = jit_wi.exports as { d: () => void }
		jit_exports.d()
	}

	setImmediate(iterate)
}


declare var ENVIRONMENT: 'node' | 'browser'

if (ENVIRONMENT === 'node') {
	const { parentPort } = await import('worker_threads')
	var postMessage = parentPort!.postMessage.bind(parentPort!)
	parentPort!.on('message', message)
} else {
	onmessage = message
}
