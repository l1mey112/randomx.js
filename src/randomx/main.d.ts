import { type Feature } from './detect/detect'

export type Module = {
	memory: WebAssembly.Memory

	B(): number
	K(key_length: number): void
	Hi(): void
	H(data_length: number): void
	Hf(): void
	R(): void
}

declare export default async function main(imports: WebAssembly.ModuleImports): Promise<Module>
