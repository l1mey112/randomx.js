(module
  (func (export "d") (result i32)
    v128.const f64x2 0x1.0000000000001p+0 0.0
    v128.const f64x2 0x1.ffffffffffffep-1 0.0
    v128.const f64x2 -1.0 0.0
    f64x2.relaxed_madd
    f64x2.extract_lane 0
    f64.const -0x1.0p-104
    f64.eq
  )
)