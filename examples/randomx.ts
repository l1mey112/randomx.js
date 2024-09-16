import { randomx_create_vm, randomx_init_cache } from '../src/index'

// cache construction takes on average 1 second
const cache = randomx_init_cache('test key 000')
const randomx = randomx_create_vm(cache)

const time_now = performance.now()
console.log(randomx.calculate_hex_hash('Lorem ipsum dolor sit amet'))
console.log('time', performance.now() - time_now, 'ms')
