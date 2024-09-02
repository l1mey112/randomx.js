import type { Cache } from '../dataset/dataset'
import { env_npf_putc } from '../printf/printf'
import wasm from './vm.wasm'

type VmModule = {
	memory: WebAssembly.Memory

	b(): number
	I(): number
	H(data_length: number): number
	R(): void
}

// new virtual machine
export async function randomx_construct_vm(cache: Cache) {
	const module = await WebAssembly.instantiate(wasm, {
		e: {
			ch: env_npf_putc
		},
	})

	const SCRATCH_SIZE = 1024 * 8

	const exports = module.instance.exports as VmModule
	const scratch_ptr = exports.b()
	const scratch = new Uint8Array(exports.memory.buffer, scratch_ptr, SCRATCH_SIZE)

	return {
		hash(H: Uint8Array) {

			// install seed S from H
			exports.I()
			let p = 0
			while (p < H.length) {
				const chunk = H.subarray(p, p + SCRATCH_SIZE)
				p += SCRATCH_SIZE
				scratch.set(chunk)
				exports.H(chunk.length)
			}
			exports.R()

			return scratch.slice(0, 32)
		}
	}
}
