import { RxCache, type RxCacheHandle } from '../dataset/dataset'
import { jit_detect, machine_id, type JitFeature } from '../detect/detect'
import { env_npf_putc } from '../printf/printf'
import { timeit } from '../printf/timeit'

// @ts-ignore
import { wasm_pages } from 'vm.wasm'

declare var INSTRUMENT: number

const _feature: JitFeature = jit_detect()

export function randomx_machine_id() {
	return machine_id(_feature)
}

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

// new virtual machine
export function randomx_create_vm(cache: RxCache | RxCacheHandle) {
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


	let the_timeit: ReturnType<typeof timeit>
	const memory = new WebAssembly.Memory({ initial: wasm_pages, maximum: wasm_pages })
	const wi_imports: Record<string, Record<string, WebAssembly.ImportValue>> = {
		env: {
			memory
		}
	}

	if (INSTRUMENT) {
		wi_imports.e = {}
		wi_imports.e.ch = env_npf_putc

		if (INSTRUMENT == 2) {
			the_timeit = timeit(memory)
			the_timeit.timeit_init()

			wi_imports.e.b = the_timeit.timeit
		}
	}
	
	const wi = new WebAssembly.Instance(cache.vm, wi_imports as Record<string, any>)
	const exports = wi.exports as VmModule
	const scratch_ptr = exports.i(_feature)
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
			if (INSTRUMENT == 2) {
				the_timeit.timeit('wasm compilation', false)
			}
			const jit_wm = new WebAssembly.Module(scratch.subarray(0, jit_size))
			const jit_wi = new WebAssembly.Instance(jit_wm, jit_imports)
			if (INSTRUMENT == 2) {
				the_timeit.timeit('wasm compilation', true)
			}
			const jit_exports = jit_wi.exports as { d: () => void }
			jit_exports.d()
		}

		if (INSTRUMENT == 2) {
			the_timeit.timeit_totals()
			the_timeit.timeit_init()
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
