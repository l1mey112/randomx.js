(module
  (memory 1)
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
)