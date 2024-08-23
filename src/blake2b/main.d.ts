import { type Feature } from './detect/detect'

type Module = {
	memory: WebAssembly.Memory
	scratch: () => number
}

declare export default async function main(feature: Feature, imports?: WebAssembly.ModuleImports): Promise<Module>
