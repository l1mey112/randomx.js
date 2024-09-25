(module
  (type (;0;) (func))
  (type (;1;) (func (param i64) (result i64 i64 i64 i64 i64 i64 i64 i64)))
  (type (;2;) (func (param i64 i64) (result i64)))
  (type (;3;) (func (param v128 v128) (result v128)))
  (type (;4;) (func (param v128) (result v128)))
  (type (;5;) (func (param i32 i32 i32 i32 i32 i32)))
  (import "e" "m" (memory (;0;) 0))
  (import "e" "d" (func (;0;) (type 1)))
  (import "e" "b" (func (;1;) (type 5)))
  (func (;2;) (type 0)
    (local $r0 i64) (local $r1 i64) (local $r2 i64) (local $r3 i64) (local $r4 i64) (local $r5 i64) (local $r6 i64) (local $r7 i64) (local $f0 v128) (local $f1 v128) (local $f2 v128) (local $f3 v128) (local $e0 v128) (local $e1 v128) (local $e2 v128) (local $e3 v128) (local $a0 v128) (local $a1 v128) (local $a2 v128) (local $a3 v128) (local $sp_addr0 i32) (local $sp_addr1 i32) (local $mx i32) (local $ma i32) (local $tmp i32) (local $ic i32) (local $tmp64 i64) (local $mask_mant v128) (local $mask_exp v128)
    i32.const 2248224
    local.set $tmp
    local.get $tmp
    i64.load
    local.set $r0
    local.get $tmp
    i64.load offset=8
    local.set $r1
    local.get $tmp
    i64.load offset=16
    local.set $r2
    local.get $tmp
    i64.load offset=24
    local.set $r3
    local.get $tmp
    i64.load offset=32
    local.set $r4
    local.get $tmp
    i64.load offset=40
    local.set $r5
    local.get $tmp
    i64.load offset=48
    local.set $r6
    local.get $tmp
    i64.load offset=56
    local.set $r7
    local.get $tmp
    v128.load offset=64
    local.set $f0
    local.get $tmp
    v128.load offset=80
    local.set $f1
    local.get $tmp
    v128.load offset=96
    local.set $f2
    local.get $tmp
    v128.load offset=112
    local.set $f3
    local.get $tmp
    v128.load offset=128
    local.set $e0
    local.get $tmp
    v128.load offset=144
    local.set $e1
    local.get $tmp
    v128.load offset=160
    local.set $e2
    local.get $tmp
    v128.load offset=176
    local.set $e3
    local.get $tmp
    v128.load offset=192
    local.set $a0
    local.get $tmp
    v128.load offset=208
    local.set $a1
    local.get $tmp
    v128.load offset=224
    local.set $a2
    local.get $tmp
    v128.load offset=240
    local.set $a3
    local.get $tmp
    v128.load offset=256
    local.set $mask_exp
    local.get $tmp
    v128.load offset=272
    local.set $mask_mant
    local.get $tmp
    i32.load offset=288
    global.set $fprc
    local.get $tmp
    i32.load offset=292
    local.tee $ma
    local.set $sp_addr1
    local.get $tmp
    i32.load offset=296
    local.tee $mx
    local.set $sp_addr0
    i32.const 2048
    local.set $ic
    loop  ;; label = @1
      local.get $r0
      local.get $r3
      i64.xor
      local.set $tmp64
      local.get $tmp64
      i32.wrap_i64
      local.get $sp_addr0
      i32.xor
      i32.const 2097088
      i32.and
      local.set $sp_addr0
      local.get $tmp64
      i64.const 32
      i64.shr_u
      i32.wrap_i64
      local.get $sp_addr1
      i32.xor
      i32.const 2097088
      i32.and
      local.set $sp_addr1
      i32.const 151072
      local.get $sp_addr0
      i32.add
      local.set $tmp
      local.get $tmp
      i64.load
      local.get $r0
      i64.xor
      local.set $r0
      local.get $tmp
      i64.load offset=8
      local.get $r1
      i64.xor
      local.set $r1
      local.get $tmp
      i64.load offset=16
      local.get $r2
      i64.xor
      local.set $r2
      local.get $tmp
      i64.load offset=24
      local.get $r3
      i64.xor
      local.set $r3
      local.get $tmp
      i64.load offset=32
      local.get $r4
      i64.xor
      local.set $r4
      local.get $tmp
      i64.load offset=40
      local.get $r5
      i64.xor
      local.set $r5
      local.get $tmp
      i64.load offset=48
      local.get $r6
      i64.xor
      local.set $r6
      local.get $tmp
      i64.load offset=56
      local.get $r7
      i64.xor
      local.set $r7
      i32.const 151072
      local.get $sp_addr1
      i32.add
      local.set $tmp
      local.get $tmp
      v128.load64_zero
      f64x2.convert_low_i32x4_s
      local.set $f0
      local.get $tmp
      v128.load64_zero offset=8
      f64x2.convert_low_i32x4_s
      local.set $f1
      local.get $tmp
      v128.load64_zero offset=16
      f64x2.convert_low_i32x4_s
      local.set $f2
      local.get $tmp
      v128.load64_zero offset=24
      f64x2.convert_low_i32x4_s
      local.set $f3
      local.get $tmp
      v128.load64_zero offset=32
      f64x2.convert_low_i32x4_s
      local.get $mask_mant
      v128.and
      local.get $mask_exp
      v128.or
      local.set $e0
      local.get $tmp
      v128.load64_zero offset=40
      f64x2.convert_low_i32x4_s
      local.get $mask_mant
      v128.and
      local.get $mask_exp
      v128.or
      local.set $e1
      local.get $tmp
      v128.load64_zero offset=48
      f64x2.convert_low_i32x4_s
      local.get $mask_mant
      v128.and
      local.get $mask_exp
      v128.or
      local.set $e2
      local.get $tmp
      v128.load64_zero offset=56
      f64x2.convert_low_i32x4_s
      local.get $mask_mant
      v128.and
      local.get $mask_exp
      v128.or
      local.set $e3
      local.get $r3
      local.get $r7
      call $imul128hi
      local.set $r3
      local.get $e0
      local.get $a3
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e0
      local.get $r6
      local.get $r4
      i64.const 1
      i64.shl
      i64.add
      local.set $r6
      local.get $r3
      i64.const 969521492
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      local.get $r5
      i64.store align=4
      local.get $r0
      local.get $r5
      i64.const 1118010178
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.sub
      local.set $r0
      loop  ;; label = @2
        local.get $r3
        local.get $r2
        i64.const 793391599
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.xor
        local.set $r3
        local.get $r3
        local.get $r1
        i64.const 1
        i64.shl
        i64.add
        local.set $r3
        local.get $r7
        local.get $r4
        i64.const 1
        i64.shl
        i64.add
        local.set $r7
        local.get $r0
        i64.const -1396239068
        i64.add
        local.tee $r0
        i64.const 16711680
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      local.get $r7
      local.get $r7
      call $imul128hi
      local.set $r7
      local.get $r7
      local.get $r1
      call $imul128hi
      local.set $r7
      local.get $r5
      i64.const 245509754
      i64.add
      i32.wrap_i64
      i32.const 262136
      i32.and
      i32.const 151072
      i32.add
      local.get $r7
      i64.store align=4
      local.get $f2
      v128.const i32x4 0x0b0a0908 0x0f0e0d0c 0x03020100 0x07060504
      i8x16.swizzle
      local.set $f2
      local.get $r7
      local.get $r0
      i64.rotr
      local.set $r7
      loop  ;; label = @2
        local.get $r2
        local.get $r6
        i64.const 154777710
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.add
        local.set $r2
        local.get $f2
        local.get $a1
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f2
        local.get $f2
        local.get $a3
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f2
        local.get $r7
        i64.const 1995891970
        i64.add
        local.tee $r7
        i64.const 33423360
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $f1
        local.get $a3
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f1
        local.get $r4
        local.get $r6
        i64.xor
        local.set $r4
        local.get $r3
        local.get $r0
        i64.const 1
        i64.shl
        i64.add
        local.set $r3
        local.get $r3
        local.get $r5
        i64.sub
        local.set $r3
        local.get $r5
        i64.const 276446247
        i64.add
        local.tee $r5
        i64.const 261120
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $r5
        i64.const -2024626917
        i32.wrap_i64
        i32.const 2097144
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.sub
        local.set $r5
        local.get $r3
        i64.const -1362325766
        i64.xor
        local.set $r3
        local.get $r1
        i64.const 223125140
        i64.add
        local.tee $r1
        i64.const 8355840
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $e1
        global.get $fprc
        call_indirect $fsqrt_table (type 4)
        local.set $e1
        local.get $r4
        i64.const 1115712497
        i64.add
        local.tee $r4
        i64.const 522240
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      local.get $r1
      local.get $r7
      i64.sub
      local.set $r1
      local.get $r5
      local.get $r5
      i64.const 0
      i64.shl
      i64.add
      i64.const 318781782
      i64.add
      local.set $r5
      local.get $r4
      i64.const 800073119
      i64.rotl
      local.set $r4
      local.get $e2
      local.get $a1
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e2
      local.get $r1
      local.get $r6
      i64.const -409059162
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.add
      local.set $r1
      local.get $r3
      local.get $r5
      i64.xor
      local.set $r3
      local.get $r1
      local.get $r5
      i64.const 411940638
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.sub
      local.set $r1
      local.get $r7
      local.get $r5
      i64.sub
      local.set $r7
      local.get $e1
      local.get $r7
      i64.const 216825365
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      v128.load64_zero
      f64x2.convert_low_i32x4_s
      local.get $mask_mant
      v128.and
      local.get $mask_exp
      v128.or
      global.get $fprc
      call_indirect $fdiv_table (type 3)
      local.set $e1
      local.get $e0
      local.get $a1
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e0
      local.get $f0
      local.get $a2
      global.get $fprc
      call_indirect $fsub_table (type 3)
      local.set $f0
      local.get $r0
      local.get $r3
      i64.const 2
      i64.shl
      i64.add
      local.set $r0
      loop  ;; label = @2
        local.get $r6
        local.get $r1
        i64.xor
        local.set $r6
        local.get $r2
        local.get $r3
        i64.mul
        local.set $r2
        local.get $r0
        i64.const -667046823
        i64.add
        local.tee $r0
        i64.const 8355840
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $e2
        local.get $a0
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e2
        local.get $r6
        local.get $r2
        i64.const 3
        i64.shl
        i64.add
        local.set $r6
        local.get $e3
        local.get $a1
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e3
        local.get $f2
        local.get $a1
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f2
        local.get $f1
        local.get $a1
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f1
        local.get $r2
        local.get $r1
        i64.sub
        local.set $r2
        local.get $r4
        local.get $r6
        call $imul128hi
        local.set $r4
        local.get $r3
        local.get $r1
        i64.xor
        local.set $r3
        local.get $e3
        local.get $a3
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e3
        local.get $r5
        local.get $r2
        i64.xor
        local.set $r5
        local.get $e0
        local.get $a0
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e0
        local.get $e3
        local.get $a2
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e3
        local.get $e2
        local.get $a3
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e2
        local.get $r6
        local.get $r3
        i64.const -293486700
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.xor
        local.set $r6
        local.get $r4
        local.get $r4
        i64.const 0
        i64.shl
        i64.add
        local.set $r4
        local.get $r4
        local.get $r1
        i64.rotr
        local.set $r4
        local.get $r2
        i64.const 1830362113
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        local.get $r0
        i64.store align=4
        local.get $r4
        local.get $r1
        i64.const -917764663
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        call $imul128hi
        local.set $r4
        local.get $e1
        global.get $fprc
        call_indirect $fsqrt_table (type 4)
        local.set $e1
        local.get $r4
        local.get $r3
        i64.const -1214058920
        i64.add
        i32.wrap_i64
        i32.const 262136
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.sub
        local.set $r4
        local.get $e3
        local.get $a3
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e3
        local.get $f1
        v128.const i32x4 0x00000000 0x80f00000 0x00000000 0x80f00000
        v128.xor
        local.set $f1
        local.get $r2
        local.get $r4
        local.set $r2
        local.set $r4
        local.get $r7
        local.get $r1
        i64.sub
        local.set $r7
        local.get $e3
        local.get $a0
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e3
        local.get $f3
        local.get $a1
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f3
        local.get $f0
        local.get $a2
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f0
        local.get $r1
        i64.const 1387870097
        i64.add
        local.tee $r1
        i64.const 16711680
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $e1
        local.get $a3
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e1
        local.get $e3
        local.get $a2
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e3
        local.get $e1
        local.get $a2
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e1
        local.get $f3
        v128.const i32x4 0x00000000 0x80f00000 0x00000000 0x80f00000
        v128.xor
        local.set $f3
        local.get $f2
        local.get $a3
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f2
        local.get $r5
        local.get $r3
        i64.const 1917140173
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.mul
        local.set $r5
        local.get $e2
        global.get $fprc
        call_indirect $fsqrt_table (type 4)
        local.set $e2
        local.get $f1
        local.get $a0
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f1
        local.get $r1
        i64.const -334539495
        i64.rotr
        local.set $r1
        local.get $f3
        local.get $a0
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f3
        local.get $r4
        local.get $r6
        i64.const -1818849580
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.sub
        local.set $r4
        local.get $f3
        local.get $a3
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f3
        local.get $e1
        local.get $a3
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e1
        local.get $r1
        local.get $r6
        i64.mul
        local.set $r1
        local.get $r3
        i64.const -108078319
        i64.add
        local.tee $r3
        i64.const 522240
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $e1
        local.get $a2
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e1
        local.get $r1
        local.get $r3
        i64.const -2144919924
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        call $mul128hi
        local.set $r1
        local.get $f3
        local.get $a1
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f3
        local.get $e0
        local.get $a0
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e0
        local.get $e1
        local.get $a1
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e1
        local.get $r1
        local.get $r5
        i64.const 3
        i64.shl
        i64.add
        local.set $r1
        local.get $r3
        local.get $r5
        i64.const 0
        i64.shl
        i64.add
        local.set $r3
        local.get $r1
        local.get $r3
        i64.sub
        local.set $r1
        local.get $f0
        v128.const i32x4 0x0b0a0908 0x0f0e0d0c 0x03020100 0x07060504
        i8x16.swizzle
        local.set $f0
        local.get $r2
        i64.const -2128535023
        i64.add
        local.tee $r2
        i64.const 2088960
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      local.get $f0
      local.get $r7
      i64.const -655077654
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      v128.load64_zero
      f64x2.convert_low_i32x4_s
      global.get $fprc
      call_indirect $fsub_table (type 3)
      local.set $f0
      local.get $r1
      i64.const -1823539311
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      local.get $r5
      i64.store align=4
      local.get $r7
      local.get $r5
      i64.const -1813976475
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.sub
      local.set $r7
      local.get $e1
      local.get $a2
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e1
      local.get $f0
      local.get $a1
      global.get $fprc
      call_indirect $fsub_table (type 3)
      local.set $f0
      local.get $r0
      local.get $r3
      i64.sub
      local.set $r0
      local.get $e0
      global.get $fprc
      call_indirect $fsqrt_table (type 4)
      local.set $e0
      local.get $r0
      local.get $r2
      call $imul128hi
      local.set $r0
      local.get $e2
      local.get $a1
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e2
      local.get $r7
      i64.const 14566615
      i64.mul
      local.set $r7
      local.get $e2
      local.get $a2
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e2
      local.get $r4
      local.get $r1
      i64.sub
      local.set $r4
      local.get $f2
      local.get $a2
      global.get $fprc
      call_indirect $fsub_table (type 3)
      local.set $f2
      local.get $r7
      i64.const -8499850918690746062
      i64.mul
      local.set $r7
      local.get $e3
      local.get $a1
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e3
      local.get $r5
      local.get $r6
      i64.const -1762248992
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.mul
      local.set $r5
      local.get $r7
      i64.const 163916768
      i64.add
      i32.wrap_i64
      i32.const 262136
      i32.and
      i32.const 151072
      i32.add
      local.get $r0
      i64.store align=4
      local.get $e1
      local.get $a0
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e1
      local.get $r7
      i64.const 1111453836
      i64.mul
      local.set $r7
      local.get $r7
      local.get $r6
      i64.const 1
      i64.shl
      i64.add
      local.set $r7
      local.get $e1
      local.get $a2
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e1
      local.get $r4
      local.get $r5
      i64.sub
      local.set $r4
      local.get $r6
      local.get $r5
      i64.mul
      local.set $r6
      local.get $f0
      local.get $a1
      global.get $fprc
      call_indirect $fsub_table (type 3)
      local.set $f0
      local.get $r5
      i64.const 718200770
      i64.rotr
      local.set $r5
      local.get $r7
      local.get $r0
      i64.rotr
      local.set $r7
      local.get $e0
      local.get $a1
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e0
      local.get $r4
      local.get $r2
      i64.const -1128211479
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.add
      local.set $r4
      local.get $r5
      local.get $r2
      i64.const 234510208
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.add
      local.set $r5
      local.get $r7
      local.get $r2
      i64.const 0
      i64.shl
      i64.add
      local.set $r7
      local.get $r7
      local.get $r3
      local.set $r7
      local.set $r3
      local.get $r4
      local.get $r3
      i64.const 196944966
      i64.add
      i32.wrap_i64
      i32.const 262136
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.xor
      local.set $r4
      loop  ;; label = @2
        local.get $r3
        local.get $r7
        i64.sub
        local.set $r3
        local.get $r2
        local.get $r4
        i64.const -1333045063
        i64.add
        i32.wrap_i64
        i32.const 262136
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.sub
        local.set $r2
        local.get $r4
        i64.const 382806883
        i64.add
        local.tee $r4
        i64.const 522240
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      local.get $r0
      local.get $r7
      i64.sub
      local.set $r0
      local.get $e2
      global.get $fprc
      call_indirect $fsqrt_table (type 4)
      local.set $e2
      local.get $r0
      local.get $r6
      local.set $r0
      local.set $r6
      local.get $r1
      local.get $r4
      i64.mul
      local.set $r1
      local.get $r7
      i64.const 655523839
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      local.get $r2
      i64.store align=4
      local.get $f2
      local.get $r3
      i64.const 104686266
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      v128.load64_zero
      f64x2.convert_low_i32x4_s
      global.get $fprc
      call_indirect $fadd_table (type 3)
      local.set $f2
      local.get $f1
      v128.const i32x4 0x00000000 0x80f00000 0x00000000 0x80f00000
      v128.xor
      local.set $f1
      local.get $r6
      i64.const -254853050
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      local.get $r4
      i64.store align=4
      local.get $e0
      local.get $r4
      i64.const 1479235309
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      v128.load64_zero
      f64x2.convert_low_i32x4_s
      local.get $mask_mant
      v128.and
      local.get $mask_exp
      v128.or
      global.get $fprc
      call_indirect $fdiv_table (type 3)
      local.set $e0
      local.get $r4
      local.get $r7
      i64.const -592341933
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.mul
      local.set $r4
      local.get $r6
      local.get $r5
      i64.const 2
      i64.shl
      i64.add
      local.set $r6
      local.get $f0
      local.get $a1
      global.get $fprc
      call_indirect $fsub_table (type 3)
      local.set $f0
      local.get $r3
      local.get $r6
      call $mul128hi
      local.set $r3
      local.get $r0
      i64.const 1511339760
      i64.sub
      local.set $r0
      loop  ;; label = @2
        local.get $r5
        local.get $r0
        i64.mul
        local.set $r5
        local.get $r1
        local.get $r7
        i64.const -255532851
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.add
        local.set $r1
        local.get $f0
        local.get $a0
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f0
        local.get $f3
        local.get $a1
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f3
        local.get $e0
        local.get $r6
        i64.const -1860289110
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        v128.load64_zero
        f64x2.convert_low_i32x4_s
        local.get $mask_mant
        v128.and
        local.get $mask_exp
        v128.or
        global.get $fprc
        call_indirect $fdiv_table (type 3)
        local.set $e0
        local.get $f2
        local.get $r2
        i64.const 1139466453
        i64.add
        i32.wrap_i64
        i32.const 262136
        i32.and
        i32.const 151072
        i32.add
        v128.load64_zero
        f64x2.convert_low_i32x4_s
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f2
        i64.const 0
        local.get $r6
        i64.sub
        local.set $r6
        local.get $r7
        i64.const -1816812507768490384
        i64.mul
        local.set $r7
        local.get $r1
        i64.const -1135279372
        i64.sub
        local.set $r1
        local.get $r3
        local.get $r4
        i64.const 44069533
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.add
        local.set $r3
        local.get $r5
        local.get $r4
        i64.const -477428991
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.sub
        local.set $r5
        local.get $f1
        local.get $r6
        i64.const 1261945513
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        v128.load64_zero
        f64x2.convert_low_i32x4_s
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f1
        local.get $f0
        local.get $a0
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f0
        local.get $r4
        local.get $r4
        i64.const 3
        i64.shl
        i64.add
        local.set $r4
        local.get $r0
        i64.const -687028818
        i64.add
        local.tee $r0
        i64.const 261120
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $e1
        local.get $a2
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e1
        local.get $r6
        i64.const -425317409
        i64.add
        local.tee $r6
        i64.const 33423360
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $r7
        local.get $r1
        local.set $r7
        local.set $r1
        local.get $f1
        local.get $a2
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f1
        local.get $r0
        local.get $r5
        i64.sub
        local.set $r0
        local.get $r1
        i64.const -928416212118856102
        i64.mul
        local.set $r1
        local.get $e1
        local.get $a0
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e1
        local.get $e1
        local.get $a0
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e1
        local.get $r3
        local.get $r5
        i64.mul
        local.set $r3
        local.get $f1
        local.get $r0
        i64.const -944316606
        i64.add
        i32.wrap_i64
        i32.const 262136
        i32.and
        i32.const 151072
        i32.add
        v128.load64_zero
        f64x2.convert_low_i32x4_s
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f1
        local.get $e1
        local.get $a0
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e1
        local.get $f2
        local.get $r6
        i64.const -1235929455
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        v128.load64_zero
        f64x2.convert_low_i32x4_s
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f2
        local.get $r5
        i64.const -1238585088
        i64.add
        local.tee $r5
        i64.const 8355840
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      local.get $f0
      local.get $a0
      global.get $fprc
      call_indirect $fsub_table (type 3)
      local.set $f0
      local.get $r3
      i64.const -5828268144652892016
      i64.mul
      local.set $r3
      local.get $f3
      local.get $a2
      global.get $fprc
      call_indirect $fadd_table (type 3)
      local.set $f3
      local.get $r4
      i64.const -314289929
      i64.sub
      local.set $r4
      local.get $e3
      local.get $a0
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e3
      local.get $r6
      local.get $r3
      i64.const 0
      i64.shl
      i64.add
      local.set $r6
      local.get $f0
      local.get $a3
      global.get $fprc
      call_indirect $fsub_table (type 3)
      local.set $f0
      local.get $r6
      local.get $r7
      i64.const -1677759510
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.add
      local.set $r6
      local.get $r3
      local.get $r5
      i64.const -184999951
      i64.add
      i32.wrap_i64
      i32.const 262136
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.sub
      local.set $r3
      local.get $r2
      i64.const 1153394911
      i64.sub
      local.set $r2
      local.get $r2
      local.get $r6
      i64.rotr
      local.set $r2
      local.get $r6
      i64.const -249140426
      i32.wrap_i64
      i32.const 2097144
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.xor
      local.set $r6
      local.get $f0
      local.get $a1
      global.get $fprc
      call_indirect $fsub_table (type 3)
      local.set $f0
      local.get $r1
      local.get $r2
      i64.xor
      local.set $r1
      local.get $r1
      local.get $r1
      i64.const 1
      i64.shl
      i64.add
      local.set $r1
      local.get $e2
      global.get $fprc
      call_indirect $fsqrt_table (type 4)
      local.set $e2
      local.get $f2
      local.get $a2
      global.get $fprc
      call_indirect $fsub_table (type 3)
      local.set $f2
      local.get $r7
      local.get $r3
      i64.const -1726899835
      i64.add
      i32.wrap_i64
      i32.const 262136
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.add
      local.set $r7
      loop  ;; label = @2
        local.get $r2
        i64.const 1821433026
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        local.get $r5
        i64.store align=4
        local.get $r6
        i64.const -2320538190987485368
        i64.mul
        local.set $r6
        local.get $r6
        i64.const -7094764731265187527
        i64.mul
        local.set $r6
        local.get $r0
        local.get $r7
        i64.mul
        local.set $r0
        local.get $r1
        local.get $r2
        i64.sub
        local.set $r1
        local.get $r6
        local.get $r2
        i64.const 0
        i64.shl
        i64.add
        local.set $r6
        local.get $r7
        i64.const 1173307283
        i64.add
        local.tee $r7
        i64.const 534773760
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      local.get $r0
      i64.const 1220523756
      i64.add
      i32.wrap_i64
      i32.const 262136
      i32.and
      i32.const 151072
      i32.add
      local.get $r7
      i64.store align=4
      local.get $r5
      i64.const -1168945360
      i64.add
      i32.wrap_i64
      i32.const 2097144
      i32.and
      i32.const 151072
      i32.add
      local.get $r5
      i64.store align=4
      local.get $e0
      local.get $a3
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e0
      local.get $f1
      local.get $a3
      global.get $fprc
      call_indirect $fadd_table (type 3)
      local.set $f1
      local.get $r6
      local.get $r3
      i64.xor
      local.set $r6
      local.get $f3
      v128.const i32x4 0x00000000 0x80f00000 0x00000000 0x80f00000
      v128.xor
      local.set $f3
      local.get $r4
      local.get $r0
      i64.sub
      local.set $r4
      local.get $r6
      local.get $r2
      i64.xor
      local.set $r6
      local.get $r6
      local.get $r4
      i64.const -1277516832
      i64.add
      i32.wrap_i64
      i32.const 16376
      i32.and
      i32.const 151072
      i32.add
      i64.load align=4
      i64.sub
      local.set $r6
      loop  ;; label = @2
        local.get $f0
        v128.const i32x4 0x00000000 0x80f00000 0x00000000 0x80f00000
        v128.xor
        local.set $f0
        local.get $r1
        local.get $r3
        i64.rotr
        local.set $r1
        local.get $f2
        local.get $a3
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f2
        local.get $f3
        local.get $a0
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f3
        local.get $f1
        local.get $a0
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f1
        local.get $r6
        i64.const -1362085365
        i64.add
        local.tee $r6
        i64.const 267386880
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $f2
        local.get $a2
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f2
        local.get $f1
        v128.const i32x4 0x00000000 0x80f00000 0x00000000 0x80f00000
        v128.xor
        local.set $f1
        local.get $r2
        i64.const -130405178
        i32.wrap_i64
        i32.const 2097144
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.sub
        local.set $r2
        local.get $f3
        local.get $r1
        i64.const -1455359064
        i64.add
        i32.wrap_i64
        i32.const 262136
        i32.and
        i32.const 151072
        i32.add
        v128.load64_zero
        f64x2.convert_low_i32x4_s
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f3
        local.get $f0
        local.get $a2
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f0
        local.get $f2
        local.get $a3
        global.get $fprc
        call_indirect $fadd_table (type 3)
        local.set $f2
        local.get $e2
        global.get $fprc
        call_indirect $fsqrt_table (type 4)
        local.set $e2
        local.get $r2
        local.get $r6
        call $mul128hi
        local.set $r2
        local.get $r0
        i64.const -1043664768
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        local.get $r3
        i64.store align=4
        local.get $r4
        i64.const 1385793297
        i64.add
        local.tee $r4
        i64.const 133693440
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $r4
        i64.const -48221892
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        local.get $r6
        i64.store align=4
        local.get $f2
        local.get $a2
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f2
        local.get $r7
        i64.const -1896133691
        i64.add
        local.tee $r7
        i64.const 16711680
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $f0
        local.get $a3
        global.get $fprc
        call_indirect $fsub_table (type 3)
        local.set $f0
        local.get $r5
        i64.const -7637657699972193295
        i64.mul
        local.set $r5
        local.get $r3
        local.get $r4
        i64.const 427831038
        i64.add
        i32.wrap_i64
        i32.const 262136
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.mul
        local.set $r3
        local.get $e1
        local.get $a1
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e1
        local.get $r5
        local.get $r7
        i64.sub
        local.set $r5
        local.get $r7
        i64.const -1938993141
        i64.add
        local.tee $r7
        i64.const 66846720
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $r5
        i64.const 541771258
        i64.sub
        local.set $r5
        local.get $e1
        local.get $a0
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e1
        local.get $r2
        local.get $r0
        i64.const -1772555376
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.mul
        local.set $r2
        local.get $r1
        local.get $r0
        i64.const 1
        i64.shl
        i64.add
        local.set $r1
        local.get $r3
        local.get $r0
        i64.sub
        local.set $r3
        local.get $e0
        local.get $a2
        global.get $fprc
        call_indirect $fmul_table (type 3)
        local.set $e0
        i64.const 0
        local.get $r4
        i64.sub
        local.set $r4
        local.get $r2
        local.get $r1
        i64.mul
        local.set $r2
        local.get $r7
        local.get $r2
        i64.const 113751373
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.xor
        local.set $r7
        local.get $r7
        i64.const -963330548
        i64.add
        i32.wrap_i64
        i32.const 262136
        i32.and
        i32.const 151072
        i32.add
        local.get $r2
        i64.store align=4
        local.get $r1
        local.get $r3
        i64.const 1
        i64.shl
        i64.add
        local.set $r1
        local.get $r0
        local.get $r3
        i64.xor
        local.set $r0
        local.get $r7
        local.get $r3
        i64.xor
        local.set $r7
        local.get $r4
        i64.const 546273891
        i64.add
        i32.wrap_i64
        i32.const 262136
        i32.and
        i32.const 151072
        i32.add
        local.get $r0
        i64.store align=4
        local.get $r6
        i64.const -236470279
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        local.get $r0
        i64.store align=4
        local.get $r4
        i64.const -1636136227
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        local.get $r0
        i64.store align=4
        local.get $r6
        i64.const 1554944057
        i64.add
        local.tee $r6
        i64.const 33423360
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      loop  ;; label = @2
        local.get $r2
        local.get $r3
        i64.const -1879659600
        i64.add
        i32.wrap_i64
        i32.const 262136
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        call $mul128hi
        local.set $r2
        local.get $r0
        local.get $r3
        i64.const -566292262
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.xor
        local.set $r0
        local.get $r5
        local.get $r7
        i64.const -1969631936
        i64.add
        i32.wrap_i64
        i32.const 16376
        i32.and
        i32.const 151072
        i32.add
        i64.load align=4
        i64.sub
        local.set $r5
        local.get $r4
        i64.const -328232139
        i64.add
        local.tee $r4
        i64.const 1044480
        i64.and
        i64.eqz
        br_if 0 (;@2;)
      end
      local.get $e0
      local.get $a3
      global.get $fprc
      call_indirect $fmul_table (type 3)
      local.set $e0
      local.get $r3
      local.get $r1
      i64.sub
      local.set $r3
      local.get $e0
      global.get $fprc
      call_indirect $fsqrt_table (type 4)
      local.set $e0
      local.get $r5
      local.get $r7
      i64.xor
      i32.wrap_i64
      local.get $mx
      i32.xor
      i32.const 2147483584
      i32.and
      local.set $mx
      local.get $ma
      i64.extend_i32_u
      i64.const 25654720
      i64.add
      i64.const 6
      i64.shr_u
      call 0
      local.get $r7
      i64.xor
      local.set $r7
      local.get $r6
      i64.xor
      local.set $r6
      local.get $r5
      i64.xor
      local.set $r5
      local.get $r4
      i64.xor
      local.set $r4
      local.get $r3
      i64.xor
      local.set $r3
      local.get $r2
      i64.xor
      local.set $r2
      local.get $r1
      i64.xor
      local.set $r1
      local.get $r0
      i64.xor
      local.set $r0
      local.get $mx
      local.get $ma
      local.set $mx
      local.set $ma
      i32.const 151072
      local.get $sp_addr1
      i32.add
      local.set $tmp
      local.get $tmp
      local.get $r0
      i64.store
      local.get $tmp
      local.get $r1
      i64.store offset=8
      local.get $tmp
      local.get $r2
      i64.store offset=16
      local.get $tmp
      local.get $r3
      i64.store offset=24
      local.get $tmp
      local.get $r4
      i64.store offset=32
      local.get $tmp
      local.get $r5
      i64.store offset=40
      local.get $tmp
      local.get $r6
      i64.store offset=48
      local.get $tmp
      local.get $r7
      i64.store offset=56
      local.get $f0
      local.get $e0
      v128.xor
      local.set $f0
      local.get $f1
      local.get $e1
      v128.xor
      local.set $f1
      local.get $f2
      local.get $e2
      v128.xor
      local.set $f2
      local.get $f3
      local.get $e3
      v128.xor
      local.set $f3
      i32.const 151072
      local.get $sp_addr0
      i32.add
      local.set $tmp
      local.get $tmp
      local.get $f0
      v128.store
      local.get $tmp
      local.get $f1
      v128.store offset=16
      local.get $tmp
      local.get $f2
      v128.store offset=32
      local.get $tmp
      local.get $f3
      v128.store offset=48
      i32.const 0
      local.set $sp_addr0
      i32.const 0
      local.set $sp_addr1
      local.get $ic
      i32.const 1
      i32.sub
      local.tee $ic
      br_if 0 (;@1;)
    end
    i32.const 2248224
    local.set $tmp
    local.get $tmp
    local.get $r0
    i64.store
    local.get $tmp
    local.get $r1
    i64.store offset=8
    local.get $tmp
    local.get $r2
    i64.store offset=16
    local.get $tmp
    local.get $r3
    i64.store offset=24
    local.get $tmp
    local.get $r4
    i64.store offset=32
    local.get $tmp
    local.get $r5
    i64.store offset=40
    local.get $tmp
    local.get $r6
    i64.store offset=48
    local.get $tmp
    local.get $r7
    i64.store offset=56
    local.get $tmp
    local.get $f0
    v128.store offset=64
    local.get $tmp
    local.get $f1
    v128.store offset=80
    local.get $tmp
    local.get $f2
    v128.store offset=96
    local.get $tmp
    local.get $f3
    v128.store offset=112
    local.get $tmp
    local.get $e0
    v128.store offset=128
    local.get $tmp
    local.get $e1
    v128.store offset=144
    local.get $tmp
    local.get $e2
    v128.store offset=160
    local.get $tmp
    local.get $e3
    v128.store offset=176
    local.get $tmp
    global.get $fprc
    i32.store offset=288)
  (func $mul128hi (type 2) (param i64 i64) (result i64)
    (local i64 i64 i64 i64)
    local.get 1
    i64.const 4294967295
    i64.and
    local.tee 2
    local.get 0
    i64.const 32
    i64.shr_u
    local.tee 3
    i64.mul
    local.tee 4
    i64.const 32
    i64.shr_u
    local.get 1
    i64.const 32
    i64.shr_u
    local.tee 1
    local.get 0
    i64.const 4294967295
    i64.and
    local.tee 0
    i64.mul
    local.tee 5
    i64.const 32
    i64.shr_u
    i64.add
    local.get 1
    local.get 3
    i64.mul
    local.tee 1
    i64.const 4294967295
    i64.and
    i64.add
    local.get 1
    i64.const -4294967296
    i64.and
    i64.add
    local.get 4
    i64.const 4294967295
    i64.and
    local.get 5
    i64.const 4294967295
    i64.and
    i64.add
    local.get 0
    local.get 2
    i64.mul
    i64.const 32
    i64.shr_u
    i64.add
    i64.const 32
    i64.shr_u
    i64.add)
  (func $imul128hi (type 2) (param i64 i64) (result i64)
    (local i64 i64 i64 i64)
    local.get 1
    i64.const 32
    i64.shr_u
    local.tee 2
    local.get 0
    i64.const 4294967295
    i64.and
    local.tee 3
    i64.mul
    local.tee 4
    i64.const 32
    i64.shr_u
    local.get 1
    i64.const 63
    i64.shr_s
    local.get 0
    i64.and
    local.get 0
    i64.const 63
    i64.shr_s
    local.get 1
    i64.and
    i64.add
    i64.sub
    local.get 1
    i64.const 4294967295
    i64.and
    local.tee 1
    local.get 0
    i64.const 32
    i64.shr_u
    local.tee 0
    i64.mul
    local.tee 5
    i64.const 32
    i64.shr_u
    i64.add
    local.get 0
    local.get 2
    i64.mul
    local.tee 0
    i64.const 4294967295
    i64.and
    i64.add
    local.get 0
    i64.const -4294967296
    i64.and
    i64.add
    local.get 5
    i64.const 4294967295
    i64.and
    local.get 4
    i64.const 4294967295
    i64.and
    i64.add
    local.get 1
    local.get 3
    i64.mul
    i64.const 32
    i64.shr_u
    i64.add
    i64.const 32
    i64.shr_u
    i64.add)
  (func (;5;) (type 3) (param v128 v128) (result v128)
    local.get 0
    local.get 1
    f64x2.add)
  (func (;6;) (type 3) (param v128 v128) (result v128)
    (local v128)
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000
    local.get 0
    local.get 1
    f64x2.add
    local.tee 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect
    local.get 2
    i64x2.add
    local.get 2
    local.get 0
    local.get 2
    local.get 1
    f64x2.sub
    f64x2.sub
    local.get 1
    local.get 2
    local.get 0
    f64x2.sub
    f64x2.sub
    f64x2.add
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.bitselect)
  (func (;7;) (type 3) (param v128 v128) (result v128)
    (local v128)
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000
    local.get 0
    local.get 1
    f64x2.add
    local.tee 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.bitselect
    local.get 2
    i64x2.add
    local.get 2
    local.get 0
    local.get 2
    local.get 1
    f64x2.sub
    f64x2.sub
    local.get 1
    local.get 2
    local.get 0
    f64x2.sub
    f64x2.sub
    f64x2.add
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect)
  (func (;8;) (type 3) (param v128 v128) (result v128)
    (local v128)
    local.get 0
    local.get 0
    local.get 1
    f64x2.add
    local.tee 2
    local.get 1
    f64x2.sub
    f64x2.sub
    local.get 1
    local.get 2
    local.get 0
    f64x2.sub
    f64x2.sub
    f64x2.add
    local.set 0
    local.get 2
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    i64x2.add
    local.get 2
    local.get 0
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    local.get 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.and
    local.get 0
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    local.get 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.and
    v128.or
    v128.bitselect)
  (func (;9;) (type 3) (param v128 v128) (result v128)
    local.get 0
    local.get 1
    f64x2.sub)
  (func (;10;) (type 3) (param v128 v128) (result v128)
    (local v128)
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000
    local.get 0
    local.get 1
    f64x2.sub
    local.tee 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect
    local.get 2
    i64x2.add
    local.get 2
    local.get 0
    local.get 2
    local.get 1
    f64x2.add
    f64x2.sub
    local.get 1
    f64x2.neg
    local.get 2
    local.get 0
    f64x2.sub
    f64x2.sub
    f64x2.add
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.bitselect)
  (func (;11;) (type 3) (param v128 v128) (result v128)
    (local v128)
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000
    local.get 0
    local.get 1
    f64x2.sub
    local.tee 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.bitselect
    local.get 2
    i64x2.add
    local.get 2
    local.get 0
    local.get 2
    local.get 1
    f64x2.add
    f64x2.sub
    local.get 1
    f64x2.neg
    local.get 2
    local.get 0
    f64x2.sub
    f64x2.sub
    f64x2.add
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect)
  (func (;12;) (type 3) (param v128 v128) (result v128)
    (local v128)
    local.get 0
    local.get 0
    local.get 1
    f64x2.sub
    local.tee 2
    local.get 1
    f64x2.add
    f64x2.sub
    local.get 1
    f64x2.neg
    local.get 2
    local.get 0
    f64x2.sub
    f64x2.sub
    f64x2.add
    local.set 0
    local.get 2
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    i64x2.add
    local.get 2
    local.get 0
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    local.get 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.and
    local.get 0
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    local.get 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.and
    v128.or
    v128.bitselect)
  (func (;13;) (type 3) (param v128 v128) (result v128)
    local.get 0
    local.get 1
    f64x2.mul)
  (func (;14;) (type 3) (param v128 v128) (result v128)
    (local v128 v128 v128 v128 v128 v128)
    local.get 0
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 2
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 3
    local.get 2
    local.get 3
    f64x2.sub
    f64x2.add
    local.tee 3
    local.get 1
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 4
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 5
    local.get 4
    local.get 5
    f64x2.sub
    f64x2.add
    local.tee 5
    f64x2.mul
    local.tee 6
    local.get 2
    local.get 3
    f64x2.sub
    local.tee 7
    local.get 5
    f64x2.mul
    local.get 3
    local.get 4
    local.get 5
    f64x2.sub
    local.tee 3
    f64x2.mul
    f64x2.add
    local.tee 4
    f64x2.add
    local.tee 5
    local.get 0
    local.get 1
    f64x2.mul
    local.tee 2
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    local.get 2
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 0
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 1
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    i64x2.add
    i64x2.sub
    v128.const i32x4 0x00000000 0x7fc00000 0x00000000 0x7fc00000
    i64x2.add
    v128.or
    f64x2.sub
    local.get 7
    local.get 3
    f64x2.mul
    local.get 4
    local.get 6
    local.get 5
    f64x2.sub
    f64x2.add
    f64x2.add
    f64x2.add
    local.set 1
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000
    local.get 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect
    local.get 2
    i64x2.add
    local.get 2
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    f64x2.eq
    local.tee 4
    v128.any_true
    if  ;; label = @1
      v128.const i32x4 0x00000000 0xbff00000 0x00000000 0xbff00000
      v128.const i32x4 0x00000000 0x3ff00000 0x00000000 0x3ff00000
      local.get 0
      v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
      f64x2.ne
      v128.bitselect
      local.get 1
      local.get 4
      v128.bitselect
      local.set 1
    end
    local.get 2
    local.get 1
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.bitselect)
  (func (;15;) (type 3) (param v128 v128) (result v128)
    (local v128 v128 v128 v128 v128 v128)
    local.get 0
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 2
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 3
    local.get 2
    local.get 3
    f64x2.sub
    f64x2.add
    local.tee 3
    local.get 1
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 5
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 4
    local.get 5
    local.get 4
    f64x2.sub
    f64x2.add
    local.tee 4
    f64x2.mul
    local.tee 6
    local.get 2
    local.get 3
    f64x2.sub
    local.tee 7
    local.get 4
    f64x2.mul
    local.get 3
    local.get 5
    local.get 4
    f64x2.sub
    local.tee 3
    f64x2.mul
    f64x2.add
    local.tee 5
    f64x2.add
    local.tee 4
    local.get 0
    local.get 1
    f64x2.mul
    local.tee 2
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    local.get 2
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 0
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 1
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    i64x2.add
    i64x2.sub
    v128.const i32x4 0x00000000 0x7fc00000 0x00000000 0x7fc00000
    i64x2.add
    v128.or
    f64x2.sub
    local.get 7
    local.get 3
    f64x2.mul
    local.get 5
    local.get 6
    local.get 4
    f64x2.sub
    f64x2.add
    f64x2.add
    f64x2.add
    local.set 0
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000
    local.get 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.bitselect
    local.get 2
    i64x2.add
    local.get 2
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    f64x2.eq
    local.tee 3
    v128.any_true
    if  ;; label = @1
      v128.const i32x4 0x00000000 0xbff00000 0x00000000 0xbff00000
      local.get 0
      local.get 3
      v128.bitselect
      local.set 0
    end
    local.get 2
    local.get 0
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect)
  (func (;16;) (type 3) (param v128 v128) (result v128)
    (local v128 v128 v128 v128 v128 v128)
    local.get 0
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 3
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 2
    local.get 3
    local.get 2
    f64x2.sub
    f64x2.add
    local.tee 2
    local.get 1
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 4
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 5
    local.get 4
    local.get 5
    f64x2.sub
    f64x2.add
    local.tee 5
    f64x2.mul
    local.tee 6
    local.get 3
    local.get 2
    f64x2.sub
    local.tee 7
    local.get 5
    f64x2.mul
    local.get 2
    local.get 4
    local.get 5
    f64x2.sub
    local.tee 2
    f64x2.mul
    f64x2.add
    local.tee 4
    f64x2.add
    local.tee 5
    local.get 0
    local.get 1
    f64x2.mul
    local.tee 3
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    local.get 3
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 0
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 1
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    i64x2.add
    i64x2.sub
    v128.const i32x4 0x00000000 0x7fc00000 0x00000000 0x7fc00000
    i64x2.add
    v128.or
    f64x2.sub
    local.get 7
    local.get 2
    f64x2.mul
    local.get 4
    local.get 6
    local.get 5
    f64x2.sub
    f64x2.add
    f64x2.add
    f64x2.add
    local.set 1
    local.get 3
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    i64x2.add
    local.get 3
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    f64x2.eq
    local.tee 4
    v128.any_true
    if  ;; label = @1
      v128.const i32x4 0x00000000 0xbff00000 0x00000000 0xbff00000
      v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
      local.get 0
      v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
      f64x2.ne
      v128.bitselect
      local.get 1
      local.get 4
      v128.bitselect
      local.set 1
    end
    local.get 3
    local.get 1
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.bitselect)
  (func (;17;) (type 3) (param v128 v128) (result v128)
    local.get 0
    local.get 1
    f64x2.div)
  (func (;18;) (type 3) (param v128 v128) (result v128)
    (local v128 v128 v128 v128 v128)
    local.get 1
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 3
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 2
    local.get 3
    local.get 2
    f64x2.sub
    f64x2.add
    local.tee 4
    local.get 0
    local.get 1
    f64x2.div
    local.tee 2
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    local.get 1
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 0
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    i64x2.sub
    local.get 2
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    i64x2.add
    v128.or
    local.tee 1
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 5
    local.get 1
    local.get 5
    f64x2.sub
    f64x2.add
    local.tee 5
    f64x2.mul
    local.tee 6
    local.get 3
    local.get 4
    f64x2.sub
    local.tee 3
    local.get 5
    f64x2.mul
    local.get 4
    local.get 1
    local.get 5
    f64x2.sub
    local.tee 1
    f64x2.mul
    f64x2.add
    local.tee 4
    f64x2.add
    local.tee 5
    local.get 0
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    f64x2.sub
    local.get 3
    local.get 1
    f64x2.mul
    local.get 4
    local.get 6
    local.get 5
    f64x2.sub
    f64x2.add
    f64x2.add
    f64x2.add
    local.set 1
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000
    local.get 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect
    local.get 2
    i64x2.add
    local.get 2
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    f64x2.eq
    local.tee 4
    v128.any_true
    if  ;; label = @1
      v128.const i32x4 0x00000000 0x3ff00000 0x00000000 0x3ff00000
      v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
      local.get 0
      v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
      f64x2.ne
      v128.bitselect
      local.get 1
      local.get 4
      v128.bitselect
      local.set 1
    end
    local.get 2
    local.get 1
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect)
  (func (;19;) (type 3) (param v128 v128) (result v128)
    (local v128 v128 v128 v128 v128)
    local.get 1
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 3
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 2
    local.get 3
    local.get 2
    f64x2.sub
    f64x2.add
    local.tee 5
    local.get 0
    local.get 1
    f64x2.div
    local.tee 2
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    local.get 1
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 0
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    i64x2.sub
    local.get 2
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    i64x2.add
    v128.or
    local.tee 1
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 4
    local.get 1
    local.get 4
    f64x2.sub
    f64x2.add
    local.tee 4
    f64x2.mul
    local.tee 6
    local.get 3
    local.get 5
    f64x2.sub
    local.tee 3
    local.get 4
    f64x2.mul
    local.get 5
    local.get 1
    local.get 4
    f64x2.sub
    local.tee 1
    f64x2.mul
    f64x2.add
    local.tee 5
    f64x2.add
    local.tee 4
    local.get 0
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    f64x2.sub
    local.get 3
    local.get 1
    f64x2.mul
    local.get 5
    local.get 6
    local.get 4
    f64x2.sub
    f64x2.add
    f64x2.add
    f64x2.add
    local.set 0
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000
    local.get 2
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.bitselect
    local.get 2
    i64x2.add
    local.get 2
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    f64x2.eq
    local.tee 3
    v128.any_true
    if  ;; label = @1
      v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
      local.get 0
      local.get 3
      v128.bitselect
      local.set 0
    end
    local.get 2
    local.get 0
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.bitselect)
  (func (;20;) (type 3) (param v128 v128) (result v128)
    (local v128 v128 v128 v128 v128)
    local.get 1
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 2
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 3
    local.get 2
    local.get 3
    f64x2.sub
    f64x2.add
    local.tee 4
    local.get 0
    local.get 1
    f64x2.div
    local.tee 3
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    local.get 1
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 0
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    i64x2.sub
    local.get 3
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    i64x2.add
    v128.or
    local.tee 1
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 5
    local.get 1
    local.get 5
    f64x2.sub
    f64x2.add
    local.tee 5
    f64x2.mul
    local.tee 6
    local.get 2
    local.get 4
    f64x2.sub
    local.tee 2
    local.get 5
    f64x2.mul
    local.get 4
    local.get 1
    local.get 5
    f64x2.sub
    local.tee 1
    f64x2.mul
    f64x2.add
    local.tee 4
    f64x2.add
    local.tee 5
    local.get 0
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    f64x2.sub
    local.get 2
    local.get 1
    f64x2.mul
    local.get 4
    local.get 6
    local.get 5
    f64x2.sub
    f64x2.add
    f64x2.add
    f64x2.add
    local.set 1
    local.get 3
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    i64x2.add
    local.get 3
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    f64x2.eq
    local.tee 4
    v128.any_true
    if  ;; label = @1
      v128.const i32x4 0x00000000 0x3ff00000 0x00000000 0x3ff00000
      v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
      local.get 0
      v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
      f64x2.ne
      v128.bitselect
      local.get 1
      local.get 4
      v128.bitselect
      local.set 1
    end
    local.get 3
    local.get 1
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect)
  (func (;21;) (type 4) (param v128) (result v128)
    local.get 0
    f64x2.sqrt)
  (func (;22;) (type 4) (param v128) (result v128)
    (local v128 v128 v128 v128 v128)
    local.get 0
    f64x2.sqrt
    local.tee 3
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 2
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 1
    local.get 2
    local.get 1
    f64x2.sub
    f64x2.add
    local.tee 1
    local.get 1
    f64x2.mul
    local.tee 4
    local.get 1
    local.get 2
    local.get 1
    f64x2.sub
    local.tee 1
    f64x2.mul
    local.tee 2
    local.get 2
    f64x2.add
    local.tee 2
    f64x2.add
    local.tee 5
    local.get 0
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    local.get 0
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 3
    i32.const 1
    i64x2.shl
    v128.const i32x4 0x00000000 0xffe00000 0x00000000 0xffe00000
    v128.and
    i64x2.sub
    v128.const i32x4 0x00000000 0x7fc00000 0x00000000 0x7fc00000
    i64x2.add
    v128.or
    f64x2.sub
    local.get 1
    local.get 1
    f64x2.mul
    local.get 2
    local.get 4
    local.get 5
    f64x2.sub
    f64x2.add
    f64x2.add
    f64x2.add
    local.set 0
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000
    local.get 3
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect
    local.get 3
    i64x2.add
    local.get 3
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    f64x2.eq
    local.tee 2
    v128.any_true
    if  ;; label = @1
      v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
      local.get 0
      local.get 2
      v128.bitselect
      local.set 0
    end
    local.get 3
    local.get 0
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect)
  (func (;23;) (type 4) (param v128) (result v128)
    (local v128 v128 v128 v128 v128)
    local.get 0
    f64x2.sqrt
    local.tee 3
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 2
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 1
    local.get 2
    local.get 1
    f64x2.sub
    f64x2.add
    local.tee 1
    local.get 1
    f64x2.mul
    local.tee 4
    local.get 1
    local.get 2
    local.get 1
    f64x2.sub
    local.tee 1
    f64x2.mul
    local.tee 2
    local.get 2
    f64x2.add
    local.tee 2
    f64x2.add
    local.tee 5
    local.get 0
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    local.get 0
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 3
    i32.const 1
    i64x2.shl
    v128.const i32x4 0x00000000 0xffe00000 0x00000000 0xffe00000
    v128.and
    i64x2.sub
    v128.const i32x4 0x00000000 0x7fc00000 0x00000000 0x7fc00000
    i64x2.add
    v128.or
    f64x2.sub
    local.get 1
    local.get 1
    f64x2.mul
    local.get 2
    local.get 4
    local.get 5
    f64x2.sub
    f64x2.add
    f64x2.add
    f64x2.add
    local.set 0
    local.get 3
    v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000
    i64x2.add
    local.get 3
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    f64x2.eq
    local.tee 2
    v128.any_true
    if  ;; label = @1
      v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
      local.get 0
      local.get 2
      v128.bitselect
      local.set 0
    end
    local.get 3
    local.get 0
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.lt
    v128.bitselect)
  (func (;24;) (type 4) (param v128) (result v128)
    (local v128 v128 v128 v128 v128)
    local.get 0
    f64x2.sqrt
    local.tee 3
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000
    v128.or
    local.tee 2
    v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000
    f64x2.mul
    local.tee 1
    local.get 2
    local.get 1
    f64x2.sub
    f64x2.add
    local.tee 1
    local.get 1
    f64x2.mul
    local.tee 4
    local.get 1
    local.get 2
    local.get 1
    f64x2.sub
    local.tee 1
    f64x2.mul
    local.tee 2
    local.get 2
    f64x2.add
    local.tee 2
    f64x2.add
    local.tee 5
    local.get 0
    v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff
    v128.and
    local.get 0
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    v128.and
    local.get 3
    i32.const 1
    i64x2.shl
    v128.const i32x4 0x00000000 0xffe00000 0x00000000 0xffe00000
    v128.and
    i64x2.sub
    v128.const i32x4 0x00000000 0x7fc00000 0x00000000 0x7fc00000
    i64x2.add
    v128.or
    f64x2.sub
    local.get 1
    local.get 1
    f64x2.mul
    local.get 2
    local.get 4
    local.get 5
    f64x2.sub
    f64x2.add
    f64x2.add
    f64x2.add
    local.set 0
    local.get 3
    v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff
    i64x2.add
    local.get 3
    v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000
    f64x2.eq
    local.tee 2
    v128.any_true
    if  ;; label = @1
      v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
      local.get 0
      local.get 2
      v128.bitselect
      local.set 0
    end
    local.get 3
    local.get 0
    v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000
    f64x2.gt
    v128.bitselect)
  (table $fadd_table 4 4 funcref)
  (table $fsub_table 4 4 funcref)
  (table $fmul_table 4 4 funcref)
  (table $fdiv_table 4 4 funcref)
  (table $fsqrt_table 4 4 funcref)
  (global $fprc (mut i32) (i32.const 0))
  (export "d" (func 2))
  (elem (;0;) (i32.const 0) func 5 6 7 8)
  (elem (;1;) (table $fsub_table) (i32.const 0) func 9 10 11 12)
  (elem (;2;) (table $fmul_table) (i32.const 0) func 13 14 15 16)
  (elem (;3;) (table $fdiv_table) (i32.const 0) func 17 18 19 20)
  (elem (;4;) (table $fsqrt_table) (i32.const 0) func 21 22 23 24))
