import { stat } from 'node:fs/promises'

async function mtime(path: string) {
	const stats = await stat(path)
	return stats.mtimeMs
}

// recursively find all files inside `src/${object}` and compute the most recent mtime, ignoring `.wasm` artefacts
const _mtimeof_object_memo = new Map<string, number>()
async function mtimeof_object(object: string) {
	const memo = _mtimeof_object_memo.get(object)
	if (memo) {
		return memo
	}

	const object_dep_glob = new Bun.Glob(`${object}/**/*`)

	let max_mtime = 0
	for await (const fp of object_dep_glob.scan('src')) {
		if (fp.endsWith('.wasm')) {
			continue
		}

		const fp_mtime = await mtime(fp)
		if (fp_mtime > max_mtime) {
			max_mtime = fp_mtime
		}
	}

	_mtimeof_object_memo.set(object, max_mtime)
	return max_mtime
}

async function compile(artefact: string, objects: string[]) {
	const artefact_mtime = await mtime(artefact)

	let needs_recompile = false
	const mtimes = await Promise.all(objects.map(mtimeof_object))

	if (mtimes.some(object_mtime => object_mtime > artefact_mtime)) {
		needs_recompile = true
	}

	if (!needs_recompile) {
		return
	}
}

type Artefact = {
	artefact: string
	objects: string[]
}

/* {
	'src/dataset/dataset.wasm': ['dataset', 'blake2b', 'argon2fill', 'printf', 'jit'],
	'src/vm/vm.wasm': ['vm', 'blake2b', 'argon2fill', 'aes', 'printf', 'jit'],
	'tests/harness.wasm': ['dataset', 'vm', 'blake2b', 'argon2fill', 'aes', 'printf', 'jit'],
} */

const build: Artefact[] = [
	{
		artefact: 'src/dataset/dataset.wasm',
		objects: ['@dataset', '@blake2b', '@argon2fill', '@printf', '@jit'],
	},
]

const promises = Object.entries(c_artefacts).map(([artefact, objects]) => compile(artefact, objects))
await Promise.all(promises)
