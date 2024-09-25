let p = /* @__PURE__ */ 0
const buf = /* @__PURE__ */ new Uint32Array(128)

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
