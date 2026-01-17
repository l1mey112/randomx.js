import { type RxCacheHandle } from '../dataset/dataset'
import { jit_detect, type JitFeature } from '../detect/detect'
import { bc, type FromWorker, type ToWorker, type WorkerMessageInit, type WorkerMessageMine, type WorkerMessageResult } from './util'

// @ts-ignore
import { wasm_pages } from 'vm.wasm'

type RxSuperscalarHash = (item_index: bigint) => [bigint, bigint, bigint, bigint, bigint, bigint, bigint, bigint]

type VmModule = {
	i(feature: JitFeature): number // returns scratch buffer
	B(blob_length: number, target: bigint, nonce: number, nonce_end: number): number // begin mining
	Rm(): number // iterate virtual machine
	n(): bigint // get nonce
	h(): number // get number of hashes
}

let vm_exports!: VmModule
let vm_memory!: WebAssembly.Memory

let cache!: WebAssembly.Memory
let jit_imports!: { e: { m: WebAssembly.Memory, d: RxSuperscalarHash } }

let scratch!: Uint8Array
let miner_id!: string

// if job == null, then not mining
let job: WorkerMessageMine | null = null
let job_mining_began: number = 0

function iterate() {
	// job is always true here
	if (!job) {
		return
	}
	
	outer: for (var iter = 0; iter < 512; iter++) {
		const jit_size = vm_exports.Rm()

		switch (jit_size) {
			case 0:
			// exhausted nonce space
			console.log(miner_id, `job ${job.job_id} exhausted nonce space`)
			job = null
			break outer
		case 1:
			const result: WorkerMessageResult = {
				type: 'result',
				miner_id,

				job_id: job.job_id,
				nonce: Number(vm_exports.n()),
				result: scratch.slice(0, 32), // R = Hash256()
			}

			console.log(miner_id, `found after ${vm_exports.h()} hashes, nonce ${result.nonce} result ${scratch.slice(0, 32)}`)

			bc.postMessage(result satisfies FromWorker)
			job = null
			break outer
		}

		// iterate virtual machine
		const jit_wm = new WebAssembly.Module(scratch.subarray(0, jit_size) as any)
		const jit_wi = new WebAssembly.Instance(jit_wm, jit_imports)
		const jit_exports = jit_wi.exports as { d: () => void }
		jit_exports.d()
	}

	// send pong
	const h = vm_exports.h()
	bc.postMessage({
		type: 'pong',
		miner_id,

		stats: {
			hashes_per_second: Math.floor((h * 1000) / (Date.now() - job_mining_began)),
			hashes_total: Number(h),
		}
	} satisfies FromWorker)

	if (job) {
		setImmediate(iterate)
	}
}

function message({ data }: MessageEvent<ToWorker | WorkerMessageResult>) {
	// someone else got to it before us
	if (data.type === 'result') {
		job = null
	}
	
	if (data.type === 'init_cache') {
		const ssh = new WebAssembly.Instance(data.thunk, {
			e: {
				m: cache
			}
		})
		jit_imports = {
			e: {
				m: vm_memory,
				d: ssh.exports.d as RxSuperscalarHash,
			}
		}
		job = null
	} else if (data.type === 'dispose') {
		console.log(miner_id, 'disposing job')
		job = null
	} else if (data.type === 'mine') {
		const was_mining = !!job

		job_mining_began = Date.now()
		job = data
		const nonce_space = job.work_allocation[miner_id]

		// begin mining, reinitialise everything
		console.log(miner_id, `job ${job.job_id} nonce space [${nonce_space.nonce}, ${nonce_space.nonce_end}), target ${job.target}`)
		scratch.set(job.blob)
		vm_exports.B(job.blob.length, job.target, nonce_space.nonce, nonce_space.nonce_end)

		if (!was_mining) {
			setImmediate(iterate)
		}
	}
}

function init(e: WorkerMessageInit) {
	miner_id = e.miner_id
	cache = e.cache

	vm_memory = new WebAssembly.Memory({ initial: wasm_pages, maximum: wasm_pages })
	const wi_imports: Record<string, Record<string, WebAssembly.ImportValue>> = {
		env: {
			memory: vm_memory
		}
	}
	
	const vm = new WebAssembly.Instance(e.vm, wi_imports)
	vm_exports = vm.exports as VmModule

	const scratch_ptr = vm_exports.i(e.jit_feature)
	scratch = new Uint8Array(vm_memory.buffer, scratch_ptr, 16 * 1024)

	bc.onmessage = message
}

declare var ENVIRONMENT: 'node' | 'browser'

if (ENVIRONMENT === 'node') {
	// not supported at the moment

	const { parentPort } = await import('worker_threads')
	var postMessage = parentPort!.postMessage.bind(parentPort!)
	parentPort!.on('message', init)
} else {
	onmessage = (e) => init(e.data)
}
