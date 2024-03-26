// Opcode
`define OP_R 5'b00000

`define OP_ADDI 5'b00001
`define OP_SUBI 5'b00010
`define OP_BEQ 5'b00011
`define OP_BNQ 5'b00100
`define OP_BLT 5'b00101
`define OP_BGE 5'b00110
`define OP_BLTU 5'b00111
`define OP_BGEU 5'b01000
`define OP_JALR 5'b01001
`define OP_LH 5'b01010
`define OP_LHU 5'b01011
`define OP_LW 5'b01100
`define OP_SH 5'b01101
`define OP_SW 5'b01110

`define OP_JAL 5'b10000
`define OP_LIL 5'b10001
`define OP_LIH 5'b10010

`define OP_C1 5'b11110
`define OP_C2 5'b11111

// Function
`define FUNC_MOV 5'b00001
`define FUNC_ADD 5'b00010
`define FUNC_SUB 5'b00011
`define FUNC_AND 5'b00100
`define FUNC_OR 5'b00101
`define FUNC_XOR 5'b00110
`define FUNC_SLL 5'b00111
`define FUNC_SRL 5'b01000
`define FUNC_SRA 5'b01001

`define FUNC_PUSH 5'b00001
`define FUNC_POP 5'b00010
`define FUNC_RPC 5'b00011
`define FUNC_RSP 5'b00100
`define FUNC_RPSR 5'b00101
`define FUNC_RTLR 5'b00110
`define FUNC_RTHR 5'b00111
`define FUNC_RPPC 5'b01000
`define FUNC_RPPSR 5'b01001
`define FUNC_WSP 5'b01010
`define FUNC_WPSR 5'b01011
`define FUNC_WTLR 5'b01100
`define FUNC_WTHR 5'b01101
`define FUNC_WPPC 5'b01110
`define FUNC_WPPSR 5'b01111

`define FUNC_RFI 5'b00001
`define FUNC_RTR 5'b00010
`define FUNC_WTR 5'b00010


// Decoded Instruction
`define INST_MOV 6'b000000
`define INST_ADD 6'b000001
`define INST_SUB 6'b000010
`define INST_AND 6'b000011
`define INST_OR 6'b000100
`define INST_XOR 6'b000101
`define INST_SLL 6'b000110
`define INST_SRL 6'b000111
`define INST_SRA 6'b001000
`define INST_ADDI 6'b001001
`define INST_SUBI 6'b001010
`define INST_BEQ 6'b001011
`define INST_BNQ 6'b001100
`define INST_BLT 6'b001101
`define INST_BGE 6'b001110
`define INST_BLTU 6'b001111
`define INST_BGEU 6'b010000
`define INST_JALR 6'b010001
`define INST_LH 6'b010010
`define INST_LHU 6'b010011
`define INST_LW 6'b010100
`define INST_SH 6'b010101
`define INST_SW 6'b010110
`define INST_JAL 6'b010111
`define INST_LIL 6'b011000
`define INST_LIH 6'b011001
`define INST_PUSH 6'b011010
`define INST_POP 6'b011011
`define INST_RPC 6'b011100
`define INST_RSP 6'b011101
`define INST_RPSR 6'b011110
`define INST_RTLR 6'b011111
`define INST_RTHR 6'b100000
`define INST_RPPC 6'b100001
`define INST_RPPSR 6'b100010
`define INST_WSP 6'b100011
`define INST_WPSR 6'b100100
`define INST_WTLR 6'b100101
`define INST_WTHR 6'b100110
`define INST_WPPC 6'b100111
`define INST_WPPSR 6'b101000
`define INST_RFI 6'b101001
`define INST_RTR 6'b101010
`define INST_WTR 6'b101011

`define INST_NOP 6'b111111

