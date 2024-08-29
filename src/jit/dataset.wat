(module
	(func $ssh_example (param $r0 i64) (param $r1 i64) (param $r2 i64) (param $r3 i64) (param $r4 i64) (param $r5 i64) (param $r6 i64) (param $r7 i64)
		(result i64 i64 i64 i64 i64 i64 i64 i64)

		local.get $r0
		local.get $r1
		local.get $r2
		local.get $r3
		local.get $r4
		local.get $r5
		local.get $r6
		local.get $r7
	)

	(;static inline uint8_t* getMixBlock(uint64_t registerValue, uint8_t *memory) {
		constexpr uint32_t mask = CacheSize / CacheLineSize - 1;
		return memory + (registerValue & mask) * CacheLineSize;
	};)

	;; RANDOMX_ARGON_MEMORY * ArgonBlockSize
	;; ArgonBlockSize = 1024
	;; RANDOMX_ARGON_MEMORY = 262144
	;; RANDOMX_DATASET_ITEM_SIZE = 64

	;; CacheSize = RANDOMX_ARGON_MEMORY * ArgonBlockSize
	;; CacheLineSize = RANDOMX_DATASET_ITEM_SIZE
	(func $get_mix_block (param $register_value i64) (param $memory_ptr i32) (result i32)
		(local $mask i32)
		(local $block_offset i32)

		i32.const 0x3F
		i32.const 0x40
		i32.and
		i32.const 0x40
		i32.mul
		i32.const 0
		i32.add
	)

	(func (export "D") (param $cache_ptr i32) (param $item_number i64) (result i64 i64 i64 i64 i64 i64 i64 i64)
		(local $r0 i64) (local $r1 i64) (local $r2 i64) (local $r3 i64) (local $r4 i64) (local $r5 i64) (local $r6 i64) (local $r7 i64)

		;; r0 = (itemNumber + 1) * 6364136223846793005;
		;; r1 = r0 ^ 9298411001130361340;
		;; r2 = r0 ^ 12065312585734608966;
		;; r3 = r0 ^ 9306329213124626780;
		;; r4 = r0 ^ 5281919268842080866;
		;; r5 = r0 ^ 10536153434571861004;
		;; r6 = r0 ^ 3398623926847679864;
		;; r7 = r0 ^ 9549104520008361294;
		(local.set $r0 (i64.mul (i64.add (local.get $item_number) (i64.const 1)) (i64.const 6364136223846793005)))
		(local.set $r1 (i64.xor (local.get $r0) (i64.const 9298411001130361340)))
		(local.set $r2 (i64.xor (local.get $r0) (i64.const 12065312585734608966)))
		(local.set $r3 (i64.xor (local.get $r0) (i64.const 9306329213124626780)))
		(local.set $r4 (i64.xor (local.get $r0) (i64.const 5281919268842080866)))
		(local.set $r5 (i64.xor (local.get $r0) (i64.const 10536153434571861004)))
		(local.set $r6 (i64.xor (local.get $r0) (i64.const 3398623926847679864)))
		(local.set $r7 (i64.xor (local.get $r0) (i64.const 9549104520008361294)))

		;; execute superscalar hash functions up till RANDOMX_CACHE_ACCESSES


		
		i64.const 0
		i64.const 0
		i64.const 0
		i64.const 0
		i64.const 0
		i64.const 0
		i64.const 0
		i64.const 0
	)
)