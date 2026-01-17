import { internal_create_module, internal_get_cached_vm_handle, internal_initialise, randomx_init_cache, RxCache, type DatasetModule, type RxCacheHandle } from '../dataset/dataset';
import { bc, hex2bin, hex2target, sleep, type Config, type FromWorker, type Job, type NonceSpace, type ToWorker, type WorkerMessageInit, type WorkerMessageMine, type WorkerMessageNewCache, type WorkerPong } from './util';
import { jit_detect } from '../detect/detect';
import { nanoid } from 'nanoid';

// @ts-ignore
import worker_url from 'url:./vm'

// @ts-ignore
import dataset_wasm, { wasm_pages as dataset_wasm_pages } from 'dataset.wasm'

declare var ENVIRONMENT: 'node' | 'browser'
if (ENVIRONMENT !== 'browser') {
	var Worker = require('worker_threads').Worker
}

const jit_feature = jit_detect()

type MainState = {
	cache_memory: WebAssembly.Memory
	cache_exports: DatasetModule

	// depends on the key K from current_job
	current_job?: {
		job: Job
		rx_cache: RxCache
	}

	workers: Map<string, WorkerPong | null>
}

async function main_new_state(config: Config): Promise<MainState> {
	const cache = new WebAssembly.Memory({
		initial: dataset_wasm_pages, maximum: dataset_wasm_pages, shared: true
	})
	
	if (!config.target_threads) {
		// TODO or some other method?
		config.target_threads = navigator.hardwareConcurrency ?? 4
	}

	const workers = new Map<string, WorkerPong | null>()
	const vm = internal_get_cached_vm_handle()
	
	for (let i = 0; i < config.target_threads; i++) {
		const worker = new Worker(worker_url)
		const miner_id = nanoid()

		worker.postMessage({
			type: 'init',

			miner_id,
			jit_feature,
			cache,
			vm,
		} satisfies WorkerMessageInit)
		
		workers.set(miner_id, null)
	}
	
	return {
		cache_memory: cache,
		cache_exports: internal_create_module(cache),
		workers,
	}
}

function on_job(st: MainState, job: Job) {
	if (st.current_job?.job.seed_hash !== job.seed_hash) {
		const seed_hash = hex2bin(job.seed_hash)

		console.log('on_job: initialising a new cache')
		console.time('on_job: initialise cache')

		// existing 256 MiBs of cache is being reused here.
		// this will take a while to initialise the cache
		const rx_cache = internal_initialise(seed_hash, st.cache_memory, st.cache_exports)
		console.timeEnd('on_job: initialise cache')

		st.current_job = { job, rx_cache }

		const message_init: WorkerMessageNewCache = {
			type: 'init_cache',
			thunk: rx_cache.thunk,
		}

		// we are mining again, here is a new (cache, thunk) pair derived from K.
		// remember, thunk is the superscalar hash instance
		bc.postMessage(message_init satisfies ToWorker)
	}

	const blob = hex2bin(job.blob)
	const target = hex2target(job.target)

	// we are not using individual Worker instances, all instances get the same
	// BroadcastChannel to use. this message goes out to all

	const work_allocation: Record<string, NonceSpace> = {}

	// avoid a race condition, make a copy
	const miners = Array.from(st.workers.keys())

	// distribute jobs to workers
	const nonce_space = Math.ceil(0xffffffff / miners.length)
	let nonce = 0
	for (const miner_id of miners) {
		let nonce_end = nonce + nonce_space
		
		work_allocation[miner_id] = {
			miner_id: miner_id,

			nonce,
			nonce_end: nonce_end <= 0xffffffff ? nonce_end : 0xffffffff,
		}

		nonce += nonce_space
	}

	const message_mine: WorkerMessageMine = {
		type: 'mine',

		job_id: st.current_job.job.job_id,
		blob,
		target,

		work_allocation,
	}

	bc.postMessage(message_mine satisfies ToWorker)
}

let last_stats_time = Date.now()
const stats = new Map<string, WorkerPong>()

bc.onmessage = ({ data }: MessageEvent<FromWorker>) => {
	if (data.type === 'pong') {
		stats.set(data.miner_id, data)
		const now = Date.now()
		if (now - last_stats_time >= 1000) {
			last_stats_time = now

			const table: Record<string, any>[] = []
			for (const [k, v] of stats) {
				table.push({
					'miner id': k,
					'hashes per second': `${v.stats.hashes_per_second.toLocaleString()} H/s`,
					'total hashes': v.stats.hashes_total.toLocaleString(),
				})
			}
			table.push({
				'miner id': undefined,
				'hashes per second': `${Array.from(stats.values()).reduce((a, b) => a + b.stats.hashes_per_second, 0).toLocaleString()} H/s`,
				'total hashes': Array.from(stats.values()).reduce((a, b) => a + b.stats.hashes_total, 0).toLocaleString(),
			})

			console.table(table)
		}
	}
}

export async function randomx_benchmark_become_miner() {
	// hardcoded at the moment
	const config: Config = {}
	const st = await main_new_state(config)

	const job: Job = {
		"blob": "1010f7f2e4b70618f1fe647153b5a337098080ed8f90eee987ad4dd78bc0f3aa59bf3a53c991660000000081b6ec64f730565a0ac1dd619427aa884bf4cf8aeef7f901b00074d8390c075847",
		"job_id": "785297",
		"target": "ffff0000",
		"height": 3248070,
		"seed_hash": "3b0d5af1cdc3827e2f42f03e93661a252086f8d4e35dc65a9d3ea48e240cc795"
	}

	on_job(st, job)
}

// attempt to become main
/* navigator.locks.request('the CLAW!!', async (lock) => {
	// hardcoded at the moment
	const config: Config = {}
	const st = await main_new_state(config)

	const job: Job = {
		"blob": "1010f7f2e4b70618f1fe647153b5a337098080ed8f90eee987ad4dd78bc0f3aa59bf3a53c991660000000081b6ec64f730565a0ac1dd619427aa884bf4cf8aeef7f901b00074d8390c075847",
		"job_id": "785297",
		"target": "ffffff00",
		"height": 3248070,
		"seed_hash": "3b0d5af1cdc3827e2f42f03e93661a252086f8d4e35dc65a9d3ea48e240cc795"
	}

	on_job(st, job)
}).finally(() => {
	bc.close()
}) */
