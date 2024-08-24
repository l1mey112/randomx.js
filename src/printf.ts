let p = 0
const buf = new Uint32Array(512)

// env.ch
export function env_npf_putc(ch: number) {
	if (p >= buf.length || ch === 0x0A) {
		// log to console
		let str = ''
		for (let i = 0; i < p; i++) {
			str += String.fromCharCode(buf[i])
		}
		console.log(str)

		if (ch === 0x0A) {
			p = 0
			return
		}
	}
	buf[p++] = ch
}
