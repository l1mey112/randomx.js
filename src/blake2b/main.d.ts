import { type Feature } from './detect/detect'

type Module = {
	memory: WebAssembly.Memory
	add: (a: number, b: number) => number
	my_memset: (a: number, b: number, c: number) => void
	my_memcpy: (a: number, b: number, c: number) => void
}

declare export default async function main(feature: Feature, imports?: WebAssembly.ModuleImports): Promise<Module>
