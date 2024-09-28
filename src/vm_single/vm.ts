import { randomx_superscalarhash, type RxCache } from '../dataset/dataset'
import { jit_detect, machine_id, type JitFeature } from '../detect/detect'
import { env_npf_putc } from '../printf/printf'
import { timeit } from '../printf/timeit'

declare var INSTRUMENT: number

const _feature: JitFeature = jit_detect()

export function randomx_machine_id() {
	return machine_id(_feature)
}

// new virtual machine
export function randomx_create_vm(cache: RxCache) {
	type VmModule = {
		memory: WebAssembly.Memory

		i(feature: JitFeature): number // returns scratch buffer
		I(is_hex: boolean): void
		H(data_length: number): number
		R(): number // iterate virtual machine
		// when INSTRUMENT
		b(ic: number, pc: number, mx: number, ma: number, sp_addr0: number, sp_addr1: number): void
	}

	const SCRATCH_SIZE = 16 * 1024

	const wi_imports: Record<string, Record<string, WebAssembly.ImportValue>> = {}

	let memory: WebAssembly.Memory | undefined
	let the_timeit: ReturnType<typeof timeit>

	if (INSTRUMENT) {
		wi_imports.e = {}
		wi_imports.e.ch = env_npf_putc

		if (INSTRUMENT == 2) {
			const timed = new Map<string, number>()

			wi_imports.e.b = function (ptr: number, finished: number) {
				the_timeit.timeit(ptr, finished)
			}
		}
	}
	
	const wi = new WebAssembly.Instance(cache.vm, wi_imports as Record<string, any>)
	const exports = wi.exports as VmModule
	const scratch_ptr = exports.i(_feature)
	memory = exports.memory
	const scratch = new Uint8Array(memory.buffer, scratch_ptr, SCRATCH_SIZE)

	const superscalarhash = randomx_superscalarhash(cache)
	const jit_imports: Record<string, Record<string, WebAssembly.ImportValue>> = {
		e: {
			m: memory,
			d: superscalarhash,
		}
	}

	// inspect the VM JIT code
	if (INSTRUMENT == 1) {
		jit_imports.e.b = exports.b
	} else if (INSTRUMENT == 2) {
		the_timeit = timeit(memory!)
		the_timeit.timeit_init()
		
		jit_imports.e.b = function () {}
	}

	function hash(H: Uint8Array | string, is_hex: boolean) {
		if (typeof H === 'string') {
			H = new TextEncoder().encode(H)
		}

		// install seed S from H
		exports.I(is_hex)
		if (H.length <= SCRATCH_SIZE) {
			// most likely case
			scratch.set(H)
			exports.H(H.length)
		} else {
			let p = 0
			while (p < H.length) {
				const chunk = H.subarray(p, p + SCRATCH_SIZE)
				p += SCRATCH_SIZE
				scratch.set(chunk)
				exports.H(chunk.length)
			}
		}

		let jit_size: number
		while (1) {
			jit_size = exports.R()
			if (jit_size === 0) {
				break
			}
			const jit_wm = new WebAssembly.Module(scratch.subarray(0, jit_size))
			const jit_wi = new WebAssembly.Instance(jit_wm, jit_imports)
			const jit_exports = jit_wi.exports as { d: () => void }
			jit_exports.d()
		}

		if (INSTRUMENT == 2) {
			the_timeit.timeit_totals()
		}
	}

	return {
		calculate_hash(H: Uint8Array | string): Uint8Array {
			hash(H, false)
			return new Uint8Array(scratch.subarray(0, 32)) // Hash256
		},
		calculate_hex_hash(H: Uint8Array | string): string {
			hash(H, true)
			return new TextDecoder().decode(scratch.subarray(0, 64)) // Hash256
		},
	}
}
