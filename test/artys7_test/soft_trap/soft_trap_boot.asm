lih x1, 0x8000@h
addi x2, x0, 3

// led on
sw x2, x1, 0

// trap
trap

// return from trap

// led on again
lih x1, 0x8000@h
addi x2, x0, 7
sw x2, x1, 0