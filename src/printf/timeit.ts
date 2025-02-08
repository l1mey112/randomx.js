export function timeit(memory: WebAssembly.Memory) {
	const timed = new Map<string, number>()
	const timed_completely: [string, number][] = []
	
	const buf = new Uint8Array(memory.buffer)

	function tos(ptr: number) {
	
		let p = ptr
		while (buf[p] !== 0) {
			p++
		}
	
		return new TextDecoder().decode(buf.subarray(ptr, p))
	}

	function _timeit(ptr: number, finished: number | boolean): void
	function _timeit(str: string, finished: number | boolean): void

	function _timeit(ptr: number | string, finished: number | boolean): void {
		let name: string
		if (typeof ptr === 'string') {
			name = ptr
		} else {
			name = tos(ptr)
		}
		
		const now = performance.now()
	
		if (!finished) {
			timed.set(name, now)
			return
		}
		
		const start = timed.get(name)
		if (start === undefined) {
			console.log(name, 'unknown')
			return
		}

		const time = now - start
		timed_completely.push([name, time])
	}

	function init() {
		timed_completely.length = 0
	}

	function totals() {
		let total = timed_completely.reduce((acc, [, time]) => acc + time, 0)
		/* for (const [name, time] of timed_completely) {
			console.log(`${name} ${time.toFixed(1)}ms ${(time / total * 100).toFixed(1)}%`)
		} */
		// create table
		const table: any[] = []
		for (const [name, time] of timed_completely) {
			table.push({ name, time: +time.toFixed(1), percent: (time / total * 100).toFixed(1) + '%' })
		}

		console.table(table)
	}

	return {
		timeit_init: init,
		timeit: _timeit,
		timeit_totals: totals,
	}
}
