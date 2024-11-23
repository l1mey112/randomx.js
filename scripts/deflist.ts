#!/usr/bin/env bun

const configuration = process.argv[2]

if (!configuration) {
	console.error('usage: ./deflist.ts <configuration.toml>')
	process.exit(1)
}

const toml = Bun.TOML.parse(await Bun.file(configuration).text())

const defs: string[] = []

for (let [key, value] of Object.entries(toml)) {
	if (typeof value === 'string') {
		// find and replace all \xBB
		const bytes = new Uint8Array(
			value.replace(/\\x([0-9a-fA-F]{2})/g, (match, hex) => String.fromCharCode(parseInt(hex, 16)))
				.split('')
				.map(char => char.charCodeAt(0))
		)

		const hex = Array.from(bytes).map(byte => '\\x' + byte.toString(16).padStart(2, '0')).join('')
		value = `"\\"${hex}\\""`
	}
	
	// -D<key>=<value>
	defs.push(`-D${key}=${value}`)
}

console.log(defs.join(' '))

export {}
