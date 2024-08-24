export function store32(dst: Uint8Array, offset: number, w: number) {
	new DataView(dst.buffer).setUint32(offset, w, true)
}

export function load32(src: Uint8Array, offset: number) {
	return new DataView(src.buffer).getUint32(offset, true)
}
