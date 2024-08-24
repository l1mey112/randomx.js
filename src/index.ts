import { IO_BUFFER_SIZE, type Feature } from "../include/configuration";
import { detect } from "./detect/detect";
import randomx_main, { type Module } from './randomx/main'

type FeatureFlag = 'js' | 'simd' | 'fma'


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

		this.randomx.K(key?.length ?? 0)		
		this.loaded_cache = true
	}

	hash(input: Uint8Array) {
		if (!this.loaded_cache) {
			throw Error('Cache not loaded')
		}

		// install seed S

		let p = 0
		while (p < input.length) {
			const chunk = input.subarray(p, p + IO_BUFFER_SIZE)
			p += IO_BUFFER_SIZE
			this.B.set(chunk)
			this.randomx.H(chunk.length)
		}
		this.randomx.Hf()

		this.randomx.R()
	}
}

// new virtual machine
export default async function randomx({ feature_flag }: { feature_flag?: FeatureFlag }) {
	let feature: Feature

	if (feature_flag) {
		const hf_table: Record<FeatureFlag, Feature> = {
			'js': 0,
			'simd': 1,
			'fma': 2,
		}

		feature = hf_table[feature_flag]
	} else {
		feature = await detect()
	}

	const module = await randomx_main(feature, {})

	return new RandomX(feature, module)
}
