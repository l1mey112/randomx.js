# randomx.js

**RandomX.js is an implementation of the ubiquitous Monero POW algorithm RandomX in JavaScript.** Theorised by its creator and others to be near impossible to run on JS with only web standards, hashes are computed just fine. This is an attempt to build a RandomX implementation that is as fast as possible, compliant with the RandomX specification, simple to read and understand, and matches the (simple) reference API as closely as possible.

> [RandomX](https://github.com/tevador/RandomX) is a proof-of-work (PoW) algorithm that is optimized for general-purpose CPUs. RandomX uses random code execution (hence the name) together with several memory-hard techniques to minimize the efficiency advantage of specialized hardware.

```
$ PRODUCTION=1 scripts/build.ts
$ node examples/randomx.js
JIT using: baseline + relaxed-simd
cache construction time 579.7 ms
average hashrate: 19.7 H/s

$ bun examples/randomx.js
JIT using: baseline
cache construction time 1071.8 ms
average hashrate: 12.5 H/s
```

Hashrate was speculated to be 1 H/s per thread, this beats it at still a pitiful 20 H/s. On the same machine, 100 H/s per thread is achieved when mining in light/verification mode, so 5x slower ain't that bad. Mining with an initialised dataset (2 GiB allocation) is not supported (though easy to implement), no one on earth would give a webpage multiple gigabytes of memory. **Light/verification mode only.**

## Implmentation

This codebase can be used to learn about RandomX, and its individual stages implemented with simple code. The library contains zero JavaScript dependencies, with pure freestanding C code that doesn't depend on a standard library. **All C++ code has been reimplemented or removed. C++ is a cancer that made the original library impossible to understand in one piece.**

![RandomX.js](media/overview.png)

Virtual machine executions use a JIT compiler ([superscalarhash](src/jit/jit_ssh.c), [randomx](src/jit/jit_vm.c)) to generate WASM on the fly, **the library does not use an interpreter.** The SuperscalarHash function can be used separately, with its implementation also being JIT code. To generate hashes the library calls into the JIT which hands back the code, which is then executed, repeating up till `RANDOMX_PROGRAM_COUNT` ([JS entrypoint](src/vm/vm.ts)).

Vector instructions are used where possible in the library ([argon2](src/argon2fill/argon2fill_v128.c), [semifloat](src/jit/stubs/semifloat.c)) and in JIT code, and AES-NI rounds are emulated in software ([softaes](src/aes/softaes.c)).

RandomX requires the use of multiple floating point rounding modes adjustable during VM execution, which are not supported in JavaScript. Performant emulations ([semifloat](src/jit/stubs/semifloat.c)) are used in place of these, which I am not opting to call "softfloat". A better name for these would be "semifloat", as they implement the rounding modes in terms of floating point operations rounded to nearest, ties to even. This libraries semifloat implementation is rigorously tested, with a 200k LOC test suite ([harness](tests/semifloat/semifloat_test.c)).

The library is entirely compliant with reference implementation, and all components been tested properly ([tests](tests), [harness](tests/harness.c), [harness wrapper](tests/harness.ts)). Reaching compliance was done by single stepping the virtual machine and diffing the state with the reference implementation ([breakpoint function](src/vm/vm.c), [JIT instrumentation](src/jit/jit_vm_inst.c)).

