export function locate_import(binary: Uint8Array, needle: string): number {
	// the import section is near the start, no need to step over the entire binary
	// indexOf doesn't work on Uint8Array

	const needle_binary = new TextEncoder().encode(needle)
	const needle_length = needle_binary.length
	let found = false
	let p = 0
	for (; p < binary.length; p++) {
		found = true
		for (let i = 0; i < needle_length; i++) {
			if (binary[p + i] !== needle_binary[i]) {
				found = false
				break
			}
		}
		if (found) {
			break
		}
	}

	if (!found) {
		throw new Error('Import not found')
	}

	p += needle_length

	return p
}

export function u32p(buf: Uint8Array, p: number): [n: number, p: number] {
	let num = 0
	let shift = 0
	while (true) {
		const byt = buf[p++]
		num |= (byt & 0x7f) << shift
		if (byt >> 7 === 0) {
			break
		} else {
			shift += 7
		}
	}
	return [num, p]
}

export function locate_section(binary: Uint8Array, section: number): [p: number, found: boolean] {
	let im_found = false
	let im = 8 // skip magic and version
	while (im < binary.length) {
		if (binary[im] === section) {
			im_found = true
			break
		}
		im++

		const [n, imp] = u32p(binary, im)
		im = imp + n
	}

	return [im, im_found]
}


export function adjust_imported_shared_memory(binary: Uint8Array, needle: string, shared: boolean) {
	// the import section is near the start, no need to step over the entire binary
	// indexOf doesn't work on Uint8Array

	let p = locate_import(binary, needle)

	// 0x02 memtype

	// memtype ::= limits
	// limits  ::= 0x00 n:u32         => { min n }
	//           | 0x01 n:u32 m:u32   => { min n, max m }
	//           | 0x03 n:u32 m:u32   => { min n, max m, shared }

	if (binary[p] !== 0x02) {
		throw new Error('Expected memtype')
	}
	p += 1 // 0x02

	if (binary[p] === 0x00) {
		throw new Error('Cannot patch in place')
	}

	binary[p] = shared ? 0x03 : 0x01
}
