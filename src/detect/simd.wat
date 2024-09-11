(module
  (memory 1)
  (func (result v128)
    i32.const 0
    i8x16.splat
    i8x16.popcnt
  )
  (func
    i32.const 0
    i32.const 0
    i32.const 0
    memory.copy
  )
  (func (result i32 i32)
    i32.const 0
    i32.const 0
  )
)