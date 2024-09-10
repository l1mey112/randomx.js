(module
	(memory 0)

	(func (export "a")
		global.get $P_value
		drop
	)

	(global $P_value i32 (i32.const 0))
)
