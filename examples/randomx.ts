import { randomx_construct_cache, randomx_construct_vm } from '../src/index'

// cache construction takes on average 1 second
const cache = await randomx_construct_cache()
const randomx = await randomx_construct_vm(cache)

console.log(randomx.hash(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])))
