(async () => {
	const fs = require('node:fs');

	// wasm-as 'fmul_fma_test.wasm' --enable-relaxed-simd --enable-simd
	const data = fs.readFileSync('fmul_fma_test.wasm');
	const m = await WebAssembly.instantiate(data)

	console.log(m.instance.exports.fmul_1(1, 2))
	console.log(m.instance.exports.fmul_fma_1(1, 2))


	// node --print-code fmul_fma_test.js | grep 'vfmadd213pd'

	// vfmadd instructions do exist in the binary, but they're generating different answers

	// node fmul_fma_test.js 
	// # 2
	// # 1.9999999999999998

})()