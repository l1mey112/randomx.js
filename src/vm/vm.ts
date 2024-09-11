import type { Cache } from '../dataset/dataset'
import { env_npf_putc } from '../printf/printf'
import wasm from './vm.wasm'

let _wasm: WebAssembly.Module | null = null

// new virtual machine
export function randomx_create_vm(cache: Cache) {
	type VmModule = {
		memory: WebAssembly.Memory
	
		b(): number
		I(): number
		H(data_length: number): number
		R(): void
	}

	if (!_wasm) {
		_wasm = new WebAssembly.Module(wasm)
	}

	const wi = new WebAssembly.Instance(_wasm, {
		e: {
			ch: env_npf_putc
		},
		env: {
			memory: cache.memory
		},
	})

	const SCRATCH_SIZE = 1024 * 8

	const exports = wi.exports as VmModule
	const scratch_ptr = exports.b()
	const scratch = new Uint8Array(exports.memory.buffer, scratch_ptr, SCRATCH_SIZE)

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

	return {
		hash(H: Uint8Array) {
			install_seed(scratch, H)
			exports.R()
			return new Uint8Array(scratch.subarray(0, 32))
		}
	}
}
