import { type Feature } from './detect/detect'

type Module = {
	memory: WebAssembly.Memory
	blake2b_scratch: () => number
	blake2b_init: (hash_length: number, key_length: number) => void
	blake2b_update: (size: number) => void
	blake2b_finalise: () => void
}

declare export default async function main(feature: Feature, imports?: WebAssembly.ModuleImports): Promise<Module>
