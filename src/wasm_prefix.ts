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
