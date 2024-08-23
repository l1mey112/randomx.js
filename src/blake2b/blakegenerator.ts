import { type Blake2b } from "./blake2b";

export function blakegenerator(blake2b: Blake2b, seed?: Uint8Array) {
	let state = new Uint8Array(64)

	if (seed) {
		state.set(seed.subarray(0, 60))
	}

	state = blake2b.hash512(state)

	let p = 0
	return {
		state() {
			return state
		},
		byte() {
			if (p >= 64) {
				state = blake2b.hash512(state)
				p = 0
			}
			return state[p++]
		},
		word() {
			if (p >= 64 - 3) {
				state = blake2b.hash512(state)
				p = 0
			}
			const word = state[p] | state[p + 1] << 8 | state[p + 2] << 16 | state[p + 3] << 24
			p += 4
			return word
		},
		bytes4() {
			if (p >= 64 - 3) {
				state = blake2b.hash512(state)
				p = 0
			}
			const bytes4 = new Uint8Array(state.subarray(p, p + 4))
			p += 4
			return bytes4
		}
	}
}
