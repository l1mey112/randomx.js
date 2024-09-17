let p = 0
const buf = new Uint32Array(1024)

// env.ch
export function env_npf_putc(ch: number) {
	if (p >= buf.length || ch === 0x0A) {
		// log to console
		let str = ''
		for (let i = 0; i < p; i++) {
			str += String.fromCharCode(buf[i])
		}
		p = 0

		if (ch === 0x0A) {
			console.log(str)
			return
		} else {
			console.log(str + '\\n')
		}
	}
	buf[p++] = ch
}
