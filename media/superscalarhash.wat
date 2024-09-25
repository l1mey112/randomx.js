(module
  (type (;0;) (func (param i64) (result i64 i64 i64 i64 i64 i64 i64 i64)))
  (type (;1;) (func (param i64 i64) (result i64)))
  (import "e" "m" (memory (;0;) 4098 4098))
  (func (;0;) (type 0) (param $item_number i64) (result i64 i64 i64 i64 i64 i64 i64 i64)
    (local $mixblock_ptr i32) (local $r0 i64) (local $r1 i64) (local $r2 i64) (local $r3 i64) (local $r4 i64) (local $r5 i64) (local $r6 i64) (local $r7 i64)
    local.get $item_number
    i64.const 1
    i64.add
    i64.const 6364136223846793005
    i64.mul
    local.set $r0
    local.get $r0
    i64.const -9148333072579190276
    i64.xor
    local.set $r1
    local.get $r0
    i64.const -6381431487974942650
    i64.xor
    local.set $r2
    local.get $r0
    i64.const -9140414860584924836
    i64.xor
    local.set $r3
    local.get $r0
    i64.const 5281919268842080866
    i64.xor
    local.set $r4
    local.get $r0
    i64.const -7910590639137690612
    i64.xor
    local.set $r5
    local.get $r0
    i64.const 3398623926847679864
    i64.xor
    local.set $r6
    local.get $r0
    i64.const -8897639553701190322
    i64.xor
    local.set $r7
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r6
    local.get $r7
    local.get $r1
    i64.xor
    local.set $r7
    local.get $r0
    i64.const -1727223807
    i64.xor
    local.set $r0
    local.get $r7
    local.get $r6
    i64.sub
    local.set $r7
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r6
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r6
    local.get $r7
    i64.const 613725029
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r0
    i64.sub
    local.set $r1
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r3
    local.get $r1
    i64.mul
    local.set $r3
    local.get $r0
    i64.const 21
    i64.rotr
    local.set $r0
    local.get $r5
    i64.const 28
    i64.rotr
    local.set $r5
    local.get $r5
    i64.const -855352382
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r0
    i64.xor
    local.set $r2
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r1
    i64.const -1498130121
    i64.add
    local.set $r1
    local.get $r0
    local.get $r4
    i64.sub
    local.set $r0
    local.get $r4
    local.get $r1
    call 2
    local.set $r4
    local.get $r5
    i64.const -8928179204380867569
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r0
    i64.const 38
    i64.rotr
    local.set $r0
    local.get $r6
    local.get $r3
    i64.sub
    local.set $r6
    local.get $r0
    i64.const 1572212233
    i64.add
    local.set $r0
    local.get $r0
    local.get $r3
    i64.xor
    local.set $r0
    local.get $r7
    local.get $r6
    i64.sub
    local.set $r7
    local.get $r7
    local.get $r0
    i64.xor
    local.set $r7
    local.get $r6
    i64.const -270343784
    i64.add
    local.set $r6
    local.get $r3
    local.get $r2
    i64.sub
    local.set $r3
    local.get $r2
    local.get $r6
    call 2
    local.set $r2
    local.get $r4
    i64.const -6337005281831496108
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r1
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r1
    i64.const 39
    i64.rotr
    local.set $r1
    local.get $r3
    i64.const 1832558914
    i64.xor
    local.set $r3
    local.get $r7
    local.get $r1
    i64.xor
    local.set $r7
    local.get $r6
    local.get $r1
    i64.xor
    local.set $r6
    local.get $r3
    i64.const -1200918527
    i64.add
    local.set $r3
    local.get $r2
    local.get $r3
    i64.xor
    local.set $r2
    local.get $r3
    local.get $r1
    i64.sub
    local.set $r3
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r5
    i64.const 9
    i64.rotr
    local.set $r5
    local.get $r2
    local.get $r1
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r7
    i64.const 2141649607
    i64.xor
    local.set $r7
    local.get $r5
    local.get $r1
    i64.xor
    local.set $r5
    local.get $r7
    i64.const 59
    i64.rotr
    local.set $r7
    local.get $r2
    i64.const 1066955149
    i64.xor
    local.set $r2
    local.get $r6
    i64.const 54
    i64.rotr
    local.set $r6
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r0
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    local.get $r0
    i64.sub
    local.set $r4
    local.get $r0
    i64.const -205281841
    i64.xor
    local.set $r0
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r3
    i64.const -1511752549
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r4
    i64.sub
    local.set $r6
    local.get $r0
    local.get $r3
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r2
    call 1
    local.set $r2
    local.get $r6
    i64.const -8733144686038219501
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r1
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r5
    i64.const 45
    i64.rotr
    local.set $r5
    local.get $r7
    i64.const -212954843
    i64.add
    local.set $r7
    local.get $r1
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r7
    local.get $r1
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r5
    i64.const -248905971
    i64.add
    local.set $r5
    local.get $r7
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r7
    local.get $r6
    local.get $r2
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r0
    local.get $r1
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r0
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r3
    i64.const -825076446
    i64.add
    local.set $r3
    local.get $r1
    local.get $r7
    call 1
    local.set $r1
    local.get $r3
    i64.const -7247593199669051955
    i64.mul
    local.set $r3
    local.get $r7
    i64.const 1928990550
    i64.xor
    local.set $r7
    local.get $r7
    local.get $r2
    call 1
    local.set $r7
    local.get $r6
    i64.const -8452340225206973474
    i64.mul
    local.set $r6
    local.get $r4
    i64.const 1014642548
    i64.add
    local.set $r4
    local.get $r0
    local.get $r2
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r2
    local.get $r4
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    i64.const -912912112
    i64.xor
    local.set $r4
    local.get $r0
    local.get $r3
    call 2
    local.set $r0
    local.get $r1
    i64.const -4129307492536435388
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r5
    i64.const -1400490847
    i64.xor
    local.set $r5
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r3
    i64.sub
    local.set $r2
    local.get $r3
    local.get $r5
    call 2
    local.set $r3
    local.get $r5
    i64.const -1582046487840647466
    i64.mul
    local.set $r5
    local.get $r6
    i64.const 1088202589
    i64.xor
    local.set $r6
    local.get $r6
    local.get $r2
    i64.sub
    local.set $r6
    local.get $r2
    i64.const 65484351
    i64.xor
    local.set $r2
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r2
    local.get $r6
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r4
    call 2
    local.set $r6
    local.get $r7
    i64.const -6159270986181181285
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r0
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r2
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r0
    local.get $r2
    i64.sub
    local.set $r0
    local.get $r4
    i64.const 692683731
    i64.add
    local.set $r4
    local.get $r2
    local.get $r4
    i64.xor
    local.set $r2
    local.get $r0
    local.get $r5
    call 2
    local.set $r0
    local.get $r6
    i64.const -2017841908839652795
    i64.mul
    local.set $r6
    local.get $r7
    i64.const -592294078
    i64.add
    local.set $r7
    local.get $r5
    local.get $r4
    call 2
    local.set $r5
    local.get $r4
    i64.const -9157620598439769940
    i64.mul
    local.set $r4
    local.get $r1
    i64.const -1021214330
    i64.xor
    local.set $r1
    local.get $r2
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r7
    i64.const 1053366752
    i64.xor
    local.set $r7
    local.get $r6
    local.get $r1
    i64.sub
    local.set $r6
    local.get $r0
    local.get $r2
    i64.sub
    local.set $r0
    local.get $r3
    local.get $r7
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r5
    local.get $r4
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r6
    local.get $r3
    i64.const -1801065429
    i64.add
    local.set $r3
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $r7
    local.get $r0
    call 2
    local.set $r7
    local.get $r4
    i64.const -7815502888311960343
    i64.mul
    local.set $r4
    local.get $r6
    i64.const 1751254659
    i64.add
    local.set $r6
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r5
    i64.const -1295097494
    i64.add
    local.set $r5
    local.get $r0
    local.get $r1
    i64.xor
    local.set $r0
    local.get $r3
    local.get $r2
    i64.sub
    local.set $r3
    local.get $r5
    local.get $r2
    i64.sub
    local.set $r5
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r2
    i64.const 1
    i64.shl
    i64.add
    local.set $r1
    local.get $r5
    i64.const 715077157
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r5
    i64.sub
    local.set $r2
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r0
    local.get $r6
    call 2
    local.set $r0
    local.get $r2
    i64.const -2976641497852441049
    i64.mul
    local.set $r2
    local.get $r4
    i64.const 1901097307
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r7
    call 2
    local.set $r1
    local.get $r5
    i64.const -6714883713440783522
    i64.mul
    local.set $r5
    local.get $r3
    i64.const -1741398127
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r3
    call 2
    local.set $r6
    local.get $r7
    i64.const -6762878154376964052
    i64.mul
    local.set $r7
    local.get $r2
    i64.const 1256492771
    i64.xor
    local.set $r2
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r2
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r0
    i64.const -207489043
    i64.add
    local.set $r0
    local.get $r5
    i64.const 43
    i64.rotr
    local.set $r5
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r0
    i64.const 48
    i64.rotr
    local.set $r0
    local.get $r3
    i64.const -302311356
    i64.add
    local.set $r3
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r5
    local.get $r6
    i64.xor
    local.set $r5
    local.get $r2
    i64.const 44
    i64.rotr
    local.set $r2
    local.get $r6
    i64.const 1680712180
    i64.xor
    local.set $r6
    local.get $r1
    i64.const 17
    i64.rotr
    local.set $r1
    local.get $r0
    local.get $r7
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r5
    i64.const 34
    i64.rotr
    local.set $r5
    local.get $r6
    i64.const 8
    i64.rotr
    local.set $r6
    local.get $r5
    i64.const 1472135768
    i64.xor
    local.set $r5
    local.get $r0
    i64.const 2
    i64.rotr
    local.set $r0
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r7
    i64.const 175989390
    i64.add
    local.set $r7
    local.get $r4
    local.get $r5
    i64.sub
    local.set $r4
    local.get $r2
    local.get $r7
    call 2
    local.set $r2
    local.get $r0
    i64.const -4376312270670468614
    i64.mul
    local.set $r0
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r1
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r3
    local.get $r7
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r3
    i64.const -1848395392
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r5
    i64.const 3
    i64.shl
    i64.add
    local.set $r1
    local.get $r3
    local.get $r7
    i64.sub
    local.set $r3
    local.get $r3
    i64.const 1777671806
    i64.add
    local.set $r3
    local.get $r1
    local.get $r7
    i64.xor
    local.set $r1
    local.get $r6
    local.get $r7
    i64.sub
    local.set $r6
    local.get $r3
    local.get $r0
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r1
    i64.const 50
    i64.rotr
    local.set $r1
    local.get $r2
    local.get $r0
    i64.xor
    local.set $r2
    local.get $r1
    i64.const 448774551
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r2
    local.get $r4
    i64.xor
    local.set $r2
    local.get $r1
    local.get $r0
    i64.sub
    local.set $r1
    local.get $r3
    i64.const 281936439
    i64.add
    local.set $r3
    local.get $r4
    local.get $r7
    i64.xor
    local.set $r4
    local.get $r0
    local.get $r1
    call 2
    local.set $r0
    local.get $r5
    i64.const -8284495898422414259
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r2
    local.get $r4
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r6
    i64.const -752083670
    i64.xor
    local.set $r6
    local.get $r6
    i64.const 24
    i64.rotr
    local.set $r6
    local.get $r7
    i64.const 15
    i64.rotr
    local.set $r7
    local.get $r6
    i64.const -2004406048
    i64.add
    local.set $r6
    local.get $r2
    local.get $r4
    i64.xor
    local.set $r2
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r4
    i64.const 24
    i64.rotr
    local.set $r4
    local.get $r6
    local.get $r7
    i64.const 1
    i64.shl
    i64.add
    local.set $r6
    local.get $r1
    i64.const 1024757327
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r7
    call 2
    local.set $r7
    local.get $r6
    i64.const -9023959673121113140
    i64.mul
    local.set $r6
    local.get $r4
    i64.const 1917780806
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r3
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r3
    i64.const 842751942
    i64.add
    local.set $r3
    local.get $r1
    local.get $r5
    i64.sub
    local.set $r1
    local.get $r4
    local.get $r1
    call 1
    local.set $r4
    local.get $r0
    i64.const -4353861184139285291
    i64.mul
    local.set $r0
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r1
    i64.const 8
    i64.rotr
    local.set $r1
    local.get $r2
    i64.const -1510170190
    i64.add
    local.set $r2
    local.get $r1
    local.get $r7
    i64.sub
    local.set $r1
    local.get $r7
    local.get $r2
    i64.sub
    local.set $r7
    local.get $r1
    local.get $r3
    i64.sub
    local.set $r1
    local.get $r7
    i64.const 21
    i64.rotr
    local.set $r7
    local.get $r1
    i64.const -439907989
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r4
    i64.const 50
    i64.rotr
    local.set $r4
    local.get $r5
    local.get $r1
    i64.sub
    local.set $r5
    local.get $r5
    i64.const 2097843481
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r1
    i64.sub
    local.set $r4
    local.get $r4
    local.get $r3
    i64.sub
    local.set $r4
    local.get $r0
    i64.const 6
    i64.rotr
    local.set $r0
    local.get $r6
    i64.const 1974436941
    i64.add
    local.set $r6
    local.get $r1
    local.get $r5
    call 1
    local.set $r1
    local.get $r6
    i64.const -8968559201216604900
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r3
    i64.const 61
    i64.rotr
    local.set $r3
    local.get $r3
    i64.const 393003836
    i64.add
    local.set $r3
    local.get $r7
    local.get $r5
    i64.xor
    local.set $r7
    local.get $r7
    local.get $r3
    i64.xor
    local.set $r7
    local.get $r3
    i64.const -1999892539
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r2
    i64.sub
    local.set $r1
    local.get $r2
    local.get $r6
    i64.sub
    local.set $r2
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r3
    local.get $r7
    i64.mul
    local.set $r3
    local.get $r7
    i64.const 26
    i64.rotr
    local.set $r7
    local.get $r6
    local.get $r2
    i64.xor
    local.set $r6
    local.get $r7
    i64.const -347062493
    i64.add
    local.set $r7
    local.get $r4
    local.get $r2
    i64.xor
    local.set $r4
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r0
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r4
    i64.const 1044204624
    i64.xor
    local.set $r4
    local.get $r4
    local.get $r5
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r1
    local.get $r5
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r2
    i64.const 10
    i64.rotr
    local.set $r2
    local.get $r3
    i64.const 568256833
    i64.xor
    local.set $r3
    local.get $r3
    i64.const 60
    i64.rotr
    local.set $r3
    local.get $r2
    local.get $r1
    i64.sub
    local.set $r2
    local.get $r1
    i64.const 665947832
    i64.add
    local.set $r1
    local.get $r2
    local.get $r7
    i64.sub
    local.set $r2
    local.get $r6
    local.get $r5
    i64.sub
    local.set $r6
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r6
    local.get $r1
    i64.const 2
    i64.rotr
    local.set $r1
    local.get $r4
    i64.const 1006146340
    i64.xor
    local.set $r4
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $r6
    i64.const -1249839799
    i64.add
    local.set $r6
    local.get $r4
    local.get $r0
    i64.sub
    local.set $r4
    local.get $r7
    local.get $r3
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r6
    call 2
    local.set $r1
    local.get $r6
    i64.const -2308805969422388341
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r5
    i64.const 18
    i64.rotr
    local.set $r5
    local.get $r5
    i64.const 1787626130
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r3
    i64.sub
    local.set $r2
    local.get $r0
    local.get $r3
    i64.sub
    local.set $r0
    local.get $r7
    local.get $r2
    i64.xor
    local.set $r7
    local.get $r3
    local.get $r0
    i64.sub
    local.set $r3
    local.get $r7
    i64.const 237767502
    i64.xor
    local.set $r7
    local.get $r5
    local.get $r0
    i64.sub
    local.set $r5
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r3
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r1
    local.get $r3
    i64.sub
    local.set $r1
    local.get $r0
    i64.const 1744595986
    i64.xor
    local.set $r0
    local.get $r0
    local.get $r3
    i64.sub
    local.set $r0
    local.get $r5
    local.get $r4
    call 1
    local.set $r5
    local.get $r4
    i64.const -8505691773756442251
    i64.mul
    local.set $r4
    local.get $r0
    i64.const 1482282202
    i64.add
    local.set $r0
    local.get $r0
    i64.const 48
    i64.rotr
    local.set $r0
    local.get $r7
    i64.const 10
    i64.rotr
    local.set $r7
    local.get $r3
    i64.const -1547378655
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r0
    i64.const 3
    i64.shl
    i64.add
    local.set $r6
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r3
    local.get $r7
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r5
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r6
    local.get $r7
    i64.xor
    local.set $r6
    local.get $r4
    i64.const -920840910
    i64.add
    local.set $r4
    local.get $r2
    local.get $r6
    i64.sub
    local.set $r2
    local.get $r7
    local.get $r6
    i64.sub
    local.set $r7
    local.get $r6
    local.get $r1
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r1
    i64.const -2043632781
    i64.add
    local.set $r1
    local.get $r6
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r6
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r4
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r4
    i64.const 20
    i64.rotr
    local.set $r4
    local.get $r6
    local.get $r2
    i64.xor
    local.set $r6
    local.get $r2
    i64.const -46829532
    i64.add
    local.set $r2
    local.get $r6
    local.get $r3
    i64.sub
    local.set $r6
    local.get $r3
    local.get $r0
    call 1
    local.set $r3
    local.get $r4
    i64.const -5474229532635113279
    i64.mul
    local.set $r4
    local.get $r5
    i64.const 604508449
    i64.xor
    local.set $r5
    local.get $r0
    i64.const 2
    i64.rotr
    local.set $r0
    local.get $r5
    local.get $r1
    i64.xor
    local.set $r5
    local.get $r1
    i64.const 1628384914
    i64.add
    local.set $r1
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r1
    call 1
    local.set $r2
    local.get $r3
    i64.const -8999233759273555278
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r7
    local.get $r1
    i64.xor
    local.set $r7
    local.get $r0
    i64.const 1681997052
    i64.add
    local.set $r0
    local.get $r7
    local.get $r5
    i64.sub
    local.set $r7
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r1
    local.get $r0
    i64.const 3
    i64.shl
    i64.add
    local.set $r1
    local.get $r5
    i64.const 2105807827
    i64.add
    local.set $r5
    local.get $r7
    local.get $r2
    i64.xor
    local.set $r7
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r2
    i64.const 12
    i64.rotr
    local.set $r2
    local.get $r4
    i64.const 33
    i64.rotr
    local.set $r4
    local.get $r7
    i64.const 2031140915
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r7
    i64.xor
    local.set $r1
    local.get $r6
    local.get $r4
    i64.xor
    local.set $r6
    local.get $r6
    i64.const -1122877741
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r2
    i64.sub
    local.set $r0
    local.get $r7
    local.get $r1
    i64.xor
    local.set $r7
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r0
    i64.mul
    local.set $r7
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r5
    i64.const 48
    i64.rotr
    local.set $r5
    local.get $r1
    i64.const 2039588084
    i64.add
    local.set $r1
    local.get $r1
    local.get $r2
    i64.sub
    local.set $r1
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r1
    call 2
    local.set $r4
    local.get $r6
    i64.const -5030823884664658677
    i64.mul
    local.set $r6
    local.get $r1
    i64.const 868411330
    i64.xor
    local.set $r1
    local.get $r2
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r2
    local.get $r7
    i64.xor
    local.set $r2
    local.get $r5
    i64.const -192856059
    i64.add
    local.set $r5
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r3
    i64.mul
    local.set $r5
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r1
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r3
    i64.const 23
    i64.rotr
    local.set $r3
    local.get $r6
    i64.const -500161607
    i64.add
    local.set $r6
    local.get $r7
    local.get $r6
    call 2
    local.set $r7
    local.get $r4
    i64.const -5154409100722213030
    i64.mul
    local.set $r4
    local.get $r1
    i64.const -904772632
    i64.xor
    local.set $r1
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r5
    i64.const 61
    i64.rotr
    local.set $r5
    local.get $r5
    i64.const -595200863
    i64.add
    local.set $r5
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r5
    i64.const 18
    i64.rotr
    local.set $r5
    local.get $r1
    i64.const 56
    i64.rotr
    local.set $r1
    local.get $r1
    i64.const 1617538127
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r1
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r7
    i64.const 763175888
    i64.xor
    local.set $r7
    local.get $r2
    local.get $r3
    call 1
    local.set $r2
    local.get $r6
    i64.const -5715632316492451114
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r0
    i64.const 21
    i64.rotr
    local.set $r0
    local.get $r3
    i64.const 1368026917
    i64.add
    local.set $r3
    local.get $r4
    local.get $r5
    i64.sub
    local.set $r4
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r3
    call 1
    local.set $r5
    local.get $r3
    i64.const -8269363921664575220
    i64.mul
    local.set $r3
    local.get $r0
    i64.const -1739442820
    i64.xor
    local.set $r0
    local.get $r4
    i64.const 16
    i64.rotr
    local.set $r4
    local.get $r0
    i64.const 20
    i64.rotr
    local.set $r0
    local.get $r2
    i64.const 770970792
    i64.xor
    local.set $r2
    local.get $r4
    local.get $r0
    call 1
    local.set $r4
    local.get $r0
    i64.const -3286755433348024769
    i64.mul
    local.set $r0
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r2
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r2
    i64.const -1329799228
    i64.add
    local.set $r2
    local.get $r7
    local.get $r1
    i64.xor
    local.set $r7
    local.get $r2
    local.get $r7
    i64.sub
    local.set $r2
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r2
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r7
    i64.const 1244751153
    i64.xor
    local.set $r7
    local.get $r2
    local.get $r0
    i64.sub
    local.set $r2
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r6
    i64.const 1239631009
    i64.add
    local.set $r6
    local.get $r5
    local.get $r1
    i64.sub
    local.set $r5
    local.get $r7
    local.get $r3
    i64.sub
    local.set $r7
    local.get $r1
    local.get $r5
    i64.sub
    local.set $r1
    local.get $r4
    i64.const 840394558
    i64.add
    local.set $r4
    local.get $r1
    local.get $r7
    i64.xor
    local.set $r1
    local.get $r3
    local.get $r7
    i64.sub
    local.set $r3
    local.get $r4
    local.get $r1
    i64.sub
    local.set $r4
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $item_number
    i64.const 4194303
    i64.and
    i32.wrap_i64
    i32.const 6
    i32.shl
    i32.const 51872
    i32.add
    local.set $mixblock_ptr
    local.get $mixblock_ptr
    i64.load align=4
    local.get $r0
    i64.xor
    local.set $r0
    local.get $mixblock_ptr
    i64.load offset=8 align=4
    local.get $r1
    i64.xor
    local.set $r1
    local.get $mixblock_ptr
    i64.load offset=16 align=4
    local.get $r2
    i64.xor
    local.set $r2
    local.get $mixblock_ptr
    i64.load offset=24 align=4
    local.get $r3
    i64.xor
    local.set $r3
    local.get $mixblock_ptr
    i64.load offset=32 align=4
    local.get $r4
    i64.xor
    local.set $r4
    local.get $mixblock_ptr
    i64.load offset=40 align=4
    local.get $r5
    i64.xor
    local.set $r5
    local.get $mixblock_ptr
    i64.load offset=48 align=4
    local.get $r6
    i64.xor
    local.set $r6
    local.get $mixblock_ptr
    i64.load offset=56 align=4
    local.get $r7
    i64.xor
    local.set $r7
    local.get $r3
    local.set $item_number
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r7
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r6
    local.get $r2
    i64.const 1
    i64.shl
    i64.add
    local.set $r6
    local.get $r7
    i64.const -90196735
    i64.xor
    local.set $r7
    local.get $r2
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r5
    i64.const 54
    i64.rotr
    local.set $r5
    local.get $r5
    i64.const 40861446
    i64.add
    local.set $r5
    local.get $r2
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r6
    local.get $r2
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r1
    i64.const 2
    i64.rotr
    local.set $r1
    local.get $r0
    i64.const 62
    i64.rotr
    local.set $r0
    local.get $r4
    i64.const 1599141340
    i64.xor
    local.set $r4
    local.get $r3
    i64.const 4
    i64.rotr
    local.set $r3
    local.get $r1
    local.get $r3
    i64.sub
    local.set $r1
    local.get $r7
    i64.const 1991070564
    i64.add
    local.set $r7
    local.get $r3
    local.get $r0
    i64.sub
    local.set $r3
    local.get $r4
    local.get $r0
    i64.xor
    local.set $r4
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r6
    i64.const 8
    i64.rotr
    local.set $r6
    local.get $r2
    local.get $r4
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r0
    i64.const 1076807718
    i64.add
    local.set $r0
    local.get $r3
    local.get $r3
    call 2
    local.set $r3
    local.get $r5
    i64.const -5512068199287365854
    i64.mul
    local.set $r5
    local.get $r4
    i64.const 1583123747
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r0
    call 2
    local.set $r6
    local.get $r0
    i64.const -6405896925158963082
    i64.mul
    local.set $r0
    local.get $r2
    i64.const 239289635
    i64.add
    local.set $r2
    local.get $r4
    i64.const 8
    i64.rotr
    local.set $r4
    local.get $r4
    i64.const -786288916
    i64.add
    local.set $r4
    local.get $r7
    local.get $r1
    i64.xor
    local.set $r7
    local.get $r2
    local.get $r1
    i64.xor
    local.set $r2
    local.get $r1
    local.get $r5
    call 2
    local.set $r1
    local.get $r4
    i64.const -32657063905621652
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r3
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r3
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r3
    i64.const 1
    i64.rotr
    local.set $r3
    local.get $r3
    i64.const -1058827939
    i64.add
    local.set $r3
    local.get $r6
    local.get $r6
    call 1
    local.set $r6
    local.get $r7
    i64.const -7059386553816772599
    i64.mul
    local.set $r7
    local.get $r0
    i64.const -146360577
    i64.add
    local.set $r0
    local.get $r3
    i64.const 16
    i64.rotr
    local.set $r3
    local.get $r4
    local.get $r0
    i64.xor
    local.set $r4
    local.get $r1
    i64.const -2049094906
    i64.add
    local.set $r1
    local.get $r3
    local.get $r2
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r2
    call 1
    local.set $r0
    local.get $r4
    i64.const -2809332043650055899
    i64.mul
    local.set $r4
    local.get $r6
    local.get $r2
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r3
    local.get $r2
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r5
    i64.const -443063056
    i64.add
    local.set $r5
    local.get $r2
    local.get $r4
    call 2
    local.set $r2
    local.get $r3
    i64.const -9139893436486774016
    i64.mul
    local.set $r3
    local.get $r7
    i64.const -1421030544
    i64.add
    local.set $r7
    local.get $r0
    local.get $r5
    i64.sub
    local.set $r0
    local.get $r0
    i64.const -507344318
    i64.add
    local.set $r0
    local.get $r5
    local.get $r4
    i64.sub
    local.set $r5
    local.get $r4
    local.get $r1
    i64.sub
    local.set $r4
    local.get $r7
    local.get $r7
    call 2
    local.set $r7
    local.get $r6
    i64.const -5576458245841833138
    i64.mul
    local.set $r6
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r4
    i64.const 49
    i64.rotr
    local.set $r4
    local.get $r0
    i64.const -761927278
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r3
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r4
    local.get $r5
    call 2
    local.set $r4
    local.get $r1
    i64.const -842532222921972463
    i64.mul
    local.set $r1
    local.get $r5
    i64.const 1716340546
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r0
    i64.const -117245854
    i64.xor
    local.set $r0
    local.get $r7
    local.get $r2
    i64.xor
    local.set $r7
    local.get $r0
    local.get $r3
    i64.xor
    local.set $r0
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r3
    local.get $r5
    local.get $r2
    i64.sub
    local.set $r5
    local.get $r4
    i64.const 1337386092
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r4
    local.get $r2
    i64.sub
    local.set $r4
    local.get $r1
    i64.const 1892115145
    i64.xor
    local.set $r1
    local.get $r2
    local.get $r6
    i64.sub
    local.set $r2
    local.get $r3
    local.get $r1
    i64.sub
    local.set $r3
    local.get $r5
    local.get $r6
    call 2
    local.set $r5
    local.get $r7
    i64.const -7634116589627324723
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r1
    i64.const 53
    i64.rotr
    local.set $r1
    local.get $r0
    local.get $r3
    i64.xor
    local.set $r0
    local.get $r1
    i64.const 1827880272
    i64.add
    local.set $r1
    local.get $r6
    local.get $r3
    i64.xor
    local.set $r6
    local.get $r3
    local.get $r0
    i64.sub
    local.set $r3
    local.get $r1
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r3
    i64.const -511690595
    i64.xor
    local.set $r3
    local.get $r0
    i64.const 58
    i64.rotr
    local.set $r0
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r5
    i64.const 19
    i64.rotr
    local.set $r5
    local.get $r4
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r0
    i64.const 2078746335
    i64.xor
    local.set $r0
    local.get $r0
    i64.const 35
    i64.rotr
    local.set $r0
    local.get $r2
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r0
    i64.const -1289103478
    i64.xor
    local.set $r0
    local.get $r3
    local.get $r3
    call 1
    local.set $r3
    local.get $r0
    i64.const -6598977052858113979
    i64.mul
    local.set $r0
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r7
    i64.const 21
    i64.rotr
    local.set $r7
    local.get $r7
    i64.const -243548818
    i64.add
    local.set $r7
    local.get $r2
    local.get $r6
    i64.sub
    local.set $r2
    local.get $r2
    local.get $r5
    i64.xor
    local.set $r2
    local.get $r1
    local.get $r2
    call 1
    local.set $r1
    local.get $r3
    i64.const -2594976302658576528
    i64.mul
    local.set $r3
    local.get $r2
    i64.const -225526594
    i64.add
    local.set $r2
    local.get $r6
    i64.const 27
    i64.rotr
    local.set $r6
    local.get $r2
    i64.const -1273589022
    i64.xor
    local.set $r2
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r4
    local.get $r6
    i64.sub
    local.set $r4
    local.get $r5
    local.get $r2
    i64.sub
    local.set $r5
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r4
    i64.const -1298936399
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r5
    i64.xor
    local.set $r6
    local.get $r6
    local.get $r4
    i64.xor
    local.set $r6
    local.get $r5
    local.get $r5
    call 1
    local.set $r5
    local.get $r3
    i64.const -5640259258258924753
    i64.mul
    local.set $r3
    local.get $r4
    i64.const 49581145
    i64.add
    local.set $r4
    local.get $r4
    i64.const 52
    i64.rotr
    local.set $r4
    local.get $r1
    i64.const 37
    i64.rotr
    local.set $r1
    local.get $r0
    i64.const 1609600061
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r0
    i64.const 54
    i64.rotr
    local.set $r0
    local.get $r7
    i64.const -870113250
    i64.add
    local.set $r7
    local.get $r1
    local.get $r0
    i64.sub
    local.set $r1
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r5
    i64.sub
    local.set $r7
    local.get $r7
    i64.const 56
    i64.rotr
    local.set $r7
    local.get $r3
    i64.const 683729877
    i64.add
    local.set $r3
    local.get $r1
    i64.const 42
    i64.rotr
    local.set $r1
    local.get $r0
    local.get $r5
    i64.mul
    local.set $r0
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r6
    i64.const 40
    i64.rotr
    local.set $r6
    local.get $r4
    i64.const -1022169606
    i64.add
    local.set $r4
    local.get $r4
    local.get $r3
    i64.sub
    local.set $r4
    local.get $r2
    i64.const 173114895
    i64.add
    local.set $r2
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r3
    local.get $r5
    call 2
    local.set $r3
    local.get $r6
    i64.const -7007933311411634468
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r4
    i64.const 59
    i64.rotr
    local.set $r4
    local.get $r0
    i64.const -1190347686
    i64.add
    local.set $r0
    local.get $r1
    local.get $r4
    i64.sub
    local.set $r1
    local.get $r1
    local.get $r2
    i64.sub
    local.set $r1
    local.get $r0
    local.get $r2
    i64.sub
    local.set $r0
    local.get $r2
    local.get $r1
    i64.sub
    local.set $r2
    local.get $r1
    i64.const 1967382970
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r4
    i64.sub
    local.set $r0
    local.get $r6
    local.get $r7
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r0
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r2
    i64.const 1
    i64.rotr
    local.set $r2
    local.get $r3
    i64.const 41
    i64.rotr
    local.set $r3
    local.get $r6
    i64.const -1237918723
    i64.add
    local.set $r6
    local.get $r0
    local.get $r2
    i64.sub
    local.set $r0
    local.get $r2
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r0
    i64.const -1333933787
    i64.xor
    local.set $r0
    local.get $r7
    i64.const 34
    i64.rotr
    local.set $r7
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r7
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    i64.const 1935620698
    i64.add
    local.set $r4
    local.get $r7
    local.get $r5
    i64.sub
    local.set $r7
    local.get $r5
    local.get $r4
    i64.sub
    local.set $r5
    local.get $r2
    local.get $r4
    i64.xor
    local.set $r2
    local.get $r1
    i64.const 305720766
    i64.xor
    local.set $r1
    local.get $r4
    local.get $r7
    i64.sub
    local.set $r4
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r7
    local.get $r5
    call 1
    local.set $r7
    local.get $r6
    i64.const -7509519849881341872
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r0
    i64.const 8
    i64.rotr
    local.set $r0
    local.get $r3
    i64.const 4
    i64.rotr
    local.set $r3
    local.get $r4
    i64.const 169534153
    i64.add
    local.set $r4
    local.get $r1
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r0
    i64.const 385714747
    i64.add
    local.set $r0
    local.get $r1
    local.get $r0
    i64.xor
    local.set $r1
    local.get $r3
    local.get $r2
    i64.xor
    local.set $r3
    local.get $r4
    local.get $r4
    call 1
    local.set $r4
    local.get $r2
    i64.const -3772812151160035001
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r0
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r5
    i64.const 923698024
    i64.add
    local.set $r5
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r5
    i64.xor
    local.set $r7
    local.get $r7
    i64.const -850006963
    i64.add
    local.set $r7
    local.get $r1
    local.get $r0
    i64.sub
    local.set $r1
    local.get $r4
    local.get $r7
    i64.sub
    local.set $r4
    local.get $r5
    local.get $r7
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r0
    local.get $r5
    i64.mul
    local.set $r0
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r3
    i64.const 56
    i64.rotr
    local.set $r3
    local.get $r4
    local.get $r2
    i64.sub
    local.set $r4
    local.get $r2
    i64.const -2055221521
    i64.xor
    local.set $r2
    local.get $r4
    local.get $r6
    i64.sub
    local.set $r4
    local.get $r5
    local.get $r6
    i64.sub
    local.set $r5
    local.get $r4
    i64.const 36
    i64.rotr
    local.set $r4
    local.get $r3
    i64.const 253250205
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r0
    i64.const 3
    i64.shl
    i64.add
    local.set $r6
    local.get $r2
    local.get $r7
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r3
    i64.const 8
    i64.rotr
    local.set $r3
    local.get $r0
    local.get $r4
    i64.sub
    local.set $r0
    local.get $r3
    i64.const 916323293
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r3
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r3
    call 2
    local.set $r7
    local.get $r0
    i64.const -6266982293222039706
    i64.mul
    local.set $r0
    local.get $r2
    i64.const 848863101
    i64.xor
    local.set $r2
    local.get $r1
    local.get $r3
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r1
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r5
    i64.const 556785952
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r4
    call 1
    local.set $r4
    local.get $r5
    i64.const -7317879033640865484
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r1
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r6
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r7
    local.get $r6
    i64.sub
    local.set $r7
    local.get $r0
    i64.const -285718254
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r7
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r2
    call 1
    local.set $r6
    local.get $r3
    i64.const -8189566912204775474
    i64.mul
    local.set $r3
    local.get $r2
    i64.const 56738140
    i64.xor
    local.set $r2
    local.get $r2
    i64.const 19
    i64.rotr
    local.set $r2
    local.get $r7
    local.get $r5
    i64.const 2
    i64.shl
    i64.add
    local.set $r7
    local.get $r0
    i64.const -1232303853
    i64.add
    local.set $r0
    local.get $r2
    local.get $r5
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r5
    i64.const 17
    i64.rotr
    local.set $r5
    local.get $r0
    i64.const 57
    i64.rotr
    local.set $r0
    local.get $r3
    i64.const 661721069
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r0
    i64.xor
    local.set $r1
    local.get $r0
    i64.const -1930204234
    i64.xor
    local.set $r0
    local.get $r5
    local.get $r1
    i64.xor
    local.set $r5
    local.get $r6
    local.get $r7
    i64.sub
    local.set $r6
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r2
    i64.mul
    local.set $r6
    local.get $r5
    i64.const 9
    i64.rotr
    local.set $r5
    local.get $r2
    i64.const -1401579640
    i64.add
    local.set $r2
    local.get $r0
    local.get $r4
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r4
    i64.sub
    local.set $r2
    local.get $r4
    local.get $r7
    i64.sub
    local.set $r4
    local.get $r2
    i64.const -1207864885
    i64.xor
    local.set $r2
    local.get $r4
    local.get $r1
    i64.sub
    local.set $r4
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r0
    local.get $r7
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r6
    i64.const 47
    i64.rotr
    local.set $r6
    local.get $r5
    i64.const -1322466562
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r7
    local.get $r6
    i64.const 881405279
    i64.add
    local.set $r6
    local.get $r1
    local.get $r7
    i64.sub
    local.set $r1
    local.get $r3
    local.get $r6
    i64.xor
    local.set $r3
    local.get $r2
    local.get $r6
    call 2
    local.set $r2
    local.get $r7
    i64.const -2029403112183078658
    i64.mul
    local.set $r7
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r1
    i64.const 28
    i64.rotr
    local.set $r1
    local.get $r6
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r0
    i64.const -1656973877
    i64.add
    local.set $r0
    local.get $r4
    i64.const 34
    i64.rotr
    local.set $r4
    local.get $r6
    i64.const 39
    i64.rotr
    local.set $r6
    local.get $r4
    i64.const 123731176
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r6
    call 1
    local.set $r1
    local.get $r6
    i64.const -7607112276718257776
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r4
    i64.const 44
    i64.rotr
    local.set $r4
    local.get $r2
    i64.const -151657863
    i64.add
    local.set $r2
    local.get $r4
    local.get $r5
    i64.xor
    local.set $r4
    local.get $r2
    local.get $r3
    i64.xor
    local.set $r2
    local.get $r5
    local.get $r4
    call 2
    local.set $r5
    local.get $r2
    i64.const -3987244783829176824
    i64.mul
    local.set $r2
    local.get $r3
    i64.const -49043826
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r4
    i64.sub
    local.set $r1
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r4
    i64.const 1051595853
    i64.add
    local.set $r4
    local.get $r4
    local.get $r0
    i64.sub
    local.set $r4
    local.get $r1
    local.get $r6
    i64.sub
    local.set $r1
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r1
    i64.mul
    local.set $r3
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r6
    local.get $r1
    i64.const 34
    i64.rotr
    local.set $r1
    local.get $r7
    i64.const -136158898
    i64.add
    local.set $r7
    local.get $r2
    local.get $r6
    i64.xor
    local.set $r2
    local.get $r6
    i64.const 38
    i64.rotr
    local.set $r6
    local.get $r6
    i64.const -1071828203
    i64.add
    local.set $r6
    local.get $r0
    local.get $r1
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r6
    i64.const 11
    i64.rotr
    local.set $r6
    local.get $r4
    i64.const 852089916
    i64.add
    local.set $r4
    local.get $r5
    local.get $r3
    i64.sub
    local.set $r5
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r5
    local.get $r6
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r2
    i64.xor
    local.set $r1
    local.get $r6
    i64.const -348802675
    i64.add
    local.set $r6
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r3
    i64.sub
    local.set $r5
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r1
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $r5
    i64.const -985474027
    i64.add
    local.set $r5
    local.get $r7
    local.get $r1
    i64.sub
    local.set $r7
    local.get $r6
    local.get $r1
    i64.sub
    local.set $r6
    local.get $r1
    local.get $r5
    i64.sub
    local.set $r1
    local.get $r7
    i64.const 414192071
    i64.add
    local.set $r7
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r3
    local.get $r5
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r4
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r2
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    i64.const 1775412529
    i64.add
    local.set $r4
    local.get $r5
    local.get $r0
    call 1
    local.set $r5
    local.get $r6
    i64.const -5918745725548656421
    i64.mul
    local.set $r6
    local.get $r0
    i64.const -83586870
    i64.add
    local.set $r0
    local.get $r0
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r2
    i64.const 13
    i64.rotr
    local.set $r2
    local.get $r7
    i64.const 1558891780
    i64.add
    local.set $r7
    local.get $r2
    local.get $r4
    i64.sub
    local.set $r2
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r4
    local.get $r1
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r3
    i64.const -463663458
    i64.add
    local.set $r3
    local.get $r4
    local.get $r1
    call 1
    local.set $r4
    local.get $r1
    i64.const -9122169596980759877
    i64.mul
    local.set $r1
    local.get $r5
    i64.const -994363373
    i64.add
    local.set $r5
    local.get $r6
    i64.const 47
    i64.rotr
    local.set $r6
    local.get $r3
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r7
    i64.const -66073461
    i64.add
    local.set $r7
    local.get $r0
    i64.const 11
    i64.rotr
    local.set $r0
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r1
    i64.mul
    local.set $r3
    local.get $r7
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r0
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r2
    i64.const 1722291256
    i64.add
    local.set $r2
    local.get $r6
    local.get $r2
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r1
    local.get $r4
    i64.const 3
    i64.shl
    i64.add
    local.set $r1
    local.get $r4
    i64.const 929880865
    i64.xor
    local.set $r4
    local.get $r4
    i64.const 20
    i64.rotr
    local.set $r4
    local.get $r0
    local.get $r7
    i64.mul
    local.set $r0
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r2
    i64.const 59
    i64.rotr
    local.set $r2
    local.get $r4
    i64.const -1590901746
    i64.xor
    local.set $r4
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r5
    i64.const 42
    i64.rotr
    local.set $r5
    local.get $r7
    i64.const -2022418543
    i64.add
    local.set $r7
    local.get $r0
    local.get $r7
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r3
    i64.const 37
    i64.rotr
    local.set $r3
    local.get $r0
    i64.const 44
    i64.rotr
    local.set $r0
    local.get $r5
    i64.const -1496182613
    i64.xor
    local.set $r5
    local.get $r0
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r0
    local.get $r6
    i64.const 46
    i64.rotr
    local.set $r6
    local.get $r3
    i64.const 656773273
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r4
    i64.sub
    local.set $r6
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r0
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r7
    i64.const 51
    i64.rotr
    local.set $r7
    local.get $r1
    i64.const -435370608
    i64.add
    local.set $r1
    local.get $r0
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r4
    local.get $r0
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r0
    i64.const 1893046934
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r4
    call 1
    local.set $r2
    local.get $r1
    i64.const -4740176803859168807
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r7
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r5
    i64.const -522379023
    i64.xor
    local.set $r5
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r6
    local.get $r3
    i64.xor
    local.set $r6
    local.get $r4
    local.get $r3
    i64.sub
    local.set $r4
    local.get $r6
    local.get $r3
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r3
    i64.const 1539684645
    i64.add
    local.set $r3
    local.get $r1
    local.get $r3
    i64.sub
    local.set $r1
    local.get $r5
    local.get $r4
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r4
    i64.mul
    local.set $r1
    local.get $r6
    i64.const 58
    i64.rotr
    local.set $r6
    local.get $r0
    i64.const 4
    i64.rotr
    local.set $r0
    local.get $r2
    i64.const -3339622
    i64.add
    local.set $r2
    local.get $r4
    local.get $r0
    call 2
    local.set $r4
    local.get $r6
    i64.const -7823182285918869151
    i64.mul
    local.set $r6
    local.get $r7
    i64.const -1331634197
    i64.xor
    local.set $r7
    local.get $r0
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r3
    i64.const 29
    i64.rotr
    local.set $r3
    local.get $r5
    i64.const 991220126
    i64.xor
    local.set $r5
    local.get $r0
    local.get $r5
    i64.sub
    local.set $r0
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r1
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r2
    i64.const 43
    i64.rotr
    local.set $r2
    local.get $r1
    i64.const -1419298727
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r1
    call 1
    local.set $r7
    local.get $r1
    i64.const -6523847536038295582
    i64.mul
    local.set $r1
    local.get $r4
    i64.const 2040168225
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r2
    call 2
    local.set $r6
    local.get $item_number
    i64.const 4194303
    i64.and
    i32.wrap_i64
    i32.const 6
    i32.shl
    i32.const 51872
    i32.add
    local.set $mixblock_ptr
    local.get $mixblock_ptr
    i64.load align=4
    local.get $r0
    i64.xor
    local.set $r0
    local.get $mixblock_ptr
    i64.load offset=8 align=4
    local.get $r1
    i64.xor
    local.set $r1
    local.get $mixblock_ptr
    i64.load offset=16 align=4
    local.get $r2
    i64.xor
    local.set $r2
    local.get $mixblock_ptr
    i64.load offset=24 align=4
    local.get $r3
    i64.xor
    local.set $r3
    local.get $mixblock_ptr
    i64.load offset=32 align=4
    local.get $r4
    i64.xor
    local.set $r4
    local.get $mixblock_ptr
    i64.load offset=40 align=4
    local.get $r5
    i64.xor
    local.set $r5
    local.get $mixblock_ptr
    i64.load offset=48 align=4
    local.get $r6
    i64.xor
    local.set $r6
    local.get $mixblock_ptr
    i64.load offset=56 align=4
    local.get $r7
    i64.xor
    local.set $r7
    local.get $r6
    local.set $item_number
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r1
    local.get $r1
    local.get $r2
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r0
    i64.const 238825221
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r3
    i64.sub
    local.set $r1
    local.get $r4
    i64.const 10
    i64.rotr
    local.set $r4
    local.get $r1
    i64.const -1151978571
    i64.xor
    local.set $r1
    local.get $r3
    local.get $r5
    i64.const 3
    i64.shl
    i64.add
    local.set $r3
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r6
    i64.const 12
    i64.rotr
    local.set $r6
    local.get $r1
    local.get $r2
    i64.xor
    local.set $r1
    local.get $r6
    i64.const 1809821075
    i64.add
    local.set $r6
    local.get $r5
    local.get $r1
    i64.sub
    local.set $r5
    local.get $r2
    local.get $r2
    call 2
    local.set $r2
    local.get $r5
    i64.const -4601809989100657656
    i64.mul
    local.set $r5
    local.get $r7
    i64.const -1639221501
    i64.add
    local.set $r7
    local.get $r0
    local.get $r3
    call 1
    local.set $r0
    local.get $r6
    i64.const -1512590694346099042
    i64.mul
    local.set $r6
    local.get $r3
    i64.const 806173223
    i64.xor
    local.set $r3
    local.get $r7
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r7
    local.get $r3
    i64.const 27
    i64.rotr
    local.set $r3
    local.get $r4
    i64.const -1037964292
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r1
    call 1
    local.set $r1
    local.get $r3
    i64.const -9176714201051083098
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r7
    i64.const 40
    i64.rotr
    local.set $r7
    local.get $r0
    i64.const 373411103
    i64.add
    local.set $r0
    local.get $r6
    local.get $r7
    i64.sub
    local.set $r6
    local.get $r7
    local.get $r0
    i64.xor
    local.set $r7
    local.get $r5
    local.get $r3
    call 2
    local.set $r5
    local.get $r0
    i64.const -8873642921256700031
    i64.mul
    local.set $r0
    local.get $r6
    i64.const 1661973119
    i64.add
    local.set $r6
    local.get $r6
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r7
    i64.const 49
    i64.rotr
    local.set $r7
    local.get $r3
    i64.const -1265567014
    i64.xor
    local.set $r3
    local.get $r2
    i64.const 25
    i64.rotr
    local.set $r2
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r4
    i64.const 51
    i64.rotr
    local.set $r4
    local.get $r0
    i64.const 36
    i64.rotr
    local.set $r0
    local.get $r2
    i64.const -1656232771
    i64.xor
    local.set $r2
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r5
    i64.const 508713769
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r3
    i64.xor
    local.set $r2
    local.get $r5
    local.get $r0
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r0
    call 1
    local.set $r4
    local.get $r3
    i64.const -6176998572775190826
    i64.mul
    local.set $r3
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r1
    i64.const 273336985
    i64.add
    local.set $r1
    local.get $r5
    local.get $r6
    i64.sub
    local.set $r5
    local.get $r1
    local.get $r6
    i64.sub
    local.set $r1
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r0
    i64.const 1836793849
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r0
    i64.sub
    local.set $r1
    local.get $r6
    local.get $r5
    i64.xor
    local.set $r6
    local.get $r5
    local.get $r3
    call 2
    local.set $r5
    local.get $r0
    i64.const -5900098439355553807
    i64.mul
    local.set $r0
    local.get $r1
    local.get $r4
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r6
    i64.const 44
    i64.rotr
    local.set $r6
    local.get $r2
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r3
    i64.const -1788745427
    i64.xor
    local.set $r3
    local.get $r3
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r1
    i64.const 9
    i64.rotr
    local.set $r1
    local.get $r6
    i64.const 829667213
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r6
    call 1
    local.set $r7
    local.get $r5
    i64.const -1966862950322245310
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r6
    i64.const 38
    i64.rotr
    local.set $r6
    local.get $r2
    i64.const 8
    i64.rotr
    local.set $r2
    local.get $r1
    i64.const 677856434
    i64.xor
    local.set $r1
    local.get $r6
    local.get $r4
    call 2
    local.set $r6
    local.get $r2
    i64.const -3435509325065803778
    i64.mul
    local.set $r2
    local.get $r1
    i64.const -1238222786
    i64.add
    local.set $r1
    local.get $r4
    local.get $r3
    call 2
    local.set $r4
    local.get $r7
    i64.const -6906103771232614946
    i64.mul
    local.set $r7
    local.get $r5
    i64.const 346686385
    i64.add
    local.set $r5
    local.get $r3
    local.get $r0
    call 2
    local.set $r3
    local.get $r0
    i64.const -5445458340252576860
    i64.mul
    local.set $r0
    local.get $r1
    i64.const 241359697
    i64.xor
    local.set $r1
    local.get $r1
    i64.const 46
    i64.rotr
    local.set $r1
    local.get $r2
    local.get $r5
    i64.sub
    local.set $r2
    local.get $r6
    i64.const 599201620
    i64.add
    local.set $r6
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r2
    call 1
    local.set $r5
    local.get $r6
    i64.const -3674509081974487600
    i64.mul
    local.set $r6
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r1
    i64.mul
    local.set $r4
    local.get $r1
    i64.const 30
    i64.rotr
    local.set $r1
    local.get $r2
    i64.const 37
    i64.rotr
    local.set $r2
    local.get $r1
    i64.const 1310801438
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r0
    call 2
    local.set $r7
    local.get $r5
    i64.const -4338140666234251900
    i64.mul
    local.set $r5
    local.get $r0
    i64.const -163488449
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r2
    i64.sub
    local.set $r1
    local.get $r2
    local.get $r1
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r6
    i64.const 1611439939
    i64.xor
    local.set $r6
    local.get $r2
    i64.const 18
    i64.rotr
    local.set $r2
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r2
    i64.mul
    local.set $r6
    local.get $r3
    i64.const 4
    i64.rotr
    local.set $r3
    local.get $r4
    local.get $r2
    i64.const 1
    i64.shl
    i64.add
    local.set $r4
    local.get $r3
    i64.const 274327019
    i64.xor
    local.set $r3
    local.get $r3
    local.get $r2
    i64.sub
    local.set $r3
    local.get $r4
    i64.const 705562719
    i64.add
    local.set $r4
    local.get $r7
    local.get $r5
    i64.xor
    local.set $r7
    local.get $r4
    local.get $r0
    i64.xor
    local.set $r4
    local.get $r2
    local.get $r7
    call 1
    local.set $r2
    local.get $r3
    i64.const -7383409723637703264
    i64.mul
    local.set $r3
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r0
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r1
    i64.const 36
    i64.rotr
    local.set $r1
    local.get $r0
    i64.const -460348737
    i64.add
    local.set $r0
    local.get $r1
    local.get $r5
    i64.const 1
    i64.shl
    i64.add
    local.set $r1
    local.get $r6
    i64.const -414711393
    i64.xor
    local.set $r6
    local.get $r6
    local.get $r7
    i64.sub
    local.set $r6
    local.get $r0
    local.get $r7
    i64.sub
    local.set $r0
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r0
    i64.const 16
    i64.rotr
    local.set $r0
    local.get $r5
    i64.const -1590936108
    i64.add
    local.set $r5
    local.get $r5
    local.get $r2
    i64.sub
    local.set $r5
    local.get $r2
    local.get $r4
    i64.xor
    local.set $r2
    local.get $r0
    local.get $r4
    i64.sub
    local.set $r0
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r7
    i64.const -1100133659
    i64.xor
    local.set $r7
    local.get $r2
    local.get $r6
    i64.sub
    local.set $r2
    local.get $r5
    local.get $r0
    i64.xor
    local.set $r5
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r4
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    i64.const -347094335
    i64.xor
    local.set $r4
    local.get $r2
    local.get $r7
    i64.sub
    local.set $r2
    local.get $r1
    local.get $r7
    i64.sub
    local.set $r1
    local.get $r7
    local.get $r7
    call 2
    local.set $r7
    local.get $r4
    i64.const -5546171317515176522
    i64.mul
    local.set $r4
    local.get $r1
    i64.const -1958440398
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r1
    i64.xor
    local.set $r0
    local.get $r3
    i64.const 30
    i64.rotr
    local.set $r3
    local.get $r0
    i64.const -200329399
    i64.add
    local.set $r0
    local.get $r3
    local.get $r1
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r3
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r3
    local.get $r6
    i64.const -1315499701
    i64.xor
    local.set $r6
    local.get $r4
    i64.const 40
    i64.rotr
    local.set $r4
    local.get $r3
    i64.const 132942903
    i64.add
    local.set $r3
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r6
    i64.sub
    local.set $r4
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r1
    local.get $r5
    local.get $r0
    i64.xor
    local.set $r5
    local.get $r0
    i64.const -1746726289
    i64.add
    local.set $r0
    local.get $r7
    local.get $r1
    i64.sub
    local.set $r7
    local.get $r1
    local.get $r5
    i64.sub
    local.set $r1
    local.get $r5
    local.get $r6
    i64.xor
    local.set $r5
    local.get $r5
    i64.const 1784633635
    i64.add
    local.set $r5
    local.get $r0
    local.get $r1
    i64.sub
    local.set $r0
    local.get $r6
    local.get $r6
    call 2
    local.set $r6
    local.get $r0
    i64.const -6885817228438277643
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r1
    i64.const 56
    i64.rotr
    local.set $r1
    local.get $r2
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r3
    i64.const -1433294280
    i64.add
    local.set $r3
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r3
    i64.const 34
    i64.rotr
    local.set $r3
    local.get $r1
    i64.const 1033238263
    i64.xor
    local.set $r1
    local.get $r2
    i64.const 15
    i64.rotr
    local.set $r2
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r7
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r6
    i64.const 16
    i64.rotr
    local.set $r6
    local.get $r4
    local.get $r2
    i64.xor
    local.set $r4
    local.get $r2
    i64.const 368739200
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r7
    i64.sub
    local.set $r6
    local.get $r6
    local.get $r4
    i64.sub
    local.set $r6
    local.get $r4
    local.get $r5
    i64.xor
    local.set $r4
    local.get $r7
    i64.const -601840089
    i64.xor
    local.set $r7
    local.get $r5
    local.get $r1
    i64.sub
    local.set $r5
    local.get $r1
    local.get $r2
    i64.sub
    local.set $r1
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r5
    local.get $r4
    i64.mul
    local.set $r5
    local.get $r4
    i64.const 51
    i64.rotr
    local.set $r4
    local.get $r0
    i64.const -2110079451
    i64.xor
    local.set $r0
    local.get $r4
    local.get $r0
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r0
    i64.xor
    local.set $r3
    local.get $r4
    local.get $r6
    i64.sub
    local.set $r4
    local.get $r3
    local.get $r6
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r3
    i64.const -856556089
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r6
    call 1
    local.set $r6
    local.get $r3
    i64.const -6007529890494956506
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r2
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r4
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r1
    i64.const 1777110024
    i64.add
    local.set $r1
    local.get $r2
    local.get $r0
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    local.get $r5
    i64.xor
    local.set $r4
    local.get $r5
    i64.const -1898868163
    i64.add
    local.set $r5
    local.get $r1
    local.get $r4
    i64.sub
    local.set $r1
    local.get $r0
    local.get $r4
    call 2
    local.set $r0
    local.get $r6
    i64.const -6354204447663612946
    i64.mul
    local.set $r6
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r1
    local.get $r2
    i64.const 1
    i64.shl
    i64.add
    local.set $r1
    local.get $r1
    local.get $r2
    i64.xor
    local.set $r1
    local.get $r2
    i64.const 549806489
    i64.add
    local.set $r2
    local.get $r1
    local.get $r7
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r6
    call 1
    local.set $r5
    local.get $r3
    i64.const -5954800308576197361
    i64.mul
    local.set $r3
    local.get $r1
    i64.const 979474323
    i64.xor
    local.set $r1
    local.get $r2
    local.get $r7
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r1
    i64.xor
    local.set $r6
    local.get $r1
    i64.const 397339877
    i64.add
    local.set $r1
    local.get $r0
    local.get $r2
    i64.sub
    local.set $r0
    local.get $r4
    local.get $r6
    i64.sub
    local.set $r4
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r2
    i64.const 22
    i64.rotr
    local.set $r2
    local.get $r0
    local.get $r7
    i64.sub
    local.set $r0
    local.get $r2
    i64.const 1902584813
    i64.xor
    local.set $r2
    local.get $r7
    local.get $r5
    i64.sub
    local.set $r7
    local.get $r5
    local.get $r5
    call 2
    local.set $r5
    local.get $r1
    i64.const -7308305121952743742
    i64.mul
    local.set $r1
    local.get $r0
    i64.const 1061792902
    i64.xor
    local.set $r0
    local.get $r3
    local.get $r7
    call 1
    local.set $r3
    local.get $r0
    i64.const -6756850606994688757
    i64.mul
    local.set $r0
    local.get $r2
    i64.const 12204872
    i64.add
    local.set $r2
    local.get $r7
    local.get $r7
    call 1
    local.set $r7
    local.get $r2
    i64.const -8886524151210010540
    i64.mul
    local.set $r2
    local.get $r6
    i64.const -1592007196
    i64.add
    local.set $r6
    local.get $r4
    local.get $r4
    call 2
    local.set $r4
    local.get $r3
    i64.const -4197302219780492378
    i64.mul
    local.set $r3
    local.get $r5
    i64.const 193312333
    i64.xor
    local.set $r5
    local.get $r5
    i64.const 44
    i64.rotr
    local.set $r5
    local.get $r1
    i64.const -1418842388
    i64.add
    local.set $r1
    local.get $r6
    local.get $r5
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r4
    local.get $r0
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r5
    i64.const -1596466578
    i64.xor
    local.set $r5
    local.get $r0
    local.get $r7
    i64.sub
    local.set $r0
    local.get $r7
    local.get $r3
    i64.xor
    local.set $r7
    local.get $r5
    i64.const -1066213150
    i64.add
    local.set $r5
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r3
    local.get $r3
    call 2
    local.set $r3
    local.get $r6
    i64.const -8094258984836549242
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r5
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r5
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r5
    i64.const 48
    i64.rotr
    local.set $r5
    local.get $r2
    i64.const -984658197
    i64.add
    local.set $r2
    local.get $r2
    local.get $r0
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r1
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r5
    i64.const -53723029
    i64.add
    local.set $r5
    local.get $r4
    local.get $r5
    i64.xor
    local.set $r4
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r4
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r4
    local.get $r2
    i64.const -1215676367
    i64.add
    local.set $r2
    local.get $r2
    local.get $r7
    i64.sub
    local.set $r2
    local.get $r7
    local.get $r3
    i64.sub
    local.set $r7
    local.get $r0
    local.get $r5
    call 2
    local.set $r0
    local.get $r2
    i64.const -4466727345051244442
    i64.mul
    local.set $r2
    local.get $r5
    i64.const 1498425285
    i64.add
    local.set $r5
    local.get $r4
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r5
    i64.const -169656433
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r7
    i64.sub
    local.set $r1
    local.get $r6
    local.get $r3
    i64.xor
    local.set $r6
    local.get $r6
    local.get $r1
    i64.sub
    local.set $r6
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r3
    i64.const 26
    i64.rotr
    local.set $r3
    local.get $r0
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r1
    i64.const -905486965
    i64.add
    local.set $r1
    local.get $r0
    i64.const 47
    i64.rotr
    local.set $r0
    local.get $r7
    i64.const 36754489
    i64.xor
    local.set $r7
    local.get $r4
    local.get $r1
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r0
    i64.xor
    local.set $r7
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r6
    i64.const 34
    i64.rotr
    local.set $r6
    local.get $r7
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r1
    i64.const -406105890
    i64.add
    local.set $r1
    local.get $r5
    local.get $r5
    call 1
    local.set $r5
    local.get $r1
    i64.const -7415552310697254428
    i64.mul
    local.set $r1
    local.get $r7
    i64.const -1896630070
    i64.xor
    local.set $r7
    local.get $r2
    local.get $r6
    i64.sub
    local.set $r2
    local.get $r6
    i64.const -2054726544
    i64.add
    local.set $r6
    local.get $r6
    local.get $r0
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r2
    i64.xor
    local.set $r0
    local.get $r6
    local.get $r3
    i64.sub
    local.set $r6
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r3
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r4
    i64.const 1399436763
    i64.add
    local.set $r4
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r2
    local.get $r1
    i64.sub
    local.set $r2
    local.get $r4
    i64.const 897110282
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r5
    call 1
    local.set $r5
    local.get $r0
    i64.const -1745555818546148411
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r1
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r1
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r6
    i64.const 273832292
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r1
    i64.sub
    local.set $r7
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r4
    local.get $r1
    i64.xor
    local.set $r4
    local.get $r4
    i64.const -484349925
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r7
    i64.sub
    local.set $r1
    local.get $r4
    local.get $r0
    i64.sub
    local.set $r4
    local.get $r6
    local.get $r4
    call 1
    local.set $r6
    local.get $r4
    i64.const -5220737427225095516
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r0
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $r2
    i64.const 723738336
    i64.xor
    local.set $r2
    local.get $r0
    local.get $r7
    i64.sub
    local.set $r0
    local.get $r7
    local.get $r7
    call 1
    local.set $r7
    local.get $r5
    i64.const -7146749341591137804
    i64.mul
    local.set $r5
    local.get $r0
    i64.const 1698825473
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r2
    local.get $r3
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r3
    i64.const 238063488
    i64.add
    local.set $r3
    local.get $r4
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r4
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r7
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r1
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r6
    local.get $r1
    i64.sub
    local.set $r6
    local.get $r2
    i64.const -1023560576
    i64.xor
    local.set $r2
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r2
    call 2
    local.set $r1
    local.get $r2
    i64.const -2424632705409062852
    i64.mul
    local.set $r2
    local.get $r0
    i64.const -1068731337
    i64.xor
    local.set $r0
    local.get $r6
    i64.const 50
    i64.rotr
    local.set $r6
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r7
    i64.const 2034735208
    i64.add
    local.set $r7
    local.get $r5
    local.get $r6
    i64.xor
    local.set $r5
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r3
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r3
    local.get $r4
    i64.sub
    local.set $r3
    local.get $r4
    i64.const -1532245937
    i64.add
    local.set $r4
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r6
    i64.sub
    local.set $r2
    local.get $r2
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r5
    i64.const 1071912885
    i64.xor
    local.set $r5
    local.get $r0
    i64.const 32
    i64.rotr
    local.set $r0
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r7
    local.get $r7
    i64.const 23
    i64.rotr
    local.set $r7
    local.get $r0
    i64.const 1347230466
    i64.add
    local.set $r0
    local.get $r4
    local.get $r1
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r6
    local.get $r1
    i64.const -58305812
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r1
    i64.const 0
    i64.shl
    i64.add
    local.set $r0
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r2
    i64.const 13
    i64.rotr
    local.set $r2
    local.get $r2
    i64.const -1535601409
    i64.add
    local.set $r2
    local.get $r7
    local.get $r0
    i64.xor
    local.set $r7
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r7
    i64.sub
    local.set $r2
    local.get $r7
    i64.const 17
    i64.rotr
    local.set $r7
    local.get $r0
    i64.const 508458456
    i64.add
    local.set $r0
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r4
    local.get $r1
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r0
    i64.const 2
    i64.shl
    i64.add
    local.set $r7
    local.get $r3
    i64.const -1196253155
    i64.add
    local.set $r3
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r7
    local.get $r1
    i64.sub
    local.set $r7
    local.get $r6
    i64.const 787156278
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r1
    i64.sub
    local.set $r2
    local.get $r3
    local.get $r6
    call 1
    local.set $r3
    local.get $r5
    i64.const -4096494888764769038
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r6
    i64.const 21
    i64.rotr
    local.set $r6
    local.get $r4
    i64.const 28
    i64.rotr
    local.set $r4
    local.get $r0
    i64.const 1613206548
    i64.xor
    local.set $r0
    local.get $r4
    local.get $r2
    i64.xor
    local.set $r4
    local.get $r6
    i64.const -1528983677
    i64.add
    local.set $r6
    local.get $r6
    local.get $r4
    i64.sub
    local.set $r6
    local.get $r2
    local.get $r4
    i64.sub
    local.set $r2
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r1
    i64.mul
    local.set $r4
    local.get $r6
    i64.const 14
    i64.rotr
    local.set $r6
    local.get $r6
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r7
    i64.const 1151422993
    i64.add
    local.set $r7
    local.get $r7
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r3
    i64.const 503813838
    i64.add
    local.set $r3
    local.get $r3
    local.get $r1
    i64.sub
    local.set $r3
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r7
    i64.sub
    local.set $r1
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $item_number
    i64.const 4194303
    i64.and
    i32.wrap_i64
    i32.const 6
    i32.shl
    i32.const 51872
    i32.add
    local.set $mixblock_ptr
    local.get $mixblock_ptr
    i64.load align=4
    local.get $r0
    i64.xor
    local.set $r0
    local.get $mixblock_ptr
    i64.load offset=8 align=4
    local.get $r1
    i64.xor
    local.set $r1
    local.get $mixblock_ptr
    i64.load offset=16 align=4
    local.get $r2
    i64.xor
    local.set $r2
    local.get $mixblock_ptr
    i64.load offset=24 align=4
    local.get $r3
    i64.xor
    local.set $r3
    local.get $mixblock_ptr
    i64.load offset=32 align=4
    local.get $r4
    i64.xor
    local.set $r4
    local.get $mixblock_ptr
    i64.load offset=40 align=4
    local.get $r5
    i64.xor
    local.set $r5
    local.get $mixblock_ptr
    i64.load offset=48 align=4
    local.get $r6
    i64.xor
    local.set $r6
    local.get $mixblock_ptr
    i64.load offset=56 align=4
    local.get $r7
    i64.xor
    local.set $r7
    local.get $r0
    local.set $item_number
    local.get $r3
    local.get $r7
    i64.mul
    local.set $r3
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r4
    i64.const 38
    i64.rotr
    local.set $r4
    local.get $r6
    i64.const -2138968437
    i64.xor
    local.set $r6
    local.get $r7
    i64.const 7
    i64.rotr
    local.set $r7
    local.get $r6
    local.get $r4
    i64.const 1
    i64.shl
    i64.add
    local.set $r6
    local.get $r6
    i64.const -309615004
    i64.xor
    local.set $r6
    local.get $r1
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r1
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r0
    i64.mul
    local.set $r4
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r3
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r2
    local.get $r0
    i64.xor
    local.set $r2
    local.get $r2
    i64.const 553640158
    i64.xor
    local.set $r2
    local.get $r1
    local.get $r3
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r2
    i64.sub
    local.set $r5
    local.get $r2
    i64.const 55
    i64.rotr
    local.set $r2
    local.get $r0
    i64.const 1908670836
    i64.xor
    local.set $r0
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r0
    local.get $r7
    i64.mul
    local.set $r0
    local.get $r5
    local.get $r3
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r1
    i64.const 7
    i64.rotr
    local.set $r1
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r4
    i64.const -1076580482
    i64.xor
    local.set $r4
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r4
    i64.const 57
    i64.rotr
    local.set $r4
    local.get $r6
    i64.const 2140717457
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r7
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r0
    i64.const 26
    i64.rotr
    local.set $r0
    local.get $r7
    i64.const 59
    i64.rotr
    local.set $r7
    local.get $r7
    i64.const -1398646553
    i64.xor
    local.set $r7
    local.get $r2
    local.get $r0
    i64.xor
    local.set $r2
    local.get $r2
    i64.const 13
    i64.rotr
    local.set $r2
    local.get $r0
    i64.const 520992067
    i64.add
    local.set $r0
    local.get $r0
    local.get $r7
    i64.sub
    local.set $r0
    local.get $r2
    local.get $r7
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r3
    i64.const 38
    i64.rotr
    local.set $r3
    local.get $r5
    i64.const 37
    i64.rotr
    local.set $r5
    local.get $r3
    i64.const -905251207
    i64.add
    local.set $r3
    local.get $r4
    local.get $r2
    call 2
    local.set $r4
    local.get $r0
    i64.const -1573165812824587744
    i64.mul
    local.set $r0
    local.get $r5
    i64.const 351710070
    i64.add
    local.set $r5
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r2
    i64.const 1
    i64.shl
    i64.add
    local.set $r1
    local.get $r6
    i64.const -396343476
    i64.xor
    local.set $r6
    local.get $r6
    i64.const 36
    i64.rotr
    local.set $r6
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r7
    i64.const 10
    i64.rotr
    local.set $r7
    local.get $r2
    i64.const 11
    i64.rotr
    local.set $r2
    local.get $r3
    i64.const -403447275
    i64.xor
    local.set $r3
    local.get $r3
    i64.const 47
    i64.rotr
    local.set $r3
    local.get $r0
    local.get $r2
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r7
    i64.const 1748658284
    i64.add
    local.set $r7
    local.get $r0
    i64.const 2
    i64.rotr
    local.set $r0
    local.get $r3
    local.get $r1
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r1
    i64.const 9
    i64.rotr
    local.set $r1
    local.get $r5
    i64.const 1695373184
    i64.xor
    local.set $r5
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r2
    i64.sub
    local.set $r1
    local.get $r2
    local.get $r1
    call 2
    local.set $r2
    local.get $r6
    i64.const -2506818744919150402
    i64.mul
    local.set $r6
    local.get $r4
    i64.const -300951418
    i64.xor
    local.set $r4
    local.get $r5
    local.get $r3
    call 1
    local.set $r5
    local.get $r4
    i64.const -8318594259293014943
    i64.mul
    local.set $r4
    local.get $r3
    i64.const -1521857643
    i64.add
    local.set $r3
    local.get $r7
    i64.const 1
    i64.rotr
    local.set $r7
    local.get $r1
    local.get $r3
    i64.sub
    local.set $r1
    local.get $r1
    i64.const 2100061727
    i64.add
    local.set $r1
    local.get $r2
    local.get $r0
    i64.sub
    local.set $r2
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r7
    local.get $r0
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r2
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r1
    i64.const 56
    i64.rotr
    local.set $r1
    local.get $r1
    i64.const -234131539
    i64.add
    local.set $r1
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r2
    i64.const -449737524
    i64.add
    local.set $r2
    local.get $r5
    local.get $r1
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r1
    i64.sub
    local.set $r7
    local.get $r6
    local.get $r4
    call 1
    local.set $r6
    local.get $r2
    i64.const -7732554623419079243
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r0
    i64.const 42
    i64.rotr
    local.set $r0
    local.get $r1
    local.get $r3
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r3
    i64.const 1742657967
    i64.add
    local.set $r3
    local.get $r3
    local.get $r5
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r4
    i64.sub
    local.set $r0
    local.get $r0
    i64.const 1246477225
    i64.add
    local.set $r0
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r4
    local.get $r5
    i64.sub
    local.set $r4
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r1
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r3
    i64.const 883368358
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r3
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r3
    i64.xor
    local.set $r7
    local.get $r3
    local.get $r7
    i64.sub
    local.set $r3
    local.get $r1
    i64.const -1551663060
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r3
    i64.sub
    local.set $r5
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r3
    local.get $r1
    i64.sub
    local.set $r3
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r4
    i64.mul
    local.set $r1
    local.get $r3
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r2
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    i64.const -1392209285
    i64.xor
    local.set $r4
    local.get $r2
    local.get $r3
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r4
    i64.const -366787591
    i64.add
    local.set $r4
    local.get $r2
    local.get $r4
    i64.xor
    local.set $r2
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r1
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r5
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r5
    i64.const 1094525120
    i64.add
    local.set $r5
    local.get $r5
    local.get $r1
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r6
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r1
    i64.const -892079912
    i64.add
    local.set $r1
    local.get $r2
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r7
    i64.const 34
    i64.rotr
    local.set $r7
    local.get $r7
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r7
    local.get $r6
    i64.const 277752612
    i64.xor
    local.set $r6
    local.get $r3
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r6
    i64.const -1792277042
    i64.add
    local.set $r6
    local.get $r0
    local.get $r4
    i64.xor
    local.set $r0
    local.get $r6
    local.get $r7
    i64.sub
    local.set $r6
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r5
    i64.const 44
    i64.rotr
    local.set $r5
    local.get $r1
    i64.const 63
    i64.rotr
    local.set $r1
    local.get $r2
    i64.const 1129283510
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r1
    i64.sub
    local.set $r6
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r6
    i64.const 1743072729
    i64.xor
    local.set $r6
    local.get $r4
    local.get $r2
    i64.xor
    local.set $r4
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r7
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r4
    local.get $r7
    i64.xor
    local.set $r4
    local.get $r0
    i64.const 679054311
    i64.xor
    local.set $r0
    local.get $r4
    local.get $r1
    i64.sub
    local.set $r4
    local.get $r5
    local.get $r4
    i64.sub
    local.set $r5
    local.get $r3
    i64.const 63
    i64.rotr
    local.set $r3
    local.get $r7
    i64.const 500142839
    i64.xor
    local.set $r7
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r5
    local.get $r4
    i64.mul
    local.set $r5
    local.get $r1
    i64.const 7
    i64.rotr
    local.set $r1
    local.get $r2
    i64.const -27511734
    i64.xor
    local.set $r2
    local.get $r4
    local.get $r6
    i64.sub
    local.set $r4
    local.get $r2
    local.get $r0
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r4
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r0
    i64.xor
    local.set $r7
    local.get $r4
    i64.const 629202519
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r7
    call 2
    local.set $r0
    local.get $r2
    i64.const -4051662908447059252
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r5
    i64.const 13
    i64.rotr
    local.set $r5
    local.get $r3
    local.get $r4
    i64.const 3
    i64.shl
    i64.add
    local.set $r3
    local.get $r4
    i64.const -955617560
    i64.add
    local.set $r4
    local.get $r6
    local.get $r6
    call 2
    local.set $r6
    local.get $r3
    i64.const -3215894113091018880
    i64.mul
    local.set $r3
    local.get $r5
    i64.const 1257029073
    i64.add
    local.set $r5
    local.get $r4
    i64.const 1
    i64.rotr
    local.set $r4
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r5
    i64.const 41136662
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r2
    i64.sub
    local.set $r4
    local.get $r2
    local.get $r7
    call 2
    local.set $r2
    local.get $r1
    i64.const -6466201231033821954
    i64.mul
    local.set $r1
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r7
    i64.const 17
    i64.rotr
    local.set $r7
    local.get $r7
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r0
    i64.const -99361945
    i64.xor
    local.set $r0
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r6
    i64.const -800591279
    i64.add
    local.set $r6
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $r7
    local.get $r6
    i64.xor
    local.set $r7
    local.get $r3
    local.get $r5
    call 2
    local.set $r3
    local.get $r2
    i64.const -6035333909357274484
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r5
    i64.const 3
    i64.shl
    i64.add
    local.set $r7
    local.get $r0
    i64.const 1307794424
    i64.add
    local.set $r0
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r5
    local.get $r6
    i64.sub
    local.set $r5
    local.get $r4
    local.get $r5
    call 1
    local.set $r4
    local.get $r5
    i64.const -4794736504888532134
    i64.mul
    local.set $r5
    local.get $r0
    i64.const -2007077598
    i64.xor
    local.set $r0
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r0
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r6
    i64.const -1533159214
    i64.add
    local.set $r6
    local.get $r7
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r7
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r0
    i64.mul
    local.set $r4
    local.get $r6
    i64.const 29
    i64.rotr
    local.set $r6
    local.get $r7
    local.get $r1
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r6
    i64.const 824320601
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r7
    i64.const 214919263
    i64.add
    local.set $r7
    local.get $r3
    local.get $r0
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r1
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r0
    call 2
    local.set $r1
    local.get $r2
    i64.const -4072513931232634064
    i64.mul
    local.set $r2
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r3
    local.get $r6
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r5
    i64.const 667561445
    i64.add
    local.set $r5
    local.get $r6
    local.get $r5
    call 1
    local.set $r6
    local.get $r3
    i64.const -3995525290158761133
    i64.mul
    local.set $r3
    local.get $r4
    i64.const -1723553957
    i64.add
    local.set $r4
    local.get $r2
    local.get $r5
    i64.xor
    local.set $r2
    local.get $r5
    i64.const 16
    i64.rotr
    local.set $r5
    local.get $r2
    i64.const -1524445143
    i64.xor
    local.set $r2
    local.get $r1
    i64.const 63
    i64.rotr
    local.set $r1
    local.get $r1
    local.get $r4
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r4
    i64.const 39
    i64.rotr
    local.set $r4
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r7
    i64.const 1363944740
    i64.add
    local.set $r7
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r7
    i64.const 45
    i64.rotr
    local.set $r7
    local.get $r1
    i64.const 769752492
    i64.add
    local.set $r1
    local.get $r0
    local.get $r0
    call 2
    local.set $r0
    local.get $r6
    i64.const -9093927759850669854
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r2
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r2
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r5
    i64.const 1615375249
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r1
    i64.const 1476271684
    i64.xor
    local.set $r1
    local.get $r3
    local.get $r1
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r1
    i64.sub
    local.set $r5
    local.get $r1
    local.get $r2
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r6
    i64.const 39
    i64.rotr
    local.set $r6
    local.get $r2
    local.get $r7
    i64.sub
    local.set $r2
    local.get $r4
    i64.const -1415415595
    i64.add
    local.set $r4
    local.get $r7
    local.get $r2
    i64.xor
    local.set $r7
    local.get $r6
    local.get $r7
    i64.xor
    local.set $r6
    local.get $r1
    i64.const 1316777400
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r2
    local.get $r4
    i64.sub
    local.set $r2
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r3
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r3
    i64.const -1322339903
    i64.add
    local.set $r3
    local.get $r4
    local.get $r7
    i64.xor
    local.set $r4
    local.get $r7
    local.get $r6
    call 1
    local.set $r7
    local.get $r0
    i64.const -263985622107669766
    i64.mul
    local.set $r0
    local.get $r4
    i64.const -717757183
    i64.add
    local.set $r4
    local.get $r6
    local.get $r3
    i64.xor
    local.set $r6
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r6
    i64.const 1289540347
    i64.add
    local.set $r6
    local.get $r3
    local.get $r4
    i64.sub
    local.set $r3
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r5
    i64.const 7
    i64.rotr
    local.set $r5
    local.get $r3
    i64.const 1548302770
    i64.add
    local.set $r3
    local.get $r3
    local.get $r1
    i64.sub
    local.set $r3
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r2
    local.get $r6
    call 2
    local.set $r2
    local.get $r6
    i64.const -5630502706635572658
    i64.mul
    local.set $r6
    local.get $r1
    i64.const -813824593
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r0
    local.get $r5
    i64.const 813086184
    i64.add
    local.set $r5
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r7
    i64.sub
    local.set $r1
    local.get $r4
    local.get $r4
    call 2
    local.set $r4
    local.get $r3
    i64.const -5075792012455479054
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r5
    i64.mul
    local.set $r0
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r7
    i64.const 13
    i64.rotr
    local.set $r7
    local.get $r1
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r2
    i64.const 1432550528
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r1
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r1
    i64.const 57
    i64.rotr
    local.set $r1
    local.get $r6
    i64.const -541105637
    i64.xor
    local.set $r6
    local.get $r3
    i64.const 27
    i64.rotr
    local.set $r3
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r0
    i64.const 32
    i64.rotr
    local.set $r0
    local.get $r4
    i64.const 1109641840
    i64.xor
    local.set $r4
    local.get $r4
    local.get $r5
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r7
    i64.const 340736478
    i64.xor
    local.set $r7
    local.get $r0
    local.get $r3
    i64.sub
    local.set $r0
    local.get $r2
    local.get $r5
    i64.xor
    local.set $r2
    local.get $r3
    local.get $r4
    call 1
    local.set $r3
    local.get $r0
    i64.const -6925397922871615202
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r2
    i64.const 51
    i64.rotr
    local.set $r2
    local.get $r2
    local.get $r1
    i64.sub
    local.set $r2
    local.get $r5
    i64.const -738248989
    i64.xor
    local.set $r5
    local.get $r6
    local.get $r1
    i64.xor
    local.set $r6
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r5
    i64.const 1246464930
    i64.add
    local.set $r5
    local.get $r6
    local.get $r2
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r1
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r5
    call 1
    local.set $r1
    local.get $r4
    i64.const -8698127171428200739
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r2
    i64.const 26
    i64.rotr
    local.set $r2
    local.get $r3
    i64.const 51
    i64.rotr
    local.set $r3
    local.get $r2
    i64.const 657281678
    i64.add
    local.set $r2
    local.get $r5
    i64.const 29
    i64.rotr
    local.set $r5
    local.get $r2
    local.get $r7
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r0
    i64.const 957145946
    i64.add
    local.set $r0
    local.get $r7
    local.get $r5
    i64.const 3
    i64.shl
    i64.add
    local.set $r7
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r4
    local.get $r0
    i64.mul
    local.set $r4
    local.get $r0
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r1
    local.get $r3
    i64.xor
    local.set $r1
    local.get $r1
    i64.const -936809775
    i64.xor
    local.set $r1
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r3
    local.get $r0
    i64.xor
    local.set $r3
    local.get $r0
    i64.const 62
    i64.rotr
    local.set $r0
    local.get $r2
    i64.const 128805254
    i64.add
    local.set $r2
    local.get $r3
    local.get $r2
    i64.sub
    local.set $r3
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r0
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r0
    i64.mul
    local.set $r3
    local.get $r6
    i64.const 18
    i64.rotr
    local.set $r6
    local.get $r2
    i64.const 17
    i64.rotr
    local.set $r2
    local.get $r6
    i64.const 827376234
    i64.xor
    local.set $r6
    local.get $r5
    i64.const 12
    i64.rotr
    local.set $r5
    local.get $r2
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    i64.const -82915741
    i64.add
    local.set $r4
    local.get $r1
    local.get $r0
    i64.sub
    local.set $r1
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r6
    i64.const 9
    i64.rotr
    local.set $r6
    local.get $r4
    i64.const 12
    i64.rotr
    local.set $r4
    local.get $r7
    i64.const -1844414647
    i64.add
    local.set $r7
    local.get $r3
    i64.const 53
    i64.rotr
    local.set $r3
    local.get $r0
    i64.const -451433456
    i64.add
    local.set $r0
    local.get $r5
    local.get $r3
    i64.sub
    local.set $r5
    local.get $r6
    local.get $r3
    i64.sub
    local.set $r6
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r2
    i64.const 56
    i64.rotr
    local.set $r2
    local.get $r1
    local.get $r2
    i64.sub
    local.set $r1
    local.get $r2
    i64.const 1612419779
    i64.xor
    local.set $r2
    local.get $r2
    local.get $r0
    i64.xor
    local.set $r2
    local.get $r4
    local.get $r4
    call 1
    local.set $r4
    local.get $r1
    i64.const -7562047650080394164
    i64.mul
    local.set $r1
    local.get $r0
    i64.const 482410138
    i64.add
    local.set $r0
    local.get $r3
    local.get $r5
    i64.xor
    local.set $r3
    local.get $r5
    i64.const -2119958710
    i64.xor
    local.set $r5
    local.get $r6
    local.get $r5
    i64.sub
    local.set $r6
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r3
    local.get $r2
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r0
    i64.const 33
    i64.rotr
    local.set $r0
    local.get $r5
    i64.const -656601495
    i64.add
    local.set $r5
    local.get $r2
    local.get $r2
    call 1
    local.set $r2
    local.get $r3
    i64.const -8914809069036798286
    i64.mul
    local.set $r3
    local.get $r1
    i64.const 1097179169
    i64.add
    local.set $r1
    local.get $r0
    local.get $r7
    call 2
    local.set $r0
    local.get $r6
    i64.const -8657674235688901926
    i64.mul
    local.set $r6
    local.get $r7
    i64.const -1460127470
    i64.add
    local.set $r7
    local.get $r1
    i64.const 58
    i64.rotr
    local.set $r1
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r1
    i64.const -305148841
    i64.add
    local.set $r1
    local.get $r4
    local.get $r1
    i64.sub
    local.set $r4
    local.get $r7
    local.get $r1
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r7
    i64.const 47
    i64.rotr
    local.set $r7
    local.get $r4
    i64.const 1214038139
    i64.add
    local.set $r4
    local.get $r5
    local.get $r7
    call 1
    local.set $r5
    local.get $r0
    i64.const -9144938782005566826
    i64.mul
    local.set $r0
    local.get $r4
    i64.const -585801700
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r7
    i64.xor
    local.set $r6
    local.get $r4
    i64.const 44
    i64.rotr
    local.set $r4
    local.get $r6
    i64.const 801897725
    i64.xor
    local.set $r6
    local.get $r1
    i64.const 60
    i64.rotr
    local.set $r1
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r0
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r2
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r7
    local.get $r2
    i64.sub
    local.set $r7
    local.get $r7
    i64.const -1683922621
    i64.add
    local.set $r7
    local.get $r3
    local.get $r2
    i64.xor
    local.set $r3
    local.get $r2
    local.get $r7
    call 2
    local.set $r2
    local.get $r3
    i64.const -7676413464396563122
    i64.mul
    local.set $r3
    local.get $r0
    i64.const -1345447361
    i64.add
    local.set $r0
    local.get $r1
    i64.const 13
    i64.rotr
    local.set $r1
    local.get $r1
    i64.const 1598397648
    i64.add
    local.set $r1
    local.get $r5
    local.get $r0
    i64.sub
    local.set $r5
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r7
    local.get $r6
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r5
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r6
    local.get $r5
    i64.const 3
    i64.shl
    i64.add
    local.set $r6
    local.get $r5
    i64.const 16
    i64.rotr
    local.set $r5
    local.get $r4
    i64.const 955338386
    i64.xor
    local.set $r4
    local.get $r2
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r5
    local.get $r2
    i64.sub
    local.set $r5
    local.get $r3
    i64.const -1143397133
    i64.xor
    local.set $r3
    local.get $r2
    local.get $r1
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r5
    call 1
    local.set $r6
    local.get $r0
    i64.const -7582231891740727374
    i64.mul
    local.set $r0
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r7
    i64.mul
    local.set $r3
    local.get $item_number
    i64.const 4194303
    i64.and
    i32.wrap_i64
    i32.const 6
    i32.shl
    i32.const 51872
    i32.add
    local.set $mixblock_ptr
    local.get $mixblock_ptr
    i64.load align=4
    local.get $r0
    i64.xor
    local.set $r0
    local.get $mixblock_ptr
    i64.load offset=8 align=4
    local.get $r1
    i64.xor
    local.set $r1
    local.get $mixblock_ptr
    i64.load offset=16 align=4
    local.get $r2
    i64.xor
    local.set $r2
    local.get $mixblock_ptr
    i64.load offset=24 align=4
    local.get $r3
    i64.xor
    local.set $r3
    local.get $mixblock_ptr
    i64.load offset=32 align=4
    local.get $r4
    i64.xor
    local.set $r4
    local.get $mixblock_ptr
    i64.load offset=40 align=4
    local.get $r5
    i64.xor
    local.set $r5
    local.get $mixblock_ptr
    i64.load offset=48 align=4
    local.get $r6
    i64.xor
    local.set $r6
    local.get $mixblock_ptr
    i64.load offset=56 align=4
    local.get $r7
    i64.xor
    local.set $r7
    local.get $r5
    local.set $item_number
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r2
    i64.const 13
    i64.rotr
    local.set $r2
    local.get $r4
    local.get $r0
    i64.sub
    local.set $r4
    local.get $r0
    i64.const 266234504
    i64.xor
    local.set $r0
    local.get $r0
    local.get $r4
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r5
    i64.xor
    local.set $r2
    local.get $r2
    local.get $r0
    i64.sub
    local.set $r2
    local.get $r7
    i64.const -245175893
    i64.add
    local.set $r7
    local.get $r5
    local.get $r0
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r0
    call 1
    local.set $r4
    local.get $r3
    i64.const -4880474061741338106
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r6
    i64.const 8
    i64.rotr
    local.set $r6
    local.get $r5
    i64.const 36
    i64.rotr
    local.set $r5
    local.get $r1
    i64.const -1891144307
    i64.xor
    local.set $r1
    local.get $r6
    local.get $r5
    i64.xor
    local.set $r6
    local.get $r6
    i64.const 107667912
    i64.xor
    local.set $r6
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r3
    i64.sub
    local.set $r2
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r3
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r0
    local.get $r2
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r1
    i64.const -2002794554
    i64.xor
    local.set $r1
    local.get $r1
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r3
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r7
    i64.const -201749062
    i64.xor
    local.set $r7
    local.get $r2
    local.get $r2
    call 1
    local.set $r2
    local.get $r3
    i64.const -2416623335029470735
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r6
    i64.const 55
    i64.rotr
    local.set $r6
    local.get $r6
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r6
    local.get $r4
    i64.const -1101911705
    i64.xor
    local.set $r4
    local.get $r4
    i64.const 21
    i64.rotr
    local.set $r4
    local.get $r7
    local.get $r6
    i64.xor
    local.set $r7
    local.get $r4
    i64.const -134686281
    i64.xor
    local.set $r4
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r4
    local.get $r5
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r5
    i64.const 3
    i64.shl
    i64.add
    local.set $r7
    local.get $r5
    i64.const 651238082
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r1
    local.get $r0
    i64.sub
    local.set $r1
    local.get $r5
    local.get $r0
    i64.xor
    local.set $r5
    local.get $r3
    i64.const 21
    i64.rotr
    local.set $r3
    local.get $r1
    i64.const -620075083
    i64.xor
    local.set $r1
    local.get $r4
    local.get $r7
    call 1
    local.set $r4
    local.get $r7
    i64.const -2714288458923221265
    i64.mul
    local.set $r7
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r0
    i64.const 21
    i64.rotr
    local.set $r0
    local.get $r3
    i64.const -44828938
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r0
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r3
    local.get $r2
    i64.xor
    local.set $r3
    local.get $r3
    local.get $r2
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r2
    i64.const 1953713061
    i64.add
    local.set $r2
    local.get $r3
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r6
    local.get $r2
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r4
    i64.const 21
    i64.rotr
    local.set $r4
    local.get $r0
    i64.const -1648242517
    i64.add
    local.set $r0
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r5
    local.get $r1
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r4
    call 2
    local.set $r4
    local.get $r1
    i64.const -2306764036953729989
    i64.mul
    local.set $r1
    local.get $r3
    i64.const -1703385891
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r6
    i64.sub
    local.set $r5
    local.get $r6
    local.get $r3
    i64.xor
    local.set $r6
    local.get $r0
    i64.const -1711366936
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r6
    i64.xor
    local.set $r2
    local.get $r7
    local.get $r2
    call 2
    local.set $r7
    local.get $r2
    i64.const -6784297922713462881
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r4
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r0
    local.get $r5
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r4
    i64.const -634162055
    i64.add
    local.set $r4
    local.get $r5
    local.get $r4
    call 2
    local.set $r5
    local.get $r6
    i64.const -4488739769521365706
    i64.mul
    local.set $r6
    local.get $r0
    i64.const 1925297181
    i64.add
    local.set $r0
    local.get $r0
    i64.const 15
    i64.rotr
    local.set $r0
    local.get $r4
    i64.const 29
    i64.rotr
    local.set $r4
    local.get $r2
    i64.const -2121403027
    i64.xor
    local.set $r2
    local.get $r7
    i64.const 16
    i64.rotr
    local.set $r7
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r0
    i64.mul
    local.set $r7
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r3
    local.get $r0
    i64.sub
    local.set $r3
    local.get $r0
    i64.const -1327878021
    i64.add
    local.set $r0
    local.get $r3
    local.get $r1
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r4
    call 2
    local.set $r1
    local.get $r4
    i64.const -6835305953644692498
    i64.mul
    local.set $r4
    local.get $r3
    i64.const 63001895
    i64.add
    local.set $r3
    local.get $r2
    local.get $r6
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r3
    local.get $r0
    i64.xor
    local.set $r3
    local.get $r3
    i64.const 390325069
    i64.add
    local.set $r3
    local.get $r6
    local.get $r0
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r7
    call 1
    local.set $r0
    local.get $r6
    i64.const -4462545985637671809
    i64.mul
    local.set $r6
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r5
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r2
    i64.const 11
    i64.rotr
    local.set $r2
    local.get $r2
    i64.const 1007101829
    i64.xor
    local.set $r2
    local.get $r1
    local.get $r5
    i64.sub
    local.set $r1
    local.get $r7
    i64.const 1171167676
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r2
    i64.sub
    local.set $r1
    local.get $r7
    local.get $r6
    i64.xor
    local.set $r7
    local.get $r5
    local.get $r5
    call 2
    local.set $r5
    local.get $r3
    i64.const -7650103257795138375
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r2
    i64.const 52
    i64.rotr
    local.set $r2
    local.get $r0
    i64.const -218823321
    i64.add
    local.set $r0
    local.get $r2
    local.get $r4
    i64.xor
    local.set $r2
    local.get $r0
    local.get $r2
    i64.xor
    local.set $r0
    local.get $r4
    local.get $r2
    i64.sub
    local.set $r4
    local.get $r6
    i64.const 1281347785
    i64.xor
    local.set $r6
    local.get $r2
    local.get $r7
    i64.sub
    local.set $r2
    local.get $r4
    local.get $r0
    i64.xor
    local.set $r4
    local.get $r7
    local.get $r4
    call 1
    local.set $r7
    local.get $r1
    i64.const -7521474322610354895
    i64.mul
    local.set $r1
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r5
    i64.mul
    local.set $r0
    local.get $r4
    i64.const 19
    i64.rotr
    local.set $r4
    local.get $r5
    local.get $r6
    i64.sub
    local.set $r5
    local.get $r5
    i64.const -1640934559
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r6
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r5
    i64.xor
    local.set $r6
    local.get $r5
    i64.const 42
    i64.rotr
    local.set $r5
    local.get $r4
    i64.const -2025733362
    i64.xor
    local.set $r4
    local.get $r2
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r4
    i64.const 3
    i64.shl
    i64.add
    local.set $r3
    local.get $r5
    local.get $r4
    i64.sub
    local.set $r5
    local.get $r5
    i64.const -1575311509
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r3
    i64.sub
    local.set $r4
    local.get $r5
    local.get $r0
    i64.sub
    local.set $r5
    local.get $r3
    i64.const 207459389
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r5
    i64.sub
    local.set $r2
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r0
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r2
    i64.const 56
    i64.rotr
    local.set $r2
    local.get $r6
    i64.const 56
    i64.rotr
    local.set $r6
    local.get $r2
    i64.const 687259013
    i64.add
    local.set $r2
    local.get $r6
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r6
    local.get $r1
    i64.const 1703843149
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r2
    i64.sub
    local.set $r7
    local.get $r2
    local.get $r0
    i64.sub
    local.set $r2
    local.get $r4
    local.get $r1
    i64.sub
    local.set $r4
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r0
    i64.const 2
    i64.rotr
    local.set $r0
    local.get $r6
    i64.const 12
    i64.rotr
    local.set $r6
    local.get $r2
    i64.const -305016839
    i64.xor
    local.set $r2
    local.get $r3
    local.get $r5
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r5
    i64.const 17
    i64.rotr
    local.set $r5
    local.get $r0
    i64.const -1965369541
    i64.add
    local.set $r0
    local.get $r2
    i64.const 19
    i64.rotr
    local.set $r2
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r7
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r5
    i64.const 2019459631
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r0
    i64.sub
    local.set $r4
    local.get $r5
    local.get $r1
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r6
    i64.sub
    local.set $r7
    local.get $r5
    i64.const 1414048345
    i64.add
    local.set $r5
    local.get $r4
    local.get $r1
    i64.sub
    local.set $r4
    local.get $r0
    local.get $r4
    i64.xor
    local.set $r0
    local.get $r7
    local.get $r6
    i64.xor
    local.set $r7
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r1
    local.get $r3
    i64.sub
    local.set $r1
    local.get $r0
    i64.const -243971735
    i64.add
    local.set $r0
    local.get $r3
    local.get $r6
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r1
    i64.xor
    local.set $r6
    local.get $r2
    i64.const -288528292
    i64.add
    local.set $r2
    local.get $r3
    local.get $r1
    i64.xor
    local.set $r3
    local.get $r2
    local.get $r3
    i64.xor
    local.set $r2
    local.get $r1
    local.get $r3
    call 2
    local.set $r1
    local.get $r2
    i64.const -3945879268002991954
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r7
    i64.const 8
    i64.rotr
    local.set $r7
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r3
    i64.const 949702680
    i64.xor
    local.set $r3
    local.get $r3
    local.get $r5
    i64.xor
    local.set $r3
    local.get $r4
    local.get $r7
    call 2
    local.set $r4
    local.get $r5
    i64.const -2148225039700769335
    i64.mul
    local.set $r5
    local.get $r7
    i64.const 1559073005
    i64.add
    local.set $r7
    local.get $r7
    local.get $r1
    i64.sub
    local.set $r7
    local.get $r1
    i64.const 180251693
    i64.add
    local.set $r1
    local.get $r2
    local.get $r6
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r7
    i64.xor
    local.set $r6
    local.get $r3
    local.get $r3
    call 2
    local.set $r3
    local.get $r4
    i64.const -5891355776131185979
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r7
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r6
    local.get $r1
    i64.const 4
    i64.rotr
    local.set $r1
    local.get $r7
    i64.const 407495194
    i64.add
    local.set $r7
    local.get $r6
    local.get $r7
    i64.sub
    local.set $r6
    local.get $r0
    local.get $r1
    i64.sub
    local.set $r0
    local.get $r1
    i64.const 882147592
    i64.add
    local.set $r1
    local.get $r0
    local.get $r7
    i64.sub
    local.set $r0
    local.get $r4
    local.get $r0
    i64.sub
    local.set $r4
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r2
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    i64.const -447292567
    i64.add
    local.set $r4
    local.get $r5
    local.get $r2
    i64.sub
    local.set $r5
    local.get $r7
    i64.const 46
    i64.rotr
    local.set $r7
    local.get $r7
    i64.const -1057913313
    i64.xor
    local.set $r7
    local.get $r4
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r4
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r1
    i64.const 2
    i64.shl
    i64.add
    local.set $r6
    local.get $r5
    i64.const 10
    i64.rotr
    local.set $r5
    local.get $r0
    i64.const 1912140675
    i64.add
    local.set $r0
    local.get $r1
    local.get $r1
    call 1
    local.set $r1
    local.get $r7
    i64.const -8978562632591703745
    i64.mul
    local.set $r7
    local.get $r6
    i64.const 932387528
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r2
    local.get $r5
    i64.sub
    local.set $r2
    local.get $r2
    i64.const -1372274173
    i64.xor
    local.set $r2
    local.get $r5
    local.get $r3
    i64.sub
    local.set $r5
    local.get $r4
    local.get $r6
    call 1
    local.set $r4
    local.get $r5
    i64.const -6756326672160320874
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r7
    local.get $r3
    i64.sub
    local.set $r7
    local.get $r1
    i64.const -1660885685
    i64.xor
    local.set $r1
    local.get $r1
    local.get $r7
    i64.sub
    local.set $r1
    local.get $r6
    local.get $r3
    call 2
    local.set $r6
    local.get $r7
    i64.const -6220962626709022463
    i64.mul
    local.set $r7
    local.get $r1
    i64.const -628500132
    i64.xor
    local.set $r1
    local.get $r4
    local.get $r3
    i64.sub
    local.set $r4
    local.get $r3
    i64.const 44
    i64.rotr
    local.set $r3
    local.get $r1
    i64.const -122317694
    i64.add
    local.set $r1
    local.get $r4
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r0
    local.get $r2
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r3
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r2
    i64.const 1373896222
    i64.add
    local.set $r2
    local.get $r4
    i64.const 44
    i64.rotr
    local.set $r4
    local.get $r6
    local.get $r2
    i64.sub
    local.set $r6
    local.get $r4
    i64.const 908045469
    i64.add
    local.set $r4
    local.get $r6
    local.get $r5
    i64.xor
    local.set $r6
    local.get $r2
    local.get $r1
    call 2
    local.set $r2
    local.get $r5
    i64.const -8900841803117164864
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r1
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r4
    local.get $r1
    i64.xor
    local.set $r4
    local.get $r7
    i64.const 984218791
    i64.xor
    local.set $r7
    local.get $r4
    local.get $r7
    i64.sub
    local.set $r4
    local.get $r1
    local.get $r4
    call 1
    local.set $r1
    local.get $r2
    i64.const -7877306812684349053
    i64.mul
    local.set $r2
    local.get $r3
    i64.const -1422702421
    i64.add
    local.set $r3
    local.get $r3
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r4
    i64.const 1162304200
    i64.add
    local.set $r4
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r7
    local.get $r5
    i64.xor
    local.set $r7
    local.get $r3
    local.get $r6
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r1
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r6
    i64.const 50
    i64.rotr
    local.set $r6
    local.get $r7
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r0
    i64.const -2088628828
    i64.add
    local.set $r0
    local.get $r4
    local.get $r5
    call 2
    local.set $r4
    local.get $r5
    i64.const -2397866934521890797
    i64.mul
    local.set $r5
    local.get $r7
    i64.const -1005517735
    i64.add
    local.set $r7
    local.get $r2
    i64.const 9
    i64.rotr
    local.set $r2
    local.get $r6
    local.get $r0
    i64.const 3
    i64.shl
    i64.add
    local.set $r6
    local.get $r2
    i64.const -1899603118
    i64.add
    local.set $r2
    local.get $r0
    local.get $r2
    call 2
    local.set $r0
    local.get $r1
    i64.const -8517421894454300236
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r3
    i64.const 36
    i64.rotr
    local.set $r3
    local.get $r2
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r3
    i64.const 751041264
    i64.xor
    local.set $r3
    local.get $r4
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r4
    local.get $r3
    local.get $r2
    i64.xor
    local.set $r3
    local.get $r2
    i64.const -156257917
    i64.add
    local.set $r2
    local.get $r3
    local.get $r5
    i64.sub
    local.set $r3
    local.get $r5
    local.get $r2
    call 1
    local.set $r5
    local.get $r2
    i64.const -6507953866622794076
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r3
    local.get $r0
    i64.xor
    local.set $r3
    local.get $r7
    i64.const 1118196812
    i64.add
    local.set $r7
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r6
    local.get $r7
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r3
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r6
    i64.const 1716340046
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r7
    i64.const 57
    i64.rotr
    local.set $r7
    local.get $r1
    local.get $r2
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r7
    i64.const -1460044121
    i64.add
    local.set $r7
    local.get $r2
    i64.const 42
    i64.rotr
    local.set $r2
    local.get $r1
    i64.const 61
    i64.rotr
    local.set $r1
    local.get $r5
    i64.const -2084673432
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r5
    i64.const 54
    i64.rotr
    local.set $r5
    local.get $r0
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r5
    i64.const 1726658182
    i64.xor
    local.set $r5
    local.get $r3
    i64.const 27
    i64.rotr
    local.set $r3
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r2
    i64.const 1572829303
    i64.xor
    local.set $r2
    local.get $r5
    local.get $r6
    i64.sub
    local.set $r5
    local.get $r6
    local.get $r3
    call 2
    local.set $r6
    local.get $r5
    i64.const -7144621339319766126
    i64.mul
    local.set $r5
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r4
    i64.const 36
    i64.rotr
    local.set $r4
    local.get $r1
    i64.const 46
    i64.rotr
    local.set $r1
    local.get $r7
    i64.const -783231864
    i64.xor
    local.set $r7
    local.get $r2
    i64.const 55
    i64.rotr
    local.set $r2
    local.get $r7
    i64.const 5
    i64.rotr
    local.set $r7
    local.get $r1
    i64.const -730521941
    i64.add
    local.set $r1
    local.get $r0
    i64.const 59
    i64.rotr
    local.set $r0
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r4
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r6
    local.get $r4
    i64.sub
    local.set $r6
    local.get $r6
    i64.const 1442169298
    i64.xor
    local.set $r6
    local.get $r2
    local.get $r4
    i64.sub
    local.set $r2
    local.get $r4
    local.get $r4
    call 2
    local.set $r4
    local.get $r5
    i64.const -373991428240113885
    i64.mul
    local.set $r5
    local.get $r7
    i64.const 294095562
    i64.xor
    local.set $r7
    local.get $r0
    local.get $r6
    call 1
    local.set $r0
    local.get $r1
    i64.const -4394359307501562341
    i64.mul
    local.set $r1
    local.get $r6
    i64.const 1419394900
    i64.add
    local.set $r6
    local.get $r2
    local.get $r5
    call 1
    local.set $r2
    local.get $r7
    i64.const -8966893923358161425
    i64.mul
    local.set $r7
    local.get $r6
    i64.const -1622571845
    i64.xor
    local.set $r6
    local.get $r4
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r6
    local.get $r5
    i64.sub
    local.set $r6
    local.get $r3
    i64.const -1230645453
    i64.add
    local.set $r3
    local.get $r6
    local.get $r5
    i64.xor
    local.set $r6
    local.get $r5
    local.get $r5
    call 2
    local.set $r5
    local.get $r3
    i64.const -2674080379922501074
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r1
    i64.const 54
    i64.rotr
    local.set $r1
    local.get $r2
    local.get $r6
    i64.sub
    local.set $r2
    local.get $r6
    i64.const -1161036806
    i64.add
    local.set $r6
    local.get $r0
    local.get $r1
    i64.sub
    local.set $r0
    local.get $r7
    local.get $r2
    i64.sub
    local.set $r7
    local.get $r6
    i64.const 62
    i64.rotr
    local.set $r6
    local.get $r1
    i64.const 473084805
    i64.xor
    local.set $r1
    local.get $r2
    local.get $r0
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r6
    local.get $r2
    i64.mul
    local.set $r6
    local.get $r0
    i64.const 19
    i64.rotr
    local.set $r0
    local.get $r2
    i64.const -1796352712
    i64.xor
    local.set $r2
    local.get $r2
    local.get $r3
    i64.sub
    local.set $r2
    local.get $r3
    local.get $r0
    i64.sub
    local.set $r3
    local.get $r2
    local.get $r3
    i64.xor
    local.set $r2
    local.get $r1
    local.get $r4
    i64.sub
    local.set $r1
    local.get $r4
    i64.const -1725946531
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r5
    i64.sub
    local.set $r3
    local.get $r0
    local.get $r0
    call 1
    local.set $r0
    local.get $r5
    i64.const -8473504966267442785
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r3
    i64.const 33
    i64.rotr
    local.set $r3
    local.get $r6
    i64.const 30
    i64.rotr
    local.set $r6
    local.get $r2
    i64.const 1224946731
    i64.xor
    local.set $r2
    local.get $r2
    local.get $r7
    i64.xor
    local.set $r2
    local.get $r7
    i64.const 38
    i64.rotr
    local.set $r7
    local.get $r7
    i64.const 348363238
    i64.add
    local.set $r7
    local.get $r3
    local.get $r2
    call 2
    local.set $r3
    local.get $r7
    i64.const -8354333542878587320
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r5
    i64.const 42
    i64.rotr
    local.set $r5
    local.get $r5
    i64.const 96842857
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r1
    local.get $r5
    i64.sub
    local.set $r1
    local.get $r4
    local.get $r5
    i64.xor
    local.set $r4
    local.get $r5
    local.get $r1
    i64.xor
    local.set $r5
    local.get $r4
    i64.const -943365649
    i64.xor
    local.set $r4
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r6
    local.get $r3
    call 2
    local.set $r6
    local.get $r1
    i64.const -6894227515767675528
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r2
    i64.const 371366009
    i64.xor
    local.set $r2
    local.get $r0
    local.get $r5
    i64.sub
    local.set $r0
    local.get $r2
    local.get $r0
    i64.sub
    local.set $r2
    local.get $r3
    local.get $r2
    call 2
    local.set $r3
    local.get $r5
    i64.const -1637024054989072878
    i64.mul
    local.set $r5
    local.get $r2
    i64.const 980168437
    i64.add
    local.set $r2
    local.get $r6
    i64.const 19
    i64.rotr
    local.set $r6
    local.get $r2
    i64.const 439782150
    i64.xor
    local.set $r2
    local.get $r0
    local.get $r4
    i64.sub
    local.set $r0
    local.get $r1
    local.get $r4
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r6
    i64.sub
    local.set $r7
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r5
    i64.mul
    local.set $r0
    local.get $r4
    i64.const 26
    i64.rotr
    local.set $r4
    local.get $r7
    local.get $r2
    i64.xor
    local.set $r7
    local.get $r5
    i64.const 1565543740
    i64.xor
    local.set $r5
    local.get $r3
    local.get $r7
    i64.xor
    local.set $r3
    local.get $r3
    local.get $r5
    i64.xor
    local.set $r3
    local.get $r7
    i64.const -894779955
    i64.xor
    local.set $r7
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r3
    i64.xor
    local.set $r7
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $item_number
    i64.const 4194303
    i64.and
    i32.wrap_i64
    i32.const 6
    i32.shl
    i32.const 51872
    i32.add
    local.set $mixblock_ptr
    local.get $mixblock_ptr
    i64.load align=4
    local.get $r0
    i64.xor
    local.set $r0
    local.get $mixblock_ptr
    i64.load offset=8 align=4
    local.get $r1
    i64.xor
    local.set $r1
    local.get $mixblock_ptr
    i64.load offset=16 align=4
    local.get $r2
    i64.xor
    local.set $r2
    local.get $mixblock_ptr
    i64.load offset=24 align=4
    local.get $r3
    i64.xor
    local.set $r3
    local.get $mixblock_ptr
    i64.load offset=32 align=4
    local.get $r4
    i64.xor
    local.set $r4
    local.get $mixblock_ptr
    i64.load offset=40 align=4
    local.get $r5
    i64.xor
    local.set $r5
    local.get $mixblock_ptr
    i64.load offset=48 align=4
    local.get $r6
    i64.xor
    local.set $r6
    local.get $mixblock_ptr
    i64.load offset=56 align=4
    local.get $r7
    i64.xor
    local.set $r7
    local.get $r3
    local.set $item_number
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r5
    i64.const 9
    i64.rotr
    local.set $r5
    local.get $r5
    local.get $r1
    i64.sub
    local.set $r5
    local.get $r6
    i64.const -354047911
    i64.xor
    local.set $r6
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r6
    local.get $r2
    i64.xor
    local.set $r6
    local.get $r2
    local.get $r1
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r6
    i64.const 2129323049
    i64.add
    local.set $r6
    local.get $r1
    local.get $r7
    i64.sub
    local.set $r1
    local.get $r5
    local.get $r3
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r3
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r7
    i64.const -140010500
    i64.add
    local.set $r7
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r2
    local.get $r0
    i64.sub
    local.set $r2
    local.get $r0
    local.get $r0
    call 1
    local.set $r0
    local.get $r3
    i64.const -2258077031674981771
    i64.mul
    local.set $r3
    local.get $r7
    i64.const -726030866
    i64.xor
    local.set $r7
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r4
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r2
    i64.const 1057129534
    i64.add
    local.set $r2
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r0
    local.get $r7
    i64.mul
    local.set $r0
    local.get $r1
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r1
    i64.const 63
    i64.rotr
    local.set $r1
    local.get $r7
    i64.const 1799594909
    i64.xor
    local.set $r7
    local.get $r4
    local.get $r1
    call 2
    local.set $r4
    local.get $r5
    i64.const -5419443798705704800
    i64.mul
    local.set $r5
    local.get $r3
    i64.const 56732827
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r0
    call 2
    local.set $r6
    local.get $r0
    i64.const -5047459877625890726
    i64.mul
    local.set $r0
    local.get $r2
    i64.const -1302660298
    i64.xor
    local.set $r2
    local.get $r1
    local.get $r5
    call 1
    local.set $r1
    local.get $r7
    i64.const -7069705717147037238
    i64.mul
    local.set $r7
    local.get $r3
    i64.const -2111474175
    i64.add
    local.set $r3
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r3
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r3
    i64.const -1797389654
    i64.xor
    local.set $r3
    local.get $r3
    i64.const 46
    i64.rotr
    local.set $r3
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r5
    i64.const 54
    i64.rotr
    local.set $r5
    local.get $r3
    local.get $r0
    i64.sub
    local.set $r3
    local.get $r5
    i64.const -1527840663
    i64.xor
    local.set $r5
    local.get $r3
    local.get $r2
    i64.xor
    local.set $r3
    local.get $r2
    local.get $r0
    i64.xor
    local.set $r2
    local.get $r0
    i64.const 1495078373
    i64.add
    local.set $r0
    local.get $r3
    local.get $r1
    i64.sub
    local.set $r3
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r2
    call 2
    local.set $r5
    local.get $r1
    i64.const -9152080173224627162
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r7
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r7
    i64.const 39
    i64.rotr
    local.set $r7
    local.get $r3
    i64.const -266472481
    i64.add
    local.set $r3
    local.get $r6
    i64.const 3
    i64.rotr
    local.set $r6
    local.get $r6
    i64.const -486387744
    i64.xor
    local.set $r6
    local.get $r3
    local.get $r7
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r4
    local.get $r5
    i64.xor
    local.set $r4
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r1
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r5
    i64.const 53
    i64.rotr
    local.set $r5
    local.get $r2
    i64.const 95275042
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r6
    call 1
    local.set $r6
    local.get $r7
    i64.const -8399094626464322132
    i64.mul
    local.set $r7
    local.get $r4
    i64.const -1251284808
    i64.add
    local.set $r4
    local.get $r0
    local.get $r2
    call 2
    local.set $r0
    local.get $r1
    i64.const -3727863481610986241
    i64.mul
    local.set $r1
    local.get $r5
    i64.const -791045906
    i64.add
    local.set $r5
    local.get $r2
    local.get $r5
    call 1
    local.set $r2
    local.get $r5
    i64.const -5209865689877505373
    i64.mul
    local.set $r5
    local.get $r3
    i64.const 1926281904
    i64.xor
    local.set $r3
    local.get $r4
    local.get $r0
    call 2
    local.set $r4
    local.get $r6
    i64.const -5479656531970418694
    i64.mul
    local.set $r6
    local.get $r7
    i64.const -1451029669
    i64.xor
    local.set $r7
    local.get $r7
    local.get $r3
    i64.sub
    local.set $r7
    local.get $r3
    i64.const -1302822490
    i64.add
    local.set $r3
    local.get $r1
    local.get $r0
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r1
    i64.sub
    local.set $r0
    local.get $r7
    local.get $r1
    call 1
    local.set $r7
    local.get $r3
    i64.const -4141970567570716809
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r2
    i64.const 8
    i64.rotr
    local.set $r2
    local.get $r2
    local.get $r5
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r5
    i64.const -1890839728
    i64.add
    local.set $r5
    local.get $r6
    i64.const 38
    i64.rotr
    local.set $r6
    local.get $r4
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r2
    i64.const -387643657
    i64.add
    local.set $r2
    local.get $r4
    local.get $r6
    i64.const 1
    i64.shl
    i64.add
    local.set $r4
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r4
    i64.const 62
    i64.rotr
    local.set $r4
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r0
    i64.const 1669292824
    i64.add
    local.set $r0
    local.get $r7
    local.get $r5
    i64.sub
    local.set $r7
    local.get $r4
    local.get $r5
    call 1
    local.set $r4
    local.get $r7
    i64.const -5358555356723957959
    i64.mul
    local.set $r7
    local.get $r1
    i64.const 1140516188
    i64.add
    local.set $r1
    local.get $r5
    local.get $r1
    call 1
    local.set $r5
    local.get $r3
    i64.const -7761920391752608753
    i64.mul
    local.set $r3
    local.get $r2
    i64.const 236071742
    i64.add
    local.set $r2
    local.get $r1
    local.get $r0
    i64.sub
    local.set $r1
    local.get $r1
    i64.const -1219147279
    i64.add
    local.set $r1
    local.get $r0
    local.get $r1
    i64.sub
    local.set $r0
    local.get $r6
    local.get $r2
    i64.xor
    local.set $r6
    local.get $r2
    local.get $r0
    call 2
    local.set $r2
    local.get $r4
    i64.const -4846431098262518085
    i64.mul
    local.set $r4
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r7
    i64.const 103392305
    i64.xor
    local.set $r7
    local.get $r3
    local.get $r0
    i64.sub
    local.set $r3
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r0
    local.get $r7
    call 2
    local.set $r0
    local.get $r1
    i64.const -6526395029919263430
    i64.mul
    local.set $r1
    local.get $r5
    i64.const 965893513
    i64.xor
    local.set $r5
    local.get $r7
    i64.const 5
    i64.rotr
    local.set $r7
    local.get $r3
    local.get $r4
    i64.const 3
    i64.shl
    i64.add
    local.set $r3
    local.get $r4
    i64.const 393021079
    i64.add
    local.set $r4
    local.get $r3
    i64.const 24
    i64.rotr
    local.set $r3
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r7
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r2
    local.get $r7
    i64.sub
    local.set $r2
    local.get $r6
    i64.const 1649312206
    i64.xor
    local.set $r6
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r6
    i64.sub
    local.set $r2
    local.get $r2
    i64.const 23
    i64.rotr
    local.set $r2
    local.get $r0
    i64.const -1338063576
    i64.xor
    local.set $r0
    local.get $r5
    local.get $r7
    i64.xor
    local.set $r5
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r5
    i64.const 16
    i64.rotr
    local.set $r5
    local.get $r3
    i64.const 1333785536
    i64.add
    local.set $r3
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r7
    i64.const 1734928343
    i64.add
    local.set $r7
    local.get $r3
    local.get $r5
    i64.xor
    local.set $r3
    local.get $r3
    local.get $r7
    i64.xor
    local.set $r3
    local.get $r4
    local.get $r6
    call 1
    local.set $r4
    local.get $r0
    i64.const -2980801705640912527
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r5
    local.get $r3
    i64.mul
    local.set $r5
    local.get $r1
    i64.const 20
    i64.rotr
    local.set $r1
    local.get $r2
    i64.const 49817648
    i64.add
    local.set $r2
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r1
    local.get $r6
    i64.sub
    local.set $r1
    local.get $r2
    local.get $r6
    i64.sub
    local.set $r2
    local.get $r6
    local.get $r3
    i64.sub
    local.set $r6
    local.get $r3
    i64.const -1012439919
    i64.add
    local.set $r3
    local.get $r2
    local.get $r1
    i64.xor
    local.set $r2
    local.get $r7
    local.get $r2
    call 2
    local.set $r7
    local.get $r1
    i64.const -2985069746157337100
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r5
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r0
    i64.const 1583190262
    i64.xor
    local.set $r0
    local.get $r5
    local.get $r4
    i64.sub
    local.set $r5
    local.get $r6
    local.get $r0
    call 2
    local.set $r6
    local.get $r2
    i64.const -8885228260803114340
    i64.mul
    local.set $r2
    local.get $r4
    i64.const -1234175431
    i64.xor
    local.set $r4
    local.get $r0
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r0
    i64.const 27
    i64.rotr
    local.set $r0
    local.get $r5
    i64.const 2054162786
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r1
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r1
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r5
    i64.const -1488466308
    i64.add
    local.set $r5
    local.get $r4
    local.get $r1
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r4
    call 1
    local.set $r3
    local.get $r5
    i64.const -8107129321376223785
    i64.mul
    local.set $r5
    local.get $r4
    i64.const -303434554
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r4
    call 1
    local.set $r1
    local.get $r7
    i64.const -6053268348507257997
    i64.mul
    local.set $r7
    local.get $r0
    i64.const 537644036
    i64.xor
    local.set $r0
    local.get $r4
    local.get $r2
    i64.sub
    local.set $r4
    local.get $r0
    i64.const 18
    i64.rotr
    local.set $r0
    local.get $r4
    i64.const 861761978
    i64.add
    local.set $r4
    local.get $r4
    local.get $r5
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r0
    i64.const 49
    i64.rotr
    local.set $r0
    local.get $r6
    i64.const -210813967
    i64.add
    local.set $r6
    local.get $r5
    local.get $r7
    call 1
    local.set $r5
    local.get $r6
    i64.const -1826671249522896179
    i64.mul
    local.set $r6
    local.get $r1
    i64.const 2006703495
    i64.add
    local.set $r1
    local.get $r0
    local.get $r1
    i64.xor
    local.set $r0
    local.get $r1
    i64.const 25
    i64.rotr
    local.set $r1
    local.get $r4
    i64.const 1538528704
    i64.add
    local.set $r4
    local.get $r7
    local.get $r4
    call 1
    local.set $r7
    local.get $r2
    i64.const -6503529263587437884
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r0
    local.get $r3
    i64.xor
    local.set $r0
    local.get $r0
    i64.const -1570606716
    i64.add
    local.set $r0
    local.get $r3
    local.get $r5
    i64.sub
    local.set $r3
    local.get $r5
    local.get $r7
    call 1
    local.set $r5
    local.get $r7
    i64.const -8425714480783932706
    i64.mul
    local.set $r7
    local.get $r1
    i64.const -1919962664
    i64.xor
    local.set $r1
    local.get $r2
    i64.const 44
    i64.rotr
    local.set $r2
    local.get $r4
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r1
    i64.const -230172067
    i64.add
    local.set $r1
    local.get $r6
    local.get $r2
    i64.xor
    local.set $r6
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r3
    i64.const 36
    i64.rotr
    local.set $r3
    local.get $r2
    local.get $r1
    i64.sub
    local.set $r2
    local.get $r7
    i64.const -496641062
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r2
    local.get $r3
    i64.xor
    local.set $r2
    local.get $r7
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r5
    i64.const 407132640
    i64.add
    local.set $r5
    local.get $r3
    local.get $r0
    call 2
    local.set $r3
    local.get $r4
    i64.const -2417623645419838714
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r6
    i64.const 56
    i64.rotr
    local.set $r6
    local.get $r1
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r0
    i64.const 1434343542
    i64.add
    local.set $r0
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r6
    local.get $r7
    i64.xor
    local.set $r6
    local.get $r1
    i64.const 1922032875
    i64.add
    local.set $r1
    local.get $r6
    local.get $r0
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r5
    call 2
    local.set $r7
    local.get $r1
    i64.const -6264809258158765778
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r6
    i64.const 45
    i64.rotr
    local.set $r6
    local.get $r4
    i64.const 19
    i64.rotr
    local.set $r4
    local.get $r6
    i64.const -1638368207
    i64.add
    local.set $r6
    local.get $r6
    i64.const 5
    i64.rotr
    local.set $r6
    local.get $r5
    i64.const 1621740587
    i64.add
    local.set $r5
    local.get $r4
    local.get $r0
    i64.sub
    local.set $r4
    local.get $r6
    local.get $r5
    i64.sub
    local.set $r6
    local.get $r2
    local.get $r5
    i64.xor
    local.set $r2
    local.get $r5
    local.get $r7
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r2
    i64.const 22
    i64.rotr
    local.set $r2
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $r3
    i64.const -1756564749
    i64.xor
    local.set $r3
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r7
    local.get $r1
    i64.xor
    local.set $r7
    local.get $r0
    local.get $r3
    i64.const 0
    i64.shl
    i64.add
    local.set $r0
    local.get $r5
    i64.const -1927649905
    i64.add
    local.set $r5
    local.get $r3
    i64.const 57
    i64.rotr
    local.set $r3
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r7
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r6
    i64.const 1
    i64.shl
    i64.add
    local.set $r1
    local.get $r6
    i64.const 17
    i64.rotr
    local.set $r6
    local.get $r7
    i64.const 1178231518
    i64.add
    local.set $r7
    local.get $r6
    local.get $r4
    i64.xor
    local.set $r6
    local.get $r5
    i64.const 24
    i64.rotr
    local.set $r5
    local.get $r2
    i64.const 1426253998
    i64.xor
    local.set $r2
    local.get $r4
    i64.const 54
    i64.rotr
    local.set $r4
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r4
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r0
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r6
    i64.const 2131304942
    i64.add
    local.set $r6
    local.get $r1
    local.get $r4
    i64.sub
    local.set $r1
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r0
    i64.const 35
    i64.rotr
    local.set $r0
    local.get $r4
    i64.const 1753425444
    i64.add
    local.set $r4
    local.get $r2
    i64.const 28
    i64.rotr
    local.set $r2
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r6
    local.get $r3
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r3
    local.get $r5
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r7
    i64.const 1
    i64.rotr
    local.set $r7
    local.get $r5
    i64.const 2130230406
    i64.add
    local.set $r5
    local.get $r0
    local.get $r0
    call 2
    local.set $r0
    local.get $r4
    i64.const -4381736130496394213
    i64.mul
    local.set $r4
    local.get $r2
    i64.const 1684455586
    i64.xor
    local.set $r2
    local.get $r7
    local.get $r3
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r3
    i64.const 5
    i64.rotr
    local.set $r3
    local.get $r1
    i64.const -1091840172
    i64.add
    local.set $r1
    local.get $r5
    local.get $r3
    call 1
    local.set $r5
    local.get $r2
    i64.const -8129215638798027605
    i64.mul
    local.set $r2
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r1
    i64.const 29
    i64.rotr
    local.set $r1
    local.get $r6
    i64.const -205434862
    i64.add
    local.set $r6
    local.get $r4
    local.get $r1
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r1
    i64.sub
    local.set $r6
    local.get $r3
    local.get $r7
    call 2
    local.set $r3
    local.get $r7
    i64.const -7415589805163020094
    i64.mul
    local.set $r7
    local.get $r1
    i64.const -707927968
    i64.xor
    local.set $r1
    local.get $r6
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r5
    i64.const -854747168
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r1
    i64.sub
    local.set $r2
    local.get $r6
    local.get $r4
    i64.sub
    local.set $r6
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r4
    local.get $r0
    i64.const 27
    i64.rotr
    local.set $r0
    local.get $r0
    i64.const -1559741519
    i64.add
    local.set $r0
    local.get $r4
    i64.const 28
    i64.rotr
    local.set $r4
    local.get $r5
    i64.const -1123159094
    i64.xor
    local.set $r5
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r0
    call 2
    local.set $r1
    local.get $r6
    i64.const -5073615865157344428
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r0
    i64.mul
    local.set $r4
    local.get $r0
    local.get $r5
    i64.mul
    local.set $r0
    local.get $r2
    i64.const 32
    i64.rotr
    local.set $r2
    local.get $r5
    i64.const 45
    i64.rotr
    local.set $r5
    local.get $r7
    i64.const -886693656
    i64.xor
    local.set $r7
    local.get $r4
    local.get $r3
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r7
    i64.const 8
    i64.rotr
    local.set $r7
    local.get $r3
    i64.const -1757123369
    i64.add
    local.set $r3
    local.get $r4
    local.get $r2
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r5
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r1
    i64.const 54
    i64.rotr
    local.set $r1
    local.get $r6
    i64.const -1558123413
    i64.xor
    local.set $r6
    local.get $r0
    i64.const 24
    i64.rotr
    local.set $r0
    local.get $r0
    local.get $r1
    i64.const 0
    i64.shl
    i64.add
    local.set $r0
    local.get $r3
    i64.const 1420451147
    i64.xor
    local.set $r3
    local.get $r7
    local.get $r5
    i64.sub
    local.set $r7
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r0
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r7
    i64.const 21
    i64.rotr
    local.set $r7
    local.get $r0
    i64.const -911762559
    i64.add
    local.set $r0
    local.get $r0
    local.get $r2
    i64.xor
    local.set $r0
    local.get $r4
    local.get $r7
    i64.sub
    local.set $r4
    local.get $r6
    local.get $r2
    call 2
    local.set $r6
    local.get $r0
    i64.const -4972854924108947260
    i64.mul
    local.set $r0
    local.get $r2
    i64.const 937813480
    i64.add
    local.set $r2
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r2
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r5
    i64.const 895639983
    i64.add
    local.set $r5
    local.get $r1
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r1
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r5
    i64.const 30
    i64.rotr
    local.set $r5
    local.get $r5
    local.get $r7
    i64.xor
    local.set $r5
    local.get $r1
    i64.const -1128162993
    i64.xor
    local.set $r1
    local.get $r1
    local.get $r3
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r5
    i64.const 46
    i64.rotr
    local.set $r5
    local.get $r1
    i64.const -61037007
    i64.add
    local.set $r1
    local.get $r7
    local.get $r3
    i64.sub
    local.set $r7
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r0
    local.get $r7
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r1
    i64.const 5
    i64.rotr
    local.set $r1
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r6
    i64.const 2074576372
    i64.xor
    local.set $r6
    local.get $r4
    local.get $r1
    i64.sub
    local.set $r4
    local.get $r3
    local.get $r1
    call 2
    local.set $r3
    local.get $r4
    i64.const -2190434708809143690
    i64.mul
    local.set $r4
    local.get $r1
    i64.const 174986532
    i64.xor
    local.set $r1
    local.get $r6
    i64.const 38
    i64.rotr
    local.set $r6
    local.get $r2
    local.get $r0
    i64.xor
    local.set $r2
    local.get $r6
    i64.const 1543757691
    i64.add
    local.set $r6
    local.get $r7
    local.get $r5
    i64.xor
    local.set $r7
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r5
    i64.const 37
    i64.rotr
    local.set $r5
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r4
    i64.const -669991946
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r5
    i64.sub
    local.set $r6
    local.get $r3
    local.get $r2
    call 2
    local.set $r3
    local.get $r7
    i64.const -6121995015190183002
    i64.mul
    local.set $r7
    local.get $r0
    i64.const -1567226116
    i64.xor
    local.set $r0
    local.get $r5
    local.get $r1
    call 2
    local.set $r5
    local.get $r0
    i64.const -6843871949398273492
    i64.mul
    local.set $r0
    local.get $r6
    i64.const -2131418832
    i64.xor
    local.set $r6
    local.get $r2
    local.get $r3
    call 2
    local.set $r2
    local.get $r3
    i64.const -4699197160372329602
    i64.mul
    local.set $r3
    local.get $r1
    i64.const -1412992786
    i64.xor
    local.set $r1
    local.get $r6
    local.get $r1
    i64.sub
    local.set $r6
    local.get $r1
    local.get $r4
    i64.const 3
    i64.shl
    i64.add
    local.set $r1
    local.get $r6
    i64.const 1828836668
    i64.add
    local.set $r6
    local.get $r6
    i64.const 55
    i64.rotr
    local.set $r6
    local.get $r5
    local.get $r4
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r1
    i64.const 552084825
    i64.xor
    local.set $r1
    local.get $r3
    local.get $r4
    i64.sub
    local.set $r3
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r4
    local.get $r3
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r0
    i64.const -1976576569
    i64.xor
    local.set $r0
    local.get $r5
    i64.const 35
    i64.rotr
    local.set $r5
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r3
    local.get $r7
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r2
    i64.const 55
    i64.rotr
    local.set $r2
    local.get $r0
    i64.const -742988412
    i64.add
    local.set $r0
    local.get $r7
    local.get $r5
    call 2
    local.set $r7
    local.get $r3
    i64.const -6794526273431950437
    i64.mul
    local.set $r3
    local.get $r4
    i64.const -757787883
    i64.add
    local.set $r4
    local.get $r2
    local.get $r5
    i64.sub
    local.set $r2
    local.get $r1
    i64.const 40
    i64.rotr
    local.set $r1
    local.get $r5
    i64.const 2073520910
    i64.xor
    local.set $r5
    local.get $r4
    i64.const 58
    i64.rotr
    local.set $r4
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r6
    i64.const 40
    i64.rotr
    local.set $r6
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r7
    i64.const 2099568207
    i64.add
    local.set $r7
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $item_number
    i64.const 4194303
    i64.and
    i32.wrap_i64
    i32.const 6
    i32.shl
    i32.const 51872
    i32.add
    local.set $mixblock_ptr
    local.get $mixblock_ptr
    i64.load align=4
    local.get $r0
    i64.xor
    local.set $r0
    local.get $mixblock_ptr
    i64.load offset=8 align=4
    local.get $r1
    i64.xor
    local.set $r1
    local.get $mixblock_ptr
    i64.load offset=16 align=4
    local.get $r2
    i64.xor
    local.set $r2
    local.get $mixblock_ptr
    i64.load offset=24 align=4
    local.get $r3
    i64.xor
    local.set $r3
    local.get $mixblock_ptr
    i64.load offset=32 align=4
    local.get $r4
    i64.xor
    local.set $r4
    local.get $mixblock_ptr
    i64.load offset=40 align=4
    local.get $r5
    i64.xor
    local.set $r5
    local.get $mixblock_ptr
    i64.load offset=48 align=4
    local.get $r6
    i64.xor
    local.set $r6
    local.get $mixblock_ptr
    i64.load offset=56 align=4
    local.get $r7
    i64.xor
    local.set $r7
    local.get $r0
    local.set $item_number
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r3
    i64.const 39
    i64.rotr
    local.set $r3
    local.get $r0
    i64.const 1090882691
    i64.add
    local.set $r0
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r4
    local.get $r1
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r0
    call 1
    local.set $r1
    local.get $r4
    i64.const -4630162083402879719
    i64.mul
    local.set $r4
    local.get $r3
    i64.const -789166834
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r2
    call 2
    local.set $r0
    local.get $r6
    i64.const -7115982305706553712
    i64.mul
    local.set $r6
    local.get $r7
    i64.const 899144076
    i64.add
    local.set $r7
    local.get $r2
    i64.const 51
    i64.rotr
    local.set $r2
    local.get $r3
    i64.const 6
    i64.rotr
    local.set $r3
    local.get $r1
    i64.const -1208778165
    i64.add
    local.set $r1
    local.get $r7
    local.get $r3
    call 1
    local.set $r7
    local.get $r3
    i64.const -4889830508908013532
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r1
    i64.mul
    local.set $r4
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r5
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r2
    i64.const 25
    i64.rotr
    local.set $r2
    local.get $r5
    i64.const 160612343
    i64.add
    local.set $r5
    local.get $r1
    local.get $r1
    call 2
    local.set $r1
    local.get $r4
    i64.const -5640970487050676800
    i64.mul
    local.set $r4
    local.get $r2
    i64.const -1374038790
    i64.add
    local.set $r2
    local.get $r5
    local.get $r6
    i64.sub
    local.set $r5
    local.get $r6
    local.get $r3
    i64.sub
    local.set $r6
    local.get $r2
    i64.const 2063038661
    i64.xor
    local.set $r2
    local.get $r3
    local.get $r6
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r0
    i64.xor
    local.set $r6
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r3
    i64.const 35
    i64.rotr
    local.set $r3
    local.get $r3
    local.get $r0
    i64.xor
    local.set $r3
    local.get $r6
    i64.const -665562742
    i64.add
    local.set $r6
    local.get $r4
    local.get $r0
    i64.sub
    local.set $r4
    local.get $r0
    local.get $r6
    call 2
    local.set $r0
    local.get $r1
    i64.const -3395052262106517021
    i64.mul
    local.set $r1
    local.get $r2
    i64.const -1012416615
    i64.add
    local.set $r2
    local.get $r2
    i64.const 62
    i64.rotr
    local.set $r2
    local.get $r3
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r4
    i64.const -213840311
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r4
    call 1
    local.set $r6
    local.get $r2
    i64.const -4593085793914146125
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r3
    i64.const 2
    i64.shl
    i64.add
    local.set $r7
    local.get $r5
    i64.const 10
    i64.rotr
    local.set $r5
    local.get $r7
    i64.const 1000464735
    i64.add
    local.set $r7
    local.get $r1
    local.get $r3
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r1
    i64.const 2112718011
    i64.add
    local.set $r1
    local.get $r3
    local.get $r7
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r1
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r2
    call 1
    local.set $r7
    local.get $r1
    i64.const -6692107325858719723
    i64.mul
    local.set $r1
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r2
    i64.const 28
    i64.rotr
    local.set $r2
    local.get $r6
    i64.const -2127093339
    i64.add
    local.set $r6
    local.get $r4
    local.get $r2
    i64.sub
    local.set $r4
    local.get $r6
    local.get $r4
    i64.xor
    local.set $r6
    local.get $r4
    local.get $r0
    i64.xor
    local.set $r4
    local.get $r2
    i64.const -894992374
    i64.add
    local.set $r2
    local.get $r4
    local.get $r6
    i64.xor
    local.set $r4
    local.get $r7
    local.get $r0
    i64.xor
    local.set $r7
    local.get $r0
    local.get $r2
    call 1
    local.set $r0
    local.get $r6
    i64.const -8067858884644063954
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r7
    i64.mul
    local.set $r1
    local.get $r4
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r3
    i64.const -100791643
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r4
    i64.sub
    local.set $r7
    local.get $r7
    i64.const 62
    i64.rotr
    local.set $r7
    local.get $r5
    i64.const -665298609
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r5
    call 2
    local.set $r4
    local.get $r7
    i64.const -7762094760765760444
    i64.mul
    local.set $r7
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r2
    i64.mul
    local.set $r6
    local.get $r3
    local.get $r2
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r1
    i64.const 20
    i64.rotr
    local.set $r1
    local.get $r0
    i64.const 1869008599
    i64.add
    local.set $r0
    local.get $r1
    local.get $r2
    i64.sub
    local.set $r1
    local.get $r2
    local.get $r0
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r2
    i64.const -399422978
    i64.add
    local.set $r2
    local.get $r1
    i64.const 30
    i64.rotr
    local.set $r1
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r7
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r3
    i64.const 9
    i64.rotr
    local.set $r3
    local.get $r7
    i64.const 1133596440
    i64.add
    local.set $r7
    local.get $r7
    local.get $r3
    i64.sub
    local.set $r7
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r5
    local.get $r3
    call 2
    local.set $r5
    local.get $r3
    i64.const -647874950656296217
    i64.mul
    local.set $r3
    local.get $r6
    i64.const -772397292
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r6
    call 1
    local.set $r7
    local.get $r1
    i64.const -5217857704348693222
    i64.mul
    local.set $r1
    local.get $r4
    i64.const -362185054
    i64.add
    local.set $r4
    local.get $r2
    i64.const 12
    i64.rotr
    local.set $r2
    local.get $r0
    i64.const -1464732828
    i64.add
    local.set $r0
    local.get $r0
    local.get $r2
    i64.sub
    local.set $r0
    local.get $r4
    local.get $r6
    i64.sub
    local.set $r4
    local.get $r4
    local.get $r0
    i64.xor
    local.set $r4
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r4
    i64.const -1581014166
    i64.add
    local.set $r4
    local.get $r7
    local.get $r5
    i64.sub
    local.set $r7
    local.get $r5
    local.get $r0
    i64.xor
    local.set $r5
    local.get $r5
    local.get $r7
    i64.sub
    local.set $r5
    local.get $r0
    i64.const 528954432
    i64.xor
    local.set $r0
    local.get $r7
    local.get $r3
    i64.sub
    local.set $r7
    local.get $r3
    local.get $r6
    call 2
    local.set $r3
    local.get $r6
    i64.const -5882223603906808431
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r2
    i64.const 58
    i64.rotr
    local.set $r2
    local.get $r5
    local.get $r0
    i64.sub
    local.set $r5
    local.get $r2
    i64.const -1966212626
    i64.xor
    local.set $r2
    local.get $r1
    local.get $r0
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r2
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r2
    i64.sub
    local.set $r1
    local.get $r3
    i64.const -1765813438
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r2
    i64.sub
    local.set $r0
    local.get $r5
    local.get $r0
    call 1
    local.set $r5
    local.get $r2
    i64.const -5440977235290265
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r3
    i64.const 20
    i64.rotr
    local.set $r3
    local.get $r7
    local.get $r4
    i64.xor
    local.set $r7
    local.get $r1
    i64.const -832575183
    i64.add
    local.set $r1
    local.get $r4
    local.get $r3
    i64.sub
    local.set $r4
    local.get $r7
    local.get $r3
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r4
    i64.xor
    local.set $r1
    local.get $r4
    i64.const 442000349
    i64.add
    local.set $r4
    local.get $r7
    local.get $r2
    i64.xor
    local.set $r7
    local.get $r3
    local.get $r4
    call 1
    local.set $r3
    local.get $r6
    i64.const -6058548359989967324
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r0
    i64.mul
    local.set $r4
    local.get $r5
    i64.const 32
    i64.rotr
    local.set $r5
    local.get $r7
    i64.const 61
    i64.rotr
    local.set $r7
    local.get $r1
    i64.const -2119395928
    i64.xor
    local.set $r1
    local.get $r2
    local.get $r5
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r5
    i64.const 983758166
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r1
    i64.xor
    local.set $r7
    local.get $r2
    local.get $r0
    i64.sub
    local.set $r2
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r1
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r2
    i64.const 8
    i64.rotr
    local.set $r2
    local.get $r1
    i64.const 1227703431
    i64.xor
    local.set $r1
    local.get $r4
    i64.const 14
    i64.rotr
    local.set $r4
    local.get $r0
    i64.const 11
    i64.rotr
    local.set $r0
    local.get $r4
    i64.const 1800721474
    i64.add
    local.set $r4
    local.get $r5
    i64.const 46
    i64.rotr
    local.set $r5
    local.get $r4
    local.get $r1
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r2
    i64.const -724082138
    i64.add
    local.set $r2
    local.get $r3
    local.get $r7
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r7
    i64.xor
    local.set $r6
    local.get $r3
    local.get $r2
    i64.sub
    local.set $r3
    local.get $r3
    i64.const 42
    i64.rotr
    local.set $r3
    local.get $r7
    i64.const 783936685
    i64.xor
    local.set $r7
    local.get $r4
    i64.const 47
    i64.rotr
    local.set $r4
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r7
    i64.const 55
    i64.rotr
    local.set $r7
    local.get $r0
    i64.const -1767425701
    i64.add
    local.set $r0
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r4
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r0
    i64.sub
    local.set $r5
    local.get $r0
    local.get $r4
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r2
    i64.const 1202199236
    i64.add
    local.set $r2
    local.get $r7
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r5
    local.get $r4
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r7
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r6
    i64.const 52
    i64.rotr
    local.set $r6
    local.get $r0
    i64.const -901742657
    i64.add
    local.set $r0
    local.get $r7
    i64.const 21
    i64.rotr
    local.set $r7
    local.get $r0
    i64.const 5
    i64.rotr
    local.set $r0
    local.get $r6
    i64.const -1051516566
    i64.add
    local.set $r6
    local.get $r1
    i64.const 44
    i64.rotr
    local.set $r1
    local.get $r3
    local.get $r5
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r7
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r1
    local.get $r2
    i64.const 1
    i64.shl
    i64.add
    local.set $r1
    local.get $r7
    i64.const -1809200833
    i64.xor
    local.set $r7
    local.get $r3
    local.get $r2
    i64.xor
    local.set $r3
    local.get $r1
    i64.const -1879702659
    i64.xor
    local.set $r1
    local.get $r2
    local.get $r5
    i64.sub
    local.set $r2
    local.get $r2
    local.get $r6
    i64.sub
    local.set $r2
    local.get $r5
    local.get $r6
    call 1
    local.set $r5
    local.get $r7
    i64.const -4139607275945132973
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r1
    local.get $r4
    i64.mul
    local.set $r1
    local.get $r3
    i64.const 36
    i64.rotr
    local.set $r3
    local.get $r0
    local.get $r6
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r6
    i64.const -1116823662
    i64.xor
    local.set $r6
    local.get $r3
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r3
    local.get $r0
    i64.const -21129429
    i64.xor
    local.set $r0
    local.get $r2
    local.get $r4
    i64.xor
    local.set $r2
    local.get $r0
    local.get $r4
    i64.sub
    local.set $r0
    local.get $r6
    local.get $r4
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r6
    local.get $r2
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r1
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    i64.const 1
    i64.rotr
    local.set $r4
    local.get $r5
    i64.const 692035995
    i64.add
    local.set $r5
    local.get $r3
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r3
    local.get $r3
    local.get $r4
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r4
    i64.const 1587734037
    i64.add
    local.set $r4
    local.get $r3
    i64.const 16
    i64.rotr
    local.set $r3
    local.get $r5
    local.get $r4
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r1
    i64.mul
    local.set $r4
    local.get $r7
    i64.const 53
    i64.rotr
    local.set $r7
    local.get $r2
    i64.const 1067111060
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r7
    i64.sub
    local.set $r6
    local.get $r2
    local.get $r6
    i64.xor
    local.set $r2
    local.get $r1
    local.get $r2
    call 1
    local.set $r1
    local.get $r7
    i64.const -4212888155636646673
    i64.mul
    local.set $r7
    local.get $r6
    i64.const -1510231845
    i64.add
    local.set $r6
    local.get $r3
    local.get $r0
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r5
    i64.const 3
    i64.shl
    i64.add
    local.set $r6
    local.get $r2
    i64.const -917216948
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r3
    i64.xor
    local.set $r6
    local.get $r3
    local.get $r0
    i64.mul
    local.set $r3
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r6
    i64.const 10
    i64.rotr
    local.set $r6
    local.get $r5
    i64.const -1605615762
    i64.add
    local.set $r5
    local.get $r5
    local.get $r0
    i64.sub
    local.set $r5
    local.get $r6
    local.get $r0
    i64.xor
    local.set $r6
    local.get $r4
    local.get $r3
    call 1
    local.set $r4
    local.get $r3
    i64.const -8754521315116997760
    i64.mul
    local.set $r3
    local.get $r0
    i64.const 1206638540
    i64.add
    local.set $r0
    local.get $r5
    i64.const 40
    i64.rotr
    local.set $r5
    local.get $r2
    local.get $r0
    i64.xor
    local.set $r2
    local.get $r6
    i64.const -522585525
    i64.xor
    local.set $r6
    local.get $r5
    local.get $r1
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r2
    call 1
    local.set $r7
    local.get $r5
    i64.const -5616154303564118062
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r1
    local.get $r0
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r0
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r0
    local.get $r6
    i64.const -1142789958
    i64.add
    local.set $r6
    local.get $r1
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r1
    local.get $r6
    i64.const 63
    i64.rotr
    local.set $r6
    local.get $r6
    i64.const 425939202
    i64.add
    local.set $r6
    local.get $r2
    local.get $r7
    call 1
    local.set $r2
    local.get $r3
    i64.const -8716613336672340079
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r7
    i64.const 60
    i64.rotr
    local.set $r7
    local.get $r0
    i64.const 61
    i64.rotr
    local.set $r0
    local.get $r4
    i64.const -928392673
    i64.xor
    local.set $r4
    local.get $r0
    local.get $r5
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r5
    local.get $r0
    i64.xor
    local.set $r5
    local.get $r4
    i64.const 33063963
    i64.add
    local.set $r4
    local.get $r3
    local.get $r0
    i64.xor
    local.set $r3
    local.get $r7
    local.get $r6
    call 1
    local.set $r7
    local.get $r4
    i64.const -3398487483506669383
    i64.mul
    local.set $r4
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r5
    i64.const 2
    i64.shl
    i64.add
    local.set $r6
    local.get $r5
    i64.const 3
    i64.rotr
    local.set $r5
    local.get $r3
    i64.const -1680993065
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r3
    local.get $r1
    i64.sub
    local.set $r3
    local.get $r3
    i64.const 181013518
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r6
    i64.sub
    local.set $r0
    local.get $r6
    local.get $r7
    call 1
    local.set $r6
    local.get $r0
    i64.const -8266741491012122111
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r1
    i64.const 17
    i64.rotr
    local.set $r1
    local.get $r2
    i64.const 663580643
    i64.xor
    local.set $r2
    local.get $r3
    local.get $r1
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r2
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r5
    call 1
    local.set $r1
    local.get $r3
    i64.const -4903470134151480150
    i64.mul
    local.set $r3
    local.get $r5
    i64.const 1374551161
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r0
    call 1
    local.set $r2
    local.get $r4
    i64.const -6888915151228350528
    i64.mul
    local.set $r4
    local.get $r0
    i64.const -665449707
    i64.add
    local.set $r0
    local.get $r5
    local.get $r1
    call 1
    local.set $r5
    local.get $r7
    i64.const -6200046583297700372
    i64.mul
    local.set $r7
    local.get $r6
    i64.const 1329704447
    i64.xor
    local.set $r6
    local.get $r0
    i64.const 39
    i64.rotr
    local.set $r0
    local.get $r6
    local.get $r0
    i64.const 1
    i64.shl
    i64.add
    local.set $r6
    local.get $r0
    i64.const 875507479
    i64.add
    local.set $r0
    local.get $r3
    local.get $r3
    call 2
    local.set $r3
    local.get $r2
    i64.const -5683575092146787165
    i64.mul
    local.set $r2
    local.get $r1
    local.get $r0
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r6
    i64.const 36
    i64.rotr
    local.set $r6
    local.get $r0
    i64.const -755135633
    i64.xor
    local.set $r0
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r6
    local.get $r4
    i64.xor
    local.set $r6
    local.get $r4
    local.get $r4
    call 1
    local.set $r4
    local.get $r5
    i64.const -5051733932409506752
    i64.mul
    local.set $r5
    local.get $r0
    i64.const 1827620015
    i64.add
    local.set $r0
    local.get $r6
    local.get $r7
    call 2
    local.set $r6
    local.get $r0
    i64.const -5556669051094553332
    i64.mul
    local.set $r0
    local.get $r3
    i64.const 228292634
    i64.xor
    local.set $r3
    local.get $r2
    local.get $r2
    call 1
    local.set $r2
    local.get $r3
    i64.const -7153665706424975955
    i64.mul
    local.set $r3
    local.get $r1
    i64.const 390063029
    i64.xor
    local.set $r1
    local.get $r7
    local.get $r1
    i64.const 3
    i64.shl
    i64.add
    local.set $r7
    local.get $r1
    i64.const 4
    i64.rotr
    local.set $r1
    local.get $r7
    i64.const -2098794388
    i64.add
    local.set $r7
    local.get $r7
    i64.const 39
    i64.rotr
    local.set $r7
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r0
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r1
    i64.const 960516037
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r4
    call 1
    local.set $r5
    local.get $r0
    i64.const -3455105046939628982
    i64.mul
    local.set $r0
    local.get $r4
    i64.const -1363627066
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r4
    call 1
    local.set $r1
    local.get $r6
    i64.const -8487992418178039267
    i64.mul
    local.set $r6
    local.get $r2
    i64.const -794093655
    i64.xor
    local.set $r2
    local.get $r2
    local.get $r4
    i64.sub
    local.set $r2
    local.get $r2
    local.get $r7
    i64.xor
    local.set $r2
    local.get $r7
    i64.const -1597690638
    i64.xor
    local.set $r7
    local.get $r7
    local.get $r3
    i64.xor
    local.set $r7
    local.get $r4
    local.get $r7
    i64.sub
    local.set $r4
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r7
    i64.const 29
    i64.rotr
    local.set $r7
    local.get $r5
    i64.const 1159217714
    i64.xor
    local.set $r5
    local.get $r3
    local.get $r5
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r7
    i64.xor
    local.set $r5
    local.get $r6
    i64.const 125871322
    i64.xor
    local.set $r6
    local.get $r5
    local.get $r1
    i64.sub
    local.set $r5
    local.get $r3
    local.get $r1
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r0
    i64.mul
    local.set $r7
    local.get $r5
    i64.const 39
    i64.rotr
    local.set $r5
    local.get $r3
    i64.const 1748006277
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r3
    i64.sub
    local.set $r2
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r2
    i64.const 8
    i64.rotr
    local.set $r2
    local.get $r1
    i64.const -721279243
    i64.add
    local.set $r1
    local.get $r4
    local.get $r3
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r0
    i64.mul
    local.set $r4
    local.get $r1
    i64.const 4
    i64.rotr
    local.set $r1
    local.get $r5
    i64.const -239882548
    i64.add
    local.set $r5
    local.get $r1
    local.get $r0
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r6
    local.get $r5
    call 2
    local.set $r6
    local.get $r3
    i64.const -6440305541620829324
    i64.mul
    local.set $r3
    local.get $r7
    i64.const 783373609
    i64.add
    local.set $r7
    local.get $r5
    local.get $r4
    call 1
    local.set $r5
    local.get $r1
    i64.const -5473784057456094701
    i64.mul
    local.set $r1
    local.get $r0
    i64.const 1266996735
    i64.add
    local.set $r0
    local.get $r7
    local.get $r6
    call 2
    local.set $r7
    local.get $r6
    i64.const -2611480026696746672
    i64.mul
    local.set $r6
    local.get $r4
    i64.const 271004168
    i64.add
    local.set $r4
    local.get $r2
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r0
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r4
    i64.const 1002725303
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r4
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r4
    local.get $r2
    i64.mul
    local.set $r4
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r1
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r2
    i64.const 746129774
    i64.xor
    local.set $r2
    local.get $r3
    local.get $r2
    i64.xor
    local.set $r3
    local.get $r3
    local.get $r2
    i64.sub
    local.set $r3
    local.get $r2
    local.get $r0
    call 2
    local.set $r2
    local.get $r3
    i64.const -1209102047580599625
    i64.mul
    local.set $r3
    local.get $r7
    i64.const 960454629
    i64.xor
    local.set $r7
    local.get $r1
    i64.const 33
    i64.rotr
    local.set $r1
    local.get $r5
    i64.const 55
    i64.rotr
    local.set $r5
    local.get $r1
    i64.const 792200655
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r0
    call 2
    local.set $r0
    local.get $r5
    i64.const -9209957835016909194
    i64.mul
    local.set $r5
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r4
    i64.const 42
    i64.rotr
    local.set $r4
    local.get $r6
    local.get $r4
    i64.xor
    local.set $r6
    local.get $r4
    i64.const 460352740
    i64.xor
    local.set $r4
    local.get $r2
    local.get $r4
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r3
    i64.sub
    local.set $r6
    local.get $r3
    local.get $r4
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r6
    i64.const -154402712
    i64.add
    local.set $r6
    local.get $r0
    i64.const 7
    i64.rotr
    local.set $r0
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r0
    local.get $r5
    i64.mul
    local.set $r0
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r4
    i64.const 29
    i64.rotr
    local.set $r4
    local.get $r5
    i64.const 46
    i64.rotr
    local.set $r5
    local.get $r3
    i64.const -1459351433
    i64.xor
    local.set $r3
    local.get $r7
    i64.const 29
    i64.rotr
    local.set $r7
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r4
    i64.const -444131628
    i64.add
    local.set $r4
    local.get $r7
    local.get $r2
    i64.xor
    local.set $r7
    local.get $r2
    local.get $r5
    i64.sub
    local.set $r2
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r0
    i64.const 19
    i64.rotr
    local.set $r0
    local.get $r2
    local.get $r3
    i64.sub
    local.set $r2
    local.get $r6
    i64.const -406373434
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r3
    i64.xor
    local.set $r0
    local.get $r6
    local.get $r3
    i64.xor
    local.set $r6
    local.get $r0
    i64.const -1108695947
    i64.xor
    local.set $r0
    local.get $r7
    local.get $r1
    i64.sub
    local.set $r7
    local.get $item_number
    i64.const 4194303
    i64.and
    i32.wrap_i64
    i32.const 6
    i32.shl
    i32.const 51872
    i32.add
    local.set $mixblock_ptr
    local.get $mixblock_ptr
    i64.load align=4
    local.get $r0
    i64.xor
    local.set $r0
    local.get $mixblock_ptr
    i64.load offset=8 align=4
    local.get $r1
    i64.xor
    local.set $r1
    local.get $mixblock_ptr
    i64.load offset=16 align=4
    local.get $r2
    i64.xor
    local.set $r2
    local.get $mixblock_ptr
    i64.load offset=24 align=4
    local.get $r3
    i64.xor
    local.set $r3
    local.get $mixblock_ptr
    i64.load offset=32 align=4
    local.get $r4
    i64.xor
    local.set $r4
    local.get $mixblock_ptr
    i64.load offset=40 align=4
    local.get $r5
    i64.xor
    local.set $r5
    local.get $mixblock_ptr
    i64.load offset=48 align=4
    local.get $r6
    i64.xor
    local.set $r6
    local.get $mixblock_ptr
    i64.load offset=56 align=4
    local.get $r7
    i64.xor
    local.set $r7
    local.get $r0
    local.set $item_number
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r1
    local.get $r7
    i64.const 1
    i64.shl
    i64.add
    local.set $r1
    local.get $r3
    i64.const 1377002689
    i64.xor
    local.set $r3
    local.get $r2
    local.get $r7
    call 1
    local.set $r2
    local.get $r3
    i64.const -3652222777958867928
    i64.mul
    local.set $r3
    local.get $r0
    i64.const -1978044576
    i64.xor
    local.set $r0
    local.get $r0
    local.get $r5
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r4
    i64.const 1238340714
    i64.xor
    local.set $r4
    local.get $r7
    local.get $r4
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r0
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r0
    i64.sub
    local.set $r5
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r4
    local.get $r1
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r0
    i64.const 156360539
    i64.xor
    local.set $r0
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r6
    local.get $r7
    call 1
    local.set $r6
    local.get $r4
    i64.const -4937924823608026880
    i64.mul
    local.set $r4
    local.get $r3
    i64.const -605582401
    i64.add
    local.set $r3
    local.get $r7
    i64.const 25
    i64.rotr
    local.set $r7
    local.get $r3
    i64.const 1573662441
    i64.xor
    local.set $r3
    local.get $r7
    local.get $r1
    i64.sub
    local.set $r7
    local.get $r5
    local.get $r1
    i64.sub
    local.set $r5
    local.get $r1
    local.get $r1
    call 2
    local.set $r1
    local.get $r5
    i64.const -1001144604307220335
    i64.mul
    local.set $r5
    local.get $r3
    local.get $r7
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r2
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r0
    local.get $r2
    i64.xor
    local.set $r0
    local.get $r6
    i64.const 1724195865
    i64.add
    local.set $r6
    local.get $r6
    local.get $r2
    i64.xor
    local.set $r6
    local.get $r2
    local.get $r3
    call 1
    local.set $r2
    local.get $r1
    i64.const -5653919620063415080
    i64.mul
    local.set $r1
    local.get $r7
    i64.const -1795288487
    i64.add
    local.set $r7
    local.get $r0
    local.get $r3
    i64.sub
    local.set $r0
    local.get $r6
    i64.const 35
    i64.rotr
    local.set $r6
    local.get $r6
    i64.const -289156698
    i64.xor
    local.set $r6
    local.get $r3
    local.get $r4
    i64.sub
    local.set $r3
    local.get $r5
    local.get $r4
    i64.mul
    local.set $r5
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r6
    i64.const 38
    i64.rotr
    local.set $r6
    local.get $r7
    i64.const 425908379
    i64.xor
    local.set $r7
    local.get $r7
    local.get $r2
    i64.sub
    local.set $r7
    local.get $r2
    local.get $r6
    i64.xor
    local.set $r2
    local.get $r7
    local.get $r6
    i64.xor
    local.set $r7
    local.get $r4
    i64.const 55
    i64.rotr
    local.set $r4
    local.get $r2
    i64.const 488437559
    i64.xor
    local.set $r2
    local.get $r3
    i64.const 20
    i64.rotr
    local.set $r3
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r6
    i64.mul
    local.set $r7
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r2
    local.get $r5
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r2
    i64.const 63
    i64.rotr
    local.set $r2
    local.get $r1
    i64.const -992838848
    i64.xor
    local.set $r1
    local.get $r1
    local.get $r3
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r2
    i64.const 0
    i64.shl
    i64.add
    local.set $r0
    local.get $r4
    i64.const -1739561094
    i64.add
    local.set $r4
    local.get $r5
    local.get $r2
    call 1
    local.set $r5
    local.get $r4
    i64.const -7289704444905878890
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r0
    i64.mul
    local.set $r3
    local.get $r0
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r0
    i64.const 4
    i64.rotr
    local.set $r0
    local.get $r6
    i64.const 382048576
    i64.add
    local.set $r6
    local.get $r1
    local.get $r7
    i64.sub
    local.set $r1
    local.get $r7
    i64.const 1794955701
    i64.add
    local.set $r7
    local.get $r6
    local.get $r0
    i64.sub
    local.set $r6
    local.get $r0
    local.get $r7
    i64.sub
    local.set $r0
    local.get $r1
    local.get $r7
    i64.xor
    local.set $r1
    local.get $r6
    local.get $r1
    i64.mul
    local.set $r6
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r4
    local.get $r1
    i64.mul
    local.set $r4
    local.get $r7
    local.get $r2
    i64.const 2
    i64.shl
    i64.add
    local.set $r7
    local.get $r5
    i64.const 45
    i64.rotr
    local.set $r5
    local.get $r7
    i64.const 493195094
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r2
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r3
    local.get $r1
    i64.const 3
    i64.shl
    i64.add
    local.set $r3
    local.get $r7
    i64.const -1772563392
    i64.add
    local.set $r7
    local.get $r2
    local.get $r3
    call 2
    local.set $r2
    local.get $r6
    i64.const -1517656406769077313
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r5
    i64.const 0
    i64.shl
    i64.add
    local.set $r0
    local.get $r3
    i64.const 1145858986
    i64.xor
    local.set $r3
    local.get $r4
    local.get $r5
    i64.sub
    local.set $r4
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r0
    i64.xor
    local.set $r4
    local.get $r0
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r0
    local.get $r6
    i64.const 828840561
    i64.xor
    local.set $r6
    local.get $r3
    local.get $r3
    call 2
    local.set $r3
    local.get $r0
    i64.const -5694819094240838220
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r5
    local.get $r4
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r7
    i64.const 59
    i64.rotr
    local.set $r7
    local.get $r4
    i64.const 695578690
    i64.xor
    local.set $r4
    local.get $r2
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r7
    i64.const 1514758883
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r7
    i64.sub
    local.set $r1
    local.get $r4
    local.get $r6
    i64.sub
    local.set $r4
    local.get $r3
    local.get $r7
    i64.sub
    local.set $r3
    local.get $r6
    local.get $r2
    i64.mul
    local.set $r6
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r7
    i64.const 23
    i64.rotr
    local.set $r7
    local.get $r0
    i64.const 869707612
    i64.xor
    local.set $r0
    local.get $r3
    local.get $r5
    i64.sub
    local.set $r3
    local.get $r5
    local.get $r0
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r3
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r7
    i64.sub
    local.set $r6
    local.get $r3
    i64.const 240226624
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $r5
    local.get $r4
    i64.sub
    local.set $r5
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r6
    i64.const 17
    i64.rotr
    local.set $r6
    local.get $r2
    local.get $r0
    i64.const 2
    i64.shl
    i64.add
    local.set $r2
    local.get $r1
    i64.const 783109343
    i64.xor
    local.set $r1
    local.get $r0
    local.get $r2
    i64.const 2
    i64.shl
    i64.add
    local.set $r0
    local.get $r2
    local.get $r1
    i64.const 0
    i64.shl
    i64.add
    local.set $r2
    local.get $r6
    i64.const -1576334920
    i64.xor
    local.set $r6
    local.get $r1
    i64.const 60
    i64.rotr
    local.set $r1
    local.get $r0
    local.get $r7
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r6
    i64.const 9
    i64.rotr
    local.set $r6
    local.get $r4
    i64.const 48
    i64.rotr
    local.set $r4
    local.get $r6
    i64.const -2069777627
    i64.add
    local.set $r6
    local.get $r7
    local.get $r5
    call 1
    local.set $r7
    local.get $r4
    i64.const -6694601976937383408
    i64.mul
    local.set $r4
    local.get $r5
    i64.const -1376347196
    i64.xor
    local.set $r5
    local.get $r2
    local.get $r5
    i64.sub
    local.set $r2
    local.get $r2
    i64.const 34
    i64.rotr
    local.set $r2
    local.get $r0
    i64.const -1778948652
    i64.add
    local.set $r0
    local.get $r3
    local.get $r1
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r6
    i64.mul
    local.set $r2
    local.get $r7
    local.get $r3
    i64.mul
    local.set $r7
    local.get $r0
    i64.const 2
    i64.rotr
    local.set $r0
    local.get $r1
    i64.const 4
    i64.rotr
    local.set $r1
    local.get $r3
    i64.const 893868120
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r1
    call 2
    local.set $r6
    local.get $r0
    i64.const -5261506826600638848
    i64.mul
    local.set $r0
    local.get $r3
    i64.const 2017094226
    i64.add
    local.set $r3
    local.get $r1
    local.get $r3
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r3
    i64.const -457241869
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r1
    i64.sub
    local.set $r5
    local.get $r4
    local.get $r7
    i64.sub
    local.set $r4
    local.get $r7
    local.get $r1
    i64.sub
    local.set $r7
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r3
    i64.const 38
    i64.rotr
    local.set $r3
    local.get $r7
    local.get $r2
    i64.xor
    local.set $r7
    local.get $r0
    i64.const 588492980
    i64.add
    local.set $r0
    local.get $r6
    local.get $r3
    i64.xor
    local.set $r6
    local.get $r2
    local.get $r7
    call 1
    local.set $r2
    local.get $r6
    i64.const -4519125403269314751
    i64.mul
    local.set $r6
    local.get $r5
    i64.const 686746926
    i64.add
    local.set $r5
    local.get $r3
    local.get $r7
    i64.sub
    local.set $r3
    local.get $r5
    i64.const -723480846
    i64.xor
    local.set $r5
    local.get $r7
    local.get $r1
    i64.sub
    local.set $r7
    local.get $r0
    local.get $r3
    i64.sub
    local.set $r0
    local.get $r3
    local.get $r1
    i64.xor
    local.set $r3
    local.get $r7
    local.get $r4
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r0
    i64.mul
    local.set $r3
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r0
    i64.const 26
    i64.rotr
    local.set $r0
    local.get $r0
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r4
    i64.const 1871542503
    i64.xor
    local.set $r4
    local.get $r1
    local.get $r4
    call 2
    local.set $r1
    local.get $r2
    i64.const -3399502648072261189
    i64.mul
    local.set $r2
    local.get $r4
    i64.const 1223409948
    i64.add
    local.set $r4
    local.get $r4
    local.get $r0
    i64.sub
    local.set $r4
    local.get $r0
    i64.const 9
    i64.rotr
    local.set $r0
    local.get $r4
    i64.const -147114495
    i64.add
    local.set $r4
    local.get $r7
    i64.const 10
    i64.rotr
    local.set $r7
    local.get $r0
    local.get $r3
    i64.mul
    local.set $r0
    local.get $r6
    local.get $r4
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r4
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r4
    local.get $r5
    local.get $r3
    i64.sub
    local.set $r5
    local.get $r4
    i64.const 2079917014
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r2
    local.get $r4
    i64.xor
    local.set $r2
    local.get $r2
    i64.const -1330071146
    i64.add
    local.set $r2
    local.get $r3
    local.get $r1
    i64.xor
    local.set $r3
    local.get $r1
    local.get $r5
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r4
    call 2
    local.set $r5
    local.get $r2
    i64.const -1986214114047158597
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r6
    i64.mul
    local.set $r4
    local.get $r3
    local.get $r1
    i64.mul
    local.set $r3
    local.get $r1
    i64.const 12
    i64.rotr
    local.set $r1
    local.get $r7
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r7
    local.get $r7
    i64.const 6164327
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r6
    i64.xor
    local.set $r1
    local.get $r0
    i64.const 40
    i64.rotr
    local.set $r0
    local.get $r6
    i64.const 1941521429
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r0
    local.get $r5
    local.get $r1
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r0
    local.get $r2
    local.get $r6
    i64.const 3
    i64.shl
    i64.add
    local.set $r2
    local.get $r6
    i64.const 156426102
    i64.add
    local.set $r6
    local.get $r2
    local.get $r5
    i64.const 1
    i64.shl
    i64.add
    local.set $r2
    local.get $r4
    i64.const -54588358
    i64.add
    local.set $r4
    local.get $r6
    local.get $r4
    i64.xor
    local.set $r6
    local.get $r4
    local.get $r5
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r5
    i64.xor
    local.set $r3
    local.get $r6
    local.get $r2
    i64.mul
    local.set $r6
    local.get $r3
    local.get $r1
    i64.mul
    local.set $r3
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r0
    i64.const 3
    i64.shl
    i64.add
    local.set $r4
    local.get $r5
    local.get $r0
    i64.xor
    local.set $r5
    local.get $r4
    i64.const 883123478
    i64.xor
    local.set $r4
    local.get $r0
    local.get $r5
    i64.sub
    local.set $r0
    local.get $r1
    local.get $r4
    i64.xor
    local.set $r1
    local.get $r4
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r6
    i64.const -1543545182
    i64.add
    local.set $r6
    local.get $r1
    local.get $r5
    i64.sub
    local.set $r1
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r7
    i64.const 56
    i64.rotr
    local.set $r7
    local.get $r3
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r2
    i64.const 2131484520
    i64.xor
    local.set $r2
    local.get $r7
    local.get $r1
    i64.const 3
    i64.shl
    i64.add
    local.set $r7
    local.get $r0
    local.get $r7
    i64.xor
    local.set $r0
    local.get $r7
    i64.const -313156275
    i64.xor
    local.set $r7
    local.get $r3
    local.get $r4
    i64.sub
    local.set $r3
    local.get $r1
    local.get $r7
    call 2
    local.set $r1
    local.get $r0
    i64.const -226612011234383684
    i64.mul
    local.set $r0
    local.get $r7
    local.get $r2
    i64.mul
    local.set $r7
    local.get $r2
    local.get $r3
    i64.mul
    local.set $r2
    local.get $r4
    i64.const 13
    i64.rotr
    local.set $r4
    local.get $r5
    i64.const 31
    i64.rotr
    local.set $r5
    local.get $r6
    i64.const 1571660593
    i64.xor
    local.set $r6
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r3
    i64.const 30
    i64.rotr
    local.set $r3
    local.get $r5
    i64.const -1162221200
    i64.xor
    local.set $r5
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r3
    i64.mul
    local.set $r1
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r6
    i64.const 59
    i64.rotr
    local.set $r6
    local.get $r3
    local.get $r7
    i64.xor
    local.set $r3
    local.get $r4
    i64.const 256086161
    i64.add
    local.set $r4
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r7
    local.get $r2
    i64.sub
    local.set $r7
    local.get $r7
    local.get $r3
    i64.const 2
    i64.shl
    i64.add
    local.set $r7
    local.get $r2
    i64.const -468979634
    i64.add
    local.set $r2
    local.get $r4
    local.get $r3
    i64.const 1
    i64.shl
    i64.add
    local.set $r4
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r1
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r1
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r7
    i64.const 425549316
    i64.add
    local.set $r7
    local.get $r7
    i64.const 62
    i64.rotr
    local.set $r7
    local.get $r0
    local.get $r1
    i64.sub
    local.set $r0
    local.get $r3
    i64.const 373334138
    i64.add
    local.set $r3
    local.get $r1
    local.get $r3
    i64.xor
    local.set $r1
    local.get $r5
    local.get $r5
    call 2
    local.set $r5
    local.get $r2
    i64.const -8517688079177516002
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r6
    i64.mul
    local.set $r1
    local.get $r0
    i64.const 15
    i64.rotr
    local.set $r0
    local.get $r0
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r0
    local.get $r4
    i64.const 846556742
    i64.xor
    local.set $r4
    local.get $r4
    i64.const 10
    i64.rotr
    local.set $r4
    local.get $r6
    i64.const -1967971742
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r4
    local.get $r6
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r0
    call 1
    local.set $r3
    local.get $r5
    i64.const -9207408089479120903
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r1
    i64.mul
    local.set $r2
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r4
    i64.const 3
    i64.shl
    i64.add
    local.set $r7
    local.get $r7
    i64.const -905344987
    i64.add
    local.set $r7
    local.get $r4
    local.get $r0
    i64.xor
    local.set $r4
    local.get $r4
    local.get $r1
    i64.sub
    local.set $r4
    local.get $r0
    local.get $r7
    i64.sub
    local.set $r0
    local.get $r4
    i64.const -1572591927
    i64.xor
    local.set $r4
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r7
    local.get $r3
    i64.sub
    local.set $r7
    local.get $r1
    local.get $r4
    i64.sub
    local.set $r1
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r7
    local.get $r1
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r0
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r1
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r0
    i64.const 1302970767
    i64.add
    local.set $r0
    local.get $r1
    local.get $r0
    i64.sub
    local.set $r1
    local.get $r4
    local.get $r0
    i64.sub
    local.set $r4
    local.get $r5
    local.get $r1
    i64.sub
    local.set $r5
    local.get $r2
    i64.const 1522252273
    i64.xor
    local.set $r2
    local.get $r4
    local.get $r1
    i64.sub
    local.set $r4
    local.get $r5
    local.get $r0
    i64.xor
    local.set $r5
    local.get $r6
    local.get $r4
    call 2
    local.set $r6
    local.get $r5
    i64.const -7843019502688368227
    i64.mul
    local.set $r5
    local.get $r4
    local.get $r1
    i64.mul
    local.set $r4
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r0
    i64.const 50
    i64.rotr
    local.set $r0
    local.get $r7
    i64.const 15
    i64.rotr
    local.set $r7
    local.get $r2
    i64.const -298949084
    i64.add
    local.set $r2
    local.get $r3
    local.get $r0
    call 1
    local.set $r3
    local.get $r4
    i64.const -4743134796200316800
    i64.mul
    local.set $r4
    local.get $r2
    i64.const -2034369953
    i64.xor
    local.set $r2
    local.get $r2
    local.get $r7
    i64.xor
    local.set $r2
    local.get $r7
    i64.const -33887951
    i64.xor
    local.set $r7
    local.get $r5
    local.get $r0
    i64.sub
    local.set $r5
    local.get $r2
    local.get $r5
    i64.xor
    local.set $r2
    local.get $r7
    local.get $r1
    i64.sub
    local.set $r7
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r2
    local.get $r0
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r7
    i64.mul
    local.set $r4
    local.get $r6
    i64.const 27
    i64.rotr
    local.set $r6
    local.get $r1
    local.get $r0
    i64.sub
    local.set $r1
    local.get $r0
    i64.const 1231476625
    i64.xor
    local.set $r0
    local.get $r6
    local.get $r1
    i64.sub
    local.set $r6
    local.get $r0
    local.get $r5
    i64.sub
    local.set $r0
    local.get $r7
    local.get $r5
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r5
    i64.const 760157612
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r7
    i64.const 0
    i64.shl
    i64.add
    local.set $r1
    local.get $r0
    local.get $r2
    i64.mul
    local.set $r0
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r3
    i64.const 30
    i64.rotr
    local.set $r3
    local.get $r5
    i64.const 59
    i64.rotr
    local.set $r5
    local.get $r3
    i64.const 1110720684
    i64.add
    local.set $r3
    local.get $r5
    local.get $r3
    i64.xor
    local.set $r5
    local.get $r3
    i64.const 1595830248
    i64.xor
    local.set $r3
    local.get $r2
    local.get $r1
    i64.sub
    local.set $r2
    local.get $r0
    local.get $r3
    i64.xor
    local.set $r0
    local.get $r1
    local.get $r3
    call 1
    local.set $r1
    local.get $r0
    i64.const -7796178429998274708
    i64.mul
    local.set $r0
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r6
    i64.mul
    local.set $r3
    local.get $r4
    i64.const 53
    i64.rotr
    local.set $r4
    local.get $r7
    i64.const -988450417
    i64.xor
    local.set $r7
    local.get $r5
    local.get $r4
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r7
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r5
    i64.sub
    local.set $r6
    local.get $r5
    i64.const 4
    i64.rotr
    local.set $r5
    local.get $r6
    i64.const -1534793644
    i64.add
    local.set $r6
    local.get $r1
    i64.const 23
    i64.rotr
    local.set $r1
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r7
    i64.const 21
    i64.rotr
    local.set $r7
    local.get $r4
    local.get $r1
    i64.const 1
    i64.shl
    i64.add
    local.set $r4
    local.get $r2
    i64.const -2029464984
    i64.add
    local.set $r2
    local.get $r7
    local.get $r2
    i64.const 2
    i64.shl
    i64.add
    local.set $r7
    local.get $r7
    local.get $r6
    i64.const 1
    i64.shl
    i64.add
    local.set $r7
    local.get $r4
    i64.const 83041274
    i64.add
    local.set $r4
    local.get $r3
    local.get $r6
    i64.sub
    local.set $r3
    local.get $r1
    local.get $r2
    i64.mul
    local.set $r1
    local.get $r2
    local.get $r4
    i64.mul
    local.set $r2
    local.get $r3
    local.get $r7
    i64.mul
    local.set $r3
    local.get $r4
    local.get $r7
    i64.const 2
    i64.shl
    i64.add
    local.set $r4
    local.get $r6
    local.get $r5
    i64.sub
    local.set $r6
    local.get $r4
    i64.const 336391805
    i64.xor
    local.set $r4
    local.get $r6
    local.get $r0
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r6
    call 2
    local.set $r7
    local.get $r2
    i64.const -6512720615839351989
    i64.mul
    local.set $r2
    local.get $r5
    i64.const -1735075544
    i64.xor
    local.set $r5
    local.get $r1
    local.get $r4
    i64.const 3
    i64.shl
    i64.add
    local.set $r1
    local.get $r3
    local.get $r5
    i64.const 1
    i64.shl
    i64.add
    local.set $r3
    local.get $r0
    i64.const 701443974
    i64.add
    local.set $r0
    local.get $r0
    i64.const 9
    i64.rotr
    local.set $r0
    local.get $r4
    local.get $r1
    i64.mul
    local.set $r4
    local.get $r1
    local.get $r5
    i64.mul
    local.set $r1
    local.get $r5
    local.get $r6
    i64.mul
    local.set $r5
    local.get $r3
    i64.const 24
    i64.rotr
    local.set $r3
    local.get $r2
    i64.const 1357168881
    i64.xor
    local.set $r2
    local.get $r6
    local.get $r7
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r0
    i64.sub
    local.set $r7
    local.get $r0
    local.get $r2
    i64.sub
    local.set $r0
    local.get $r1
    i64.const 9
    i64.rotr
    local.set $r1
    local.get $r3
    i64.const 282320608
    i64.xor
    local.set $r3
    local.get $r3
    local.get $r4
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r7
    local.get $r0
    i64.mul
    local.set $r7
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r6
    local.get $r2
    i64.const 0
    i64.shl
    i64.add
    local.set $r6
    local.get $r4
    i64.const 52
    i64.rotr
    local.set $r4
    local.get $r5
    i64.const -1551971278
    i64.add
    local.set $r5
    local.get $r2
    local.get $r1
    call 1
    local.set $r2
    local.get $r1
    i64.const -5808032526620331430
    i64.mul
    local.set $r1
    local.get $r4
    i64.const 1047919973
    i64.xor
    local.set $r4
    local.get $r7
    local.get $r0
    i64.xor
    local.set $r7
    local.get $r0
    i64.const 516925110
    i64.xor
    local.set $r0
    local.get $r6
    local.get $r0
    i64.xor
    local.set $r6
    local.get $r0
    local.get $r5
    i64.xor
    local.set $r0
    local.get $r3
    local.get $r4
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r4
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r2
    i64.mul
    local.set $r3
    local.get $r1
    local.get $r4
    i64.mul
    local.set $r1
    local.get $r6
    local.get $r5
    i64.const 2
    i64.shl
    i64.add
    local.set $r6
    local.get $r7
    i64.const 40
    i64.rotr
    local.set $r7
    local.get $r6
    i64.const -339898613
    i64.add
    local.set $r6
    local.get $r5
    local.get $r6
    call 1
    local.set $r5
    local.get $r4
    i64.const -9133457820600958051
    i64.mul
    local.set $r4
    local.get $r2
    i64.const 1642334969
    i64.xor
    local.set $r2
    local.get $r6
    i64.const 20
    i64.rotr
    local.set $r6
    local.get $r0
    i64.const 62
    i64.rotr
    local.set $r0
    local.get $r6
    i64.const -643556350
    i64.xor
    local.set $r6
    local.get $r7
    local.get $r3
    call 1
    local.set $r7
    local.get $r2
    i64.const -2328200397015397258
    i64.mul
    local.set $r2
    local.get $r4
    local.get $r5
    i64.mul
    local.set $r4
    local.get $r6
    local.get $r0
    i64.mul
    local.set $r6
    local.get $r3
    i64.const 25
    i64.rotr
    local.set $r3
    local.get $r1
    i64.const 36
    i64.rotr
    local.set $r1
    local.get $r0
    i64.const 1120150323
    i64.xor
    local.set $r0
    local.get $r5
    i64.const 15
    i64.rotr
    local.set $r5
    local.get $r3
    local.get $r1
    i64.const 2
    i64.shl
    i64.add
    local.set $r3
    local.get $r5
    i64.const 1119734597
    i64.xor
    local.set $r5
    local.get $r3
    i64.const 5
    i64.rotr
    local.set $r3
    local.get $r2
    local.get $r5
    i64.mul
    local.set $r2
    local.get $r7
    local.get $r5
    i64.mul
    local.set $r7
    local.get $r3
    local.get $r4
    i64.mul
    local.set $r3
    local.get $r5
    i64.const 37
    i64.rotr
    local.set $r5
    local.get $r0
    i64.const 30
    i64.rotr
    local.set $r0
    local.get $r1
    i64.const -1312014687
    i64.xor
    local.set $r1
    local.get $r4
    local.get $r0
    i64.const 0
    i64.shl
    i64.add
    local.set $r4
    local.get $r1
    i64.const 6
    i64.rotr
    local.set $r1
    local.get $r6
    i64.const 613527147
    i64.xor
    local.set $r6
    local.get $r1
    local.get $r0
    i64.const 2
    i64.shl
    i64.add
    local.set $r1
    local.get $r6
    local.get $r5
    i64.mul
    local.set $r6
    local.get $r5
    local.get $r2
    i64.mul
    local.set $r5
    local.get $r4
    local.get $r0
    i64.mul
    local.set $r4
    local.get $r2
    i64.const 12
    i64.rotr
    local.set $r2
    local.get $r0
    local.get $r2
    i64.const 3
    i64.shl
    i64.add
    local.set $r0
    local.get $r7
    i64.const 1876295976
    i64.xor
    local.set $r7
    local.get $r0
    local.get $r2
    i64.xor
    local.set $r0
    local.get $r7
    i64.const 59
    i64.rotr
    local.set $r7
    local.get $r7
    i64.const 445580504
    i64.xor
    local.set $r7
    local.get $r1
    local.get $r2
    call 2
    local.set $r1
    local.get $r2
    i64.const -9013678615605391665
    i64.mul
    local.set $r2
    local.get $r7
    local.get $r0
    i64.mul
    local.set $r7
    local.get $r0
    local.get $r6
    i64.mul
    local.set $r0
    local.get $r3
    local.get $r6
    i64.const 0
    i64.shl
    i64.add
    local.set $r3
    local.get $r4
    i64.const -629439180
    i64.xor
    local.set $r4
    local.get $r3
    local.get $r6
    i64.xor
    local.set $r3
    local.get $r0
    local.get $r6
    i64.xor
    local.set $r0
    local.get $r3
    local.get $r5
    i64.xor
    local.set $r3
    local.get $r3
    i64.const 1951856685
    i64.xor
    local.set $r3
    local.get $r5
    local.get $r4
    i64.sub
    local.set $r5
    local.get $r6
    local.get $r4
    i64.xor
    local.set $r6
    local.get $r5
    local.get $r6
    i64.xor
    local.set $r5
    local.get $r4
    local.get $r3
    i64.mul
    local.set $r4
    local.get $r5
    local.get $r0
    i64.mul
    local.set $r5
    local.get $r6
    local.get $r7
    i64.mul
    local.set $r6
    local.get $item_number
    i64.const 4194303
    i64.and
    i32.wrap_i64
    i32.const 6
    i32.shl
    i32.const 51872
    i32.add
    local.set $mixblock_ptr
    local.get $mixblock_ptr
    i64.load align=4
    local.get $r0
    i64.xor
    local.set $r0
    local.get $mixblock_ptr
    i64.load offset=8 align=4
    local.get $r1
    i64.xor
    local.set $r1
    local.get $mixblock_ptr
    i64.load offset=16 align=4
    local.get $r2
    i64.xor
    local.set $r2
    local.get $mixblock_ptr
    i64.load offset=24 align=4
    local.get $r3
    i64.xor
    local.set $r3
    local.get $mixblock_ptr
    i64.load offset=32 align=4
    local.get $r4
    i64.xor
    local.set $r4
    local.get $mixblock_ptr
    i64.load offset=40 align=4
    local.get $r5
    i64.xor
    local.set $r5
    local.get $mixblock_ptr
    i64.load offset=48 align=4
    local.get $r6
    i64.xor
    local.set $r6
    local.get $mixblock_ptr
    i64.load offset=56 align=4
    local.get $r7
    i64.xor
    local.set $r7
    local.get $r4
    local.set $item_number
    local.get $r0
    local.get $r1
    local.get $r2
    local.get $r3
    local.get $r4
    local.get $r5
    local.get $r6
    local.get $r7)
  (func (;1;) (type 1) (param i64 i64) (result i64)
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
  (func (;2;) (type 1) (param i64 i64) (result i64)
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
  (export "d" (func 0)))
