import path from 'node:path'
import fs from 'node:fs'
import { RANDOMX_ARGON_MEMORY } from '../include/configuration'
import { env_npf_putc } from '../src/printf/printf'

const wasm = fs.readFileSync(path.join(import.meta.dirname, './rx_harness.wasm'))
const SCRATCH_SIZE = 1024 * 16

type Module = {
	memory: WebAssembly.Memory
	scratch_buffer: () => number
	cache_buffer: () => number

	// Hash256 and Hash512
	blake2b_init_key: (key_length: number, hash_length: number) => void
	blake2b_update: (size: number) => void
	blake2b_finalise: () => void

	// long1024
	blake2b_1024: (size: number) => void

	// BlakeGenerator
	blake2b_generator_init(key_length: number): void
	blake2b_generator_u8(): number
	blake2b_generator_i32(): number

	// argon2fill
	init_new_cache: (key_length: number) => void

	// SuperscalarHash
	ssh_init_newblake: (key_length: number) => void
	ssh_generate_hash256: () => void

	// JIT
	jit_reciprocal: (divisor: bigint) => bigint

	// AES
	fillAes1Rx4(): void
	soft_aesenc(): void
	soft_aesdec(): void

	// VM
	program_VM(hash_length: number): number

	// benchmarks
	call_overhead(): number
}

const m = await WebAssembly.instantiate(wasm, { e: { ch: env_npf_putc } })
export const module = m.instance.exports as Module

const buffer_ptr = module.scratch_buffer()
export const buffer = new Uint8Array(module.memory.buffer, buffer_ptr, SCRATCH_SIZE)

const blake2b = (hash_length: number) => (data: Uint8Array, key?: Uint8Array) => {
	key ??= new Uint8Array(0)

	buffer.set(key)
	module.blake2b_init_key(key.length, hash_length)

	let p = 0
	while (p < data.length) {
		const chunk = data.subarray(p, p + SCRATCH_SIZE)
		p += SCRATCH_SIZE
		buffer.set(chunk)
		module.blake2b_update(chunk.length)
	}

	module.blake2b_finalise()

	return buffer.slice(0, hash_length)
}

export const hash512 = blake2b(64)
export const hash256 = blake2b(32)

export const blake2b_generator = (key?: Uint8Array) => {
	key ??= new Uint8Array(0)
	buffer.set(key)
	module.blake2b_generator_init(key.length)

	return {
		u8: () => module.blake2b_generator_u8(),
		i32: () => module.blake2b_generator_i32(),
	}
}

export const argon2fill = (key: Uint8Array) => {
	buffer.set(key)
	module.init_new_cache(key.length)
	return new BigUint64Array(module.memory.buffer, module.cache_buffer(), RANDOMX_ARGON_MEMORY * 1024 / 8)
}

export const long1024 = (data: Uint8Array) => {
	buffer.set(data)
	module.blake2b_1024(data.length)
	return buffer.slice(0, 1024)
}

export const fillAes1Rx4 = (data: Uint8Array) => {
	buffer.set(data)
	module.fillAes1Rx4()
	return buffer.slice(0, 64)
}

export const soft_aesenc = (data: Uint8Array, key: Uint8Array) => {
	const data_key = new Uint8Array(32)
	data_key.set(data.slice(0, 16), 0)
	data_key.set(key.slice(0, 16), 16)
	
	buffer.set(data_key)
	module.soft_aesenc()
	return buffer.slice(0, 16)
}

export const soft_aesdec = (data: Uint8Array, key: Uint8Array) => {
	const data_key = new Uint8Array(32)
	data_key.set(data.slice(0, 16), 0)
	data_key.set(key.slice(0, 16), 16)
	
	buffer.set(data_key)
	module.soft_aesdec()
	return buffer.slice(0, 16)
}

export const program_vm = (data: Uint8Array) => {
	buffer.set(data)
	const ptr = module.program_VM(data.length)
	const dv = new DataView(module.memory.buffer, ptr)

	return {
		r: new BigUint64Array(module.memory.buffer, ptr + 0, 8),
		f: new Float64Array(module.memory.buffer, ptr + 64, 8),
		e: new Float64Array(module.memory.buffer, ptr + 128, 8),
		a: new Float64Array(module.memory.buffer, ptr + 192, 8),

		// reinterpreted
		f_bin: new BigUint64Array(module.memory.buffer, ptr + 64, 8),
		e_bin: new BigUint64Array(module.memory.buffer, ptr + 128, 8),
		a_bin: new BigUint64Array(module.memory.buffer, ptr + 192, 8),

		emask: new BigUint64Array(module.memory.buffer, ptr + 256, 2),
		mmask: new BigUint64Array(module.memory.buffer, ptr + 272, 2),

		fprc: dv.getUint32(288, true),

		ma: dv.getUint32(292, true),
		mx: dv.getUint32(296, true),

		read_reg0: dv.getUint32(300, true),
		read_reg1: dv.getUint32(304, true),
		read_reg2: dv.getUint32(308, true),
		read_reg3: dv.getUint32(312, true),

		dataset_offset: dv.getBigUint64(320, true),
	}
}