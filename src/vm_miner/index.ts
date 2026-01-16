import { internal_create_module, internal_initialise, randomx_init_cache, RxCache, type DatasetModule, type RxCacheHandle } from '../dataset/dataset';
import { hex2bin, hex2target, sleep, type Config, type FromWorker, type Job, type NonceSpace, type ToWorker, type WorkerMessageMine, type WorkerMessageNewCache, type WorkerPong } from './util';

// @ts-ignore
import WORKER_URL from 'url:./worker'

// @ts-ignore
import dataset_wasm, { wasm_pages as dataset_wasm_pages } from 'dataset.wasm'

const bc = new BroadcastChannel('12313131 miner channel');

type MainState = {
	cache_memory: WebAssembly.Memory
	cache_exports: DatasetModule

	// depends on the key K from current_job
	current_job?: {
		job: Job
		rx_cache: RxCache
	}

	workers: Map<string, WorkerPong>
}

async function main_watch_workers(workers: Map<string, WorkerPong>, st: MainState): Promise<void>
async function main_watch_workers(workers: Map<string, WorkerPong>): Promise<WebAssembly.Memory>

// if `st` is empty, this is an initial sweep and won't ignore workers that have differing caches
async function main_watch_workers(workers: Map<string, WorkerPong>, st?: MainState): Promise<WebAssembly.Memory | void> {
	let cache: WebAssembly.Memory | null = null
	
	bc.onmessage = (x) => {
		let data: FromWorker = x.data

		if (data.type === 'pong') {
			let killed = false
			
			if (st && data.cache && st.cache_memory !== data.cache) {
				// kill this worker, it's differing to our current memory
				bc.postMessage({ type: 'die', miner_id: data.miner_id } satisfies ToWorker)
				killed = true
			}

			if (!st && data.cache) {
				cache = data.cache
			}

			if (!killed) {
				workers.set(data.miner_id, data)
			}
		}

		if (!st) {
			return
		}

		// do more stuff, maybe check hashrate/stats
	}

	if (!st) {
		// sleep, get workers (they send every 500ms or so)
		await sleep(1000)
		bc.onmessage = null

		// we didn't find one..
		if (!cache) {
			cache = new WebAssembly.Memory({
				initial: dataset_wasm_pages, maximum: dataset_wasm_pages, shared: true
			})
		}

		return cache
	}
}

async function main_create_worker(): Promise<void> {

}

async function main_watch_create_workers(st: MainState, config: Config): Promise<void> {
	if (!config.target_threads) {
		// TODO or some other method?
		config.target_threads = navigator.hardwareConcurrency ?? 4
	}

	const sleep200 = () => sleep(200)

	// slowly ramp up the amount of threads at a time, you don't want to
	// create more than the target

	while (1) {
		// TODO lower the threads by just removing from the worker list
		if (st.workers.size >= config.target_threads) {
			await sleep200()
			continue
		}

		// TODO this is pretty naive and shitty, but i don't know

		let diff = config.target_threads - st.workers.size
		console.log(`main_watch_create_workers: ${diff} new workers`)
		
		for (let i = 0; i < diff; i++) {
			void main_create_worker()
		}

		while (st.workers.size < config.target_threads) {
			await sleep200()
		}
		
		console.log(`main_watch_create_workers: ${diff} new workers created`)
	}
}

async function main_new_state(cache: WebAssembly.Memory, workers: Map<string, WorkerPong>): Promise<MainState> {
	return {
		cache_memory: cache,
		cache_exports: internal_create_module(cache),

		workers: workers,
	}
}

/*

	cache : 256 MiBs of data, initalised based on the blockchain (blockheight % 2048)
	let (cache, superscalarhash_program) = randomx_create_cache()

  MAIN (listen for new jobs, and manage the "cache")
		- worker 1
		- worker 2
		- worker 3
		- worker 4
		- worker 5


	1. my stupid way

	2. when main dies, tear down the workers, initialise a new cache
*/

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
	const miners = st.workers.keys().toArray()

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

// attempt to become main
navigator.locks.request('the CLAW!!', async (lock) => {
	// when you become main, wait until you're aware of all running workers.
	// there also might exist a SharedArrayBuffer already and you want to reuse that

	// hardcoded at the moment
	const config: Config = {}

	const workers = new Map<string, WorkerPong>()
	const st = await main_new_state(await main_watch_workers(workers), workers)

	// run in the background now, with our new state
	void main_watch_workers(workers, st)
	void main_watch_create_workers(st, config)

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
})
