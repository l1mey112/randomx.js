import { randomx_superscalarhash, type Cache } from '../dataset/dataset'
import { jit_detect, type JitFeature } from '../detect/detect'
import { env_npf_putc } from '../printf/printf'
import wasm from './vm.wasm'

let _wasm: WebAssembly.Module | null = null
const _feature: JitFeature = jit_detect()

// new virtual machine
export function randomx_create_vm(cache: Cache) {
	type VmModule = {
		memory: WebAssembly.Memory

		i(feature: JitFeature): number // returns scratch buffer
		I(): void
		H(data_length: number): number
		R(): void
		Ri(): number
		Rf(): number
	}

	if (!_wasm) {
		_wasm = new WebAssembly.Module(wasm)
	}

	const wi = new WebAssembly.Instance(_wasm, {
		e: {
			ch: env_npf_putc
		},
	})

	const SCRATCH_SIZE = 64 * 1024 // 64 KiBs (less than the real amount)

	const exports = wi.exports as VmModule
	const scratch_ptr = exports.i(_feature)
	const memory = exports.memory
	const scratch = new Uint8Array(memory.buffer, scratch_ptr, SCRATCH_SIZE)

	// install seed S from H
	function install_seed(scratch: Uint8Array, H: Uint8Array) {
		exports.I()
		let p = 0
		while (p < H.length) {
			const chunk = H.subarray(p, p + SCRATCH_SIZE)
			p += SCRATCH_SIZE
			scratch.set(chunk)
			exports.H(chunk.length)
		}
	}

	const superscalarhash = randomx_superscalarhash(cache)
	const jit_imports: WebAssembly.Imports = {
		e: {
			m: memory,
			d: superscalarhash,
		},		
	}

	function iterate_vm() {
		do {
			const jit_size = exports.Ri()
			const jit_buffer = new Uint8Array(memory.buffer, scratch_ptr, jit_size)
			console.log(`iterate_vm jit_size: 0x${scratch_ptr.toString(16)} ${jit_size}`)

			Bun.write('vm.wasm', jit_buffer).then(() => console.log('write vm.wasm', jit_size / 1024))

			const jit_wm = new WebAssembly.Module(jit_buffer)
			const jit_wi = new WebAssembly.Instance(jit_wm, jit_imports)
			const jit_exports = jit_wi.exports as { d: () => void }
			jit_exports.d()
		} while (exports.Rf())
	}

	return {
		hash(H: Uint8Array) {
			console.log(`hash H:`, H)
			install_seed(scratch, H)
			exports.R()
			iterate_vm()
			return new Uint8Array(scratch.subarray(0, 32)) // Hash256
		}
	}
}
