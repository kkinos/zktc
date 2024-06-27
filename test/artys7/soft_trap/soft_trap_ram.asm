lih x1, 0x8000@h
addi x2, x0, 5

// cannot trap
trap

// led on
sw x2, x1, 0
rfi