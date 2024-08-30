import { RANDOMX_ARGON_MEMORY } from '../../include/configuration'
import { env_npf_putc } from '../printf/printf'
import wasm from './harness.wasm'

const SCRATCH_SIZE = 1024 * RANDOMX_ARGON_MEMORY

type Module = {
	memory: WebAssembly.Memory
	buffer: () => number

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
}

const m = await WebAssembly.instantiate(wasm, { e: { ch: env_npf_putc } })
export const module = m.instance.exports as Module

const buffer_ptr = module.buffer()
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
	return new BigUint64Array(module.memory.buffer, buffer_ptr, SCRATCH_SIZE / 8)
}

export const long1024 = (data: Uint8Array) => {
	buffer.set(data)
	module.blake2b_1024(data.length)
	return buffer.slice(0, 1024)
}
