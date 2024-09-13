import { randomx_create_vm, randomx_init_cache } from '../src/index'

// cache construction takes on average 1 second
const cache = randomx_init_cache()
const randomx = randomx_create_vm(cache)

console.log(randomx.hash(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])))
