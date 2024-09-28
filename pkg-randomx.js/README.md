# RandomX.js

[RandomX.js](https://github.com/l1mey112/randomx.js) ([NPM](https://www.npmjs.com/package/randomx.js)) | [RandomWOW.js](https://github.com/l1mey112/randomx.js/tree/randomwow) ([NPM](https://www.npmjs.com/package/randomwow.js))

**RandomX.js is an implementation of the ubiquitous Monero POW algorithm RandomX in JavaScript.** This package is part of a monorepo, containing NPM packages [RandomX.js](https://www.npmjs.com/package/randomx.js) and [RandomWOW.js](https://www.npmjs.com/package/randomwow.js).

```ts
// npm i randomx.js
import { randomx_create_vm, randomx_init_cache } from 'randomx.js'

const cache = randomx_init_cache('optional key')
const randomx = randomx_create_vm(cache)

console.log(randomx.calculate_hash('hello world')) // Uint8Array
```

> [RandomX](https://github.com/tevador/RandomX) is a proof-of-work (PoW) algorithm that is optimized for general-purpose CPUs. RandomX uses random code execution (hence the name) together with several memory-hard techniques to minimize the efficiency advantage of specialized hardware.

Appreciate the undertaking? Consider a donation.

| Crypto  | Donation Address |
| ------------- | ------------- |
| XMR  | 85vt1KvVz82Dd7AoVWXxnPCubutVT9NRNTAoxKFnXNpzcUfLFZ7rBtjbxonPTD5roE998XczLAoCrUD7tPS84AUQ8cZXHRM |
| WOW  | WW3asfacxETEgtUFVXGBfnJUqmMgNrVdWJTDouT63Ly4B1B9xiqj2g6bDPS8jZNn6pXY5pj4dnmTtL1gLRTAxXwz1LQhsua1R |
