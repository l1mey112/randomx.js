(module
 (type $0 (func (param v128 v128) (result v128)))
 (type $1 (func (param v128) (result v128)))
 (type $2 (func (param f64 f64) (result f64)))
 (export "fmul_1" (func $1))
 (export "fmul_fma_1" (func $2))
 (func $1 (type $2) (param $0 f64) (param $1 f64) (result f64)
  local.get 0
  f64x2.splat
  local.get 1
  f64x2.splat
  call $3
  f64x2.extract_lane 0
 )
 (func $2 (type $2) (param $0 f64) (param $1 f64) (result f64)
  local.get 0
  f64x2.splat
  local.get 1
  f64x2.splat
  call $4
  f64x2.extract_lane 0
 )
 (func $3 (type $0) (param $0 v128) (param $1 v128) (result v128)
  (local $2 v128)
  (local $3 v128)
  (local $4 v128)
  (local $5 v128)
  (local $6 v128)
  (local $7 v128)
  (local $scratch v128)
  (local.set $1
   (f64x2.add
    (f64x2.sub
     (local.tee $5
      (f64x2.add
       (local.tee $6
        (f64x2.mul
         (local.tee $3
          (f64x2.add
           (local.tee $3
            (f64x2.mul
             (local.tee $2
              (v128.or
               (v128.and
                (local.get $0)
                (v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff)
               )
               (v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000)
              )
             )
             (v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000)
            )
           )
           (f64x2.sub
            (local.get $2)
            (local.get $3)
           )
          )
         )
         (local.tee $5
          (f64x2.add
           (local.tee $5
            (f64x2.mul
             (local.tee $4
              (v128.or
               (v128.and
                (local.get $1)
                (v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff)
               )
               (v128.const i32x4 0x00000000 0x3fe00000 0x00000000 0x3fe00000)
              )
             )
             (v128.const i32x4 0x02000000 0x41a00000 0x02000000 0x41a00000)
            )
           )
           (f64x2.sub
            (local.get $4)
            (local.get $5)
           )
          )
         )
        )
       )
       (local.tee $4
        (f64x2.add
         (f64x2.mul
          (local.tee $7
           (f64x2.sub
            (local.get $2)
            (local.get $3)
           )
          )
          (local.get $5)
         )
         (f64x2.mul
          (local.get $3)
          (local.tee $3
           (f64x2.sub
            (local.get $4)
            (local.get $5)
           )
          )
         )
        )
       )
      )
     )
     (v128.or
      (v128.and
       (local.tee $2
        (f64x2.mul
         (local.get $0)
         (local.get $1)
        )
       )
       (v128.const i32x4 0xffffffff 0x800fffff 0xffffffff 0x800fffff)
      )
      (i64x2.add
       (i64x2.sub
        (v128.and
         (local.get $2)
         (v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000)
        )
        (i64x2.add
         (v128.and
          (local.get $0)
          (v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000)
         )
         (v128.and
          (local.get $1)
          (v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000)
         )
        )
       )
       (v128.const i32x4 0x00000000 0x7fc00000 0x00000000 0x7fc00000)
      )
     )
    )
    (f64x2.add
     (f64x2.mul
      (local.get $7)
      (local.get $3)
     )
     (f64x2.add
      (local.get $4)
      (f64x2.sub
       (local.get $6)
       (local.get $5)
      )
     )
    )
   )
  )
  (v128.bitselect
   (block (result v128)
    (local.set $scratch
     (i64x2.add
      (v128.or
       (f64x2.gt
        (local.get $2)
        (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
       )
       (v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000)
      )
      (local.get $2)
     )
    )
    (if
     (v128.any_true
      (local.tee $4
       (f64x2.eq
        (local.get $2)
        (v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000)
       )
      )
     )
     (then
      (local.set $1
       (v128.bitselect
        (v128.bitselect
         (v128.const i32x4 0x00000000 0xbff00000 0x00000000 0xbff00000)
         (v128.const i32x4 0x00000000 0x3ff00000 0x00000000 0x3ff00000)
         (f64x2.ne
          (local.get $0)
          (v128.const i32x4 0x00000000 0x7ff00000 0x00000000 0x7ff00000)
         )
        )
        (local.get $1)
        (local.get $4)
       )
      )
     )
    )
    (local.get $scratch)
   )
   (local.get $2)
   (f64x2.lt
    (local.get $1)
    (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
   )
  )
 )
 (func $4 (type $0) (param $0 v128) (param $1 v128) (result v128)
  (local $2 v128)
  (v128.bitselect
   (i64x2.add
    (v128.or
     (f64x2.gt
      (local.tee $2
       (f64x2.mul
        (local.get $0)
        (local.get $1)
       )
      )
      (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
     )
     (v128.const i32x4 0x00000001 0x00000000 0x00000001 0x00000000)
    )
    (local.get $2)
   )
   (local.get $2)
   (f64x2.lt
    (f64x2.relaxed_madd
     (f64x2.neg
      (local.get $2)
     )
     (local.get $1)
     (local.get $0)
    )
    (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
   )
  )
 )
 ;; custom section "producers", size 28
 ;; features section: threads, mutable-globals, nontrapping-float-to-int, simd, bulk-memory, sign-ext, exception-handling, tail-call, reference-types, multivalue, gc, memory64, relaxed-simd, extended-const, strings, multimemory, stack-switching, shared-everything, fp16, bulk-memory-opt, call-indirect-overlong, custom-descriptors
)

