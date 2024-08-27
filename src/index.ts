import { IO_BUFFER_SIZE, type Feature } from "../include/configuration";
import { detect } from "./detect/detect";
import { env_npf_putc } from "./printf/printf";
import randomx_main, { type Module } from './dataset/main'

type FeatureFlag = 'simd' | 'fma'

class RandomX {
	private randomx: Module
	private feature: Feature
	private loaded_cache: boolean = false

	private B: Uint8Array

	constructor(feature: Feature, randomx: Module) {
		this.randomx = randomx
		this.feature = feature

		this.B = new Uint8Array(this.randomx.memory.buffer, this.randomx.B(), IO_BUFFER_SIZE)
	}

	calculate_cache(key?: Uint8Array) {
		if (key && key.length > 60) {
			throw Error('Key length must be from 0-60')
		}

		if (key) {
			this.B.set(key)
		}

		this.randomx.K(key?.length ?? 0) // install key K		
		this.loaded_cache = true
	}

	hash(input: Uint8Array) {
		if (!this.loaded_cache) {
			throw Error('Cache not loaded')
		}

		// install seed S from H
		this.randomx.Hi()
		let p = 0
		while (p < input.length) {
			const chunk = input.subarray(p, p + IO_BUFFER_SIZE)
			p += IO_BUFFER_SIZE
			this.B.set(chunk)
			this.randomx.H(chunk.length)
		}
		this.randomx.Hf()

		//this.randomx.R()
	}
}

// new virtual machine
export default async function randomx(params?: { feature_flag?: FeatureFlag }) {
	params ??= {}
	const { feature_flag } = params

	let feature: Feature

	if (feature_flag) {
		const hf_table: Record<FeatureFlag, Feature> = {
			'simd': 0,
			'fma': 1,
		}

		feature = hf_table[feature_flag]
	} else {
		feature = await detect()
	}

	const module = await randomx_main({ ch: env_npf_putc })

	return new RandomX(feature, module)
}
