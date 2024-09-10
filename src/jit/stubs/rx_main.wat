#define RANDOMX_SCRATCHPAD_MASK      (RANDOMX_SCRATCHPAD_L3-64)

(module
	(memory 0)

	(func (export "rx_main") (param $vm_ptr i32) (param $scratchpad_ptr i32) (param $vm_iterations i32)
		(local $ma_mx i64)
		(local $tmp i32)
		(local $r0 i64) (local $r1 i64) (local $r2 i64) (local $r3 i64) (local $r4 i64) (local $r5 i64) (local $r6 i64) (local $r7 i64)
		(local $f0 v128) (local $f1 v128) (local $f2 v128) (local $f3 v128)
		(local $e0 v128) (local $e1 v128) (local $e2 v128) (local $e3 v128)

		(local.set $ma_mx (i32.load offset=288 (local.get $vm_ptr))) ;; sp_addr0 = vm_ptr->ma

		loop
			;; 1.
			;; sp_addr1 (ma), sp_addr0 (mx) ^= value
			;; ma is high 32 bits, mx is low 32 bits
			local.get $ma_mx
			(i64.xor (local.get $r0) (local.get $r1)) ;; read_reg0 ^ read_reg1
			i64.xor
			local.set $ma_mx


			;; 2.
			;; extract out mx and also mask by L3 scratchpad
			local.get $ma_mx
			i64.const RANDOMX_SCRATCHPAD_MASK ;; 0x00000000FFFFFFFF
			i64.and
			local.set $tmp
			(local.set $r0 (i32.xor (local.get $r0) (i32.load offset=0 (local.get $tmp)))
			(local.set $r1 (i32.xor (local.get $r1) (i32.load offset=8 (local.get $tmp)))
			(local.set $r2 (i32.xor (local.get $r2) (i32.load offset=16 (local.get $tmp)))
			(local.set $r3 (i32.xor (local.get $r3) (i32.load offset=24 (local.get $tmp)))
			(local.set $r4 (i32.xor (local.get $r4) (i32.load offset=32 (local.get $tmp)))
			(local.set $r5 (i32.xor (local.get $r5) (i32.load offset=40 (local.get $tmp)))
			(local.set $r6 (i32.xor (local.get $r6) (i32.load offset=48 (local.get $tmp)))
			(local.set $r7 (i32.xor (local.get $r7) (i32.load offset=56 (local.get $tmp)))

			;; 3.
			;; extract out ma and also mask by L3 scratchpad
			local.get $ma_mx
			i64.shr_u 32
			i64.const RANDOMX_SCRATCHPAD_MASK ;; 0x00000000FFFFFFFF
			i64.and
			local.set $tmp

			;; register group F: load i32 bit value, convert to double (over two element v128)

			;; https://nemequ.github.io/waspr/instructions/f64x2.convert_low_i32x4_s
			(local.set $f0 (f64x2.convert_low_i32x4_s (v128.load64_lane offset=0 (local.get $tmp) (v128.const 0) 0)))
			(local.set $f1 (f64x2.convert_low_i32x4_s (v128.load64_lane offset=8 (local.get $tmp) (v128.const 0) 0)))
			(local.set $f2 (f64x2.convert_low_i32x4_s (v128.load64_lane offset=16 (local.get $tmp) (v128.const 0) 0)))
			(local.set $f3 (f64x2.convert_low_i32x4_s (v128.load64_lane offset=24 (local.get $tmp) (v128.const 0) 0)))

			;; AND and OR with emask
			;;(local.set $e0 (f64x2.convert_low_i32x4_s (v128.load64_lane offset=0 (local.get $tmp) (v128.const 0) 0)))

			local.get $vm_iterations
			i32.eqz
			br_if 0
		end
	)
)
