import blake2b from './main'

blake2b('js').then(mod => {
	console.log(mod.memory)
})
