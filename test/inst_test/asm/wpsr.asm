lil x7, 0xfffe@l
lih x6, 0xfffe@h
or x7, x6 // x7 = 0xfffe

lil x6, finish@l
lih x5, finish@h
or x6, x5 // x6 = finish

lil x5, pass@l
lih x4, pass@h
or x5, x4 // x5 = pass

lil x4, fail@l
lih x3, fail@h
or x4, x3 // x4 = fail

lil x3, expect@l
lih x2, expect@h
or x3, x2
lw x3, x3, 0 // x3 expect

// wpsr test

addi x1, x0, 1
wpsr x1
rpsr x2

// 

beq x2, x3, 4
jalr x0, x4, 0
jalr x0, x5, 0

expect:
	.word 0x0001

pass: // if test passed M[0xfffe] = 1
	addi x2, x0, 1
	sw x2, x7,0
	jalr x0, x6, 0

fail: // if test failed M[0xfffe] = 2
	addi x2, x0, 2
	sw x2, x7,0
	jalr x0, x6, 0

finish:
