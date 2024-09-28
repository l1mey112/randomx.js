// shimmed with an esbuild library
declare module "*.wasm" {
	const content: Uint8Array
	export default content
	export const wasm_pages: number
}
