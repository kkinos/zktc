ZKTC is a 16-bit CPU implemented in SystemVerilog. It can run on an FPGA. The system includes peripherals such as UART and GPIO, and it also supports interrupts.

- [Features](#features)
- [Memory Map](#memory-map)
- [Registers](#registers)
  - [General Registers (GR)](#general-registers-gr)
  - [Control Registers (CR)](#control-registers-cr)
    - [PC (Program Counter)](#pc-program-counter)
    - [SP (Stack Pointer)](#sp-stack-pointer)
    - [PSR (Processor Status Register)](#psr-processor-status-register)
    - [TR (Timer Register)](#tr-timer-register)
    - [TLR (Timer Low Register)](#tlr-timer-low-register)
    - [THR (Timer High Register)](#thr-timer-high-register)
    - [PPC (Previous Program Counter)](#ppc-previous-program-counter)
    - [PPSR (Previous Processor Status Register)](#ppsr-previous-processor-status-register)
- [Instruction Set](#instruction-set)
  - [R Instructions](#r-instructions)
  - [I5 Instructions](#i5-instructions)
  - [I8 Instructions](#i8-instructions)
  - [C1 Instructions](#c1-instructions)
  - [C2 Instructions](#c2-instructions)
- [Exceptions](#exceptions)
  - [Reset](#reset)
  - [Undefined Instruction Exception](#undefined-instruction-exception)
  - [Software Interrupt (Trap Instruction)](#software-interrupt-trap-instruction)
  - [Hardware Interrupt](#hardware-interrupt)
- [Peripherals](#peripherals)

# Features

- 16-bit \* 8 general registers
- 64K byte address space
  - Boot area is 20K bytes
  - RAM area is 32K bytes
- Little-endian

# Memory Map

![](img/memorymap.drawio.png)

# Registers

The internal registers of ZKTC are classified into two types: general registers and control registers.

## General Registers (GR)

There are eight 16-bit registers.

![](img/gr.drawio.png)

| Name | Description           |
| ---- | --------------------- |
| zero | Constant value zero   |
| ra   | Return address        |
| fp   | Frame pointer         |
| a0   | Argument/Return value |
| a1   | Argument              |
| a2   | Argument              |
| t0   | Temporary register    |
| t1   | Temporary register    |

## Control Registers (CR)

### PC (Program Counter)

A 16-bit register that points to the address of the next instruction to be executed.

### SP (Stack Pointer)

A 16-bit register operated by the POP/PUSH instructions. It increments by 2 with the POP instruction and decrements by 2 with the PUSH instruction.

### PSR (Processor Status Register)

![](img/psr.drawio.png)

A 16-bit register representing the current state of the processor.

Bit 0 indicates whether interrupts are enabled or disabled. 0 means enabled, 1 means disabled. It is set to 1 when an interrupt occurs.

Bit 1 indicates the presence of an undefined instruction exception. It is set to 1 by an undefined instruction exception.

Bit 2 indicates the presence of a software interrupt (trap instruction). It is set to 1 by a software interrupt.

Bit 3 indicates the presence of a hardware interrupt. It is set to 1 by a hardware interrupt.

Bit 15 is set to 1 by reset in the emulator environment.

### TR (Timer Register)

A 32-bit register that counts up with the processor clock.

It is indirectly operated by TLR for the lower 16 bits and THR for the upper 16 bits.

After 0xFFFFFFFF, it resets to 0.

### TLR (Timer Low Register)

A 16-bit register used to operate TR.

### THR (Timer High Register)

A 16-bit register used to operate TR.

### PPC (Previous Program Counter)

A 16-bit register that is automatically copied from PC when an interrupt occurs.

### PPSR (Previous Processor Status Register)

A 16-bit register that is automatically copied from PSR when an interrupt occurs.

# Instruction Set

ZKTC has five instruction formats.

## R Instructions

Instructions that perform operations between registers.

![](img/r.drawio.png)

| Opcode | Function | Instruction            | Mnemonic | Operation                          | Assembly   |
| ------ | -------- | ---------------------- | -------- | ---------------------------------- | ---------- |
| 00000  | 00001    | move data              | MOV      | x[rd] = x[rs]                      | mov rd, rs |
| 00000  | 00010    | add                    | ADD      | x[rd] = x[rd] + x[rs]              | add rd, rs |
| 00000  | 00011    | sub                    | SUB      | x[rd] = x[rd] - x[rs]              | sub rd, rs |
| 00000  | 00100    | and                    | AND      | x[rd] = x[rd] & x[rs]              | and rd, rs |
| 00000  | 00101    | or                     | OR       | x[rd] = x[rd] \| x[rs]             | or rd, rs  |
| 00000  | 00110    | xor                    | XOR      | x[rd] = x[rd] \^ x[rs]             | xor rd, rs |
| 00000  | 00111    | shift left logical     | SLL      | x[rd] = x[rd] << x[rs]             | sll rd, rs |
| 00000  | 01000    | shift right logical    | SRL      | x[rd] = x[rd] >><sub>u</sub> x[rs] | srl rd, rs |
| 00000  | 01001    | shift right arithmetic | SRA      | x[rd] = x[rd] >><sub>s</sub> x[rs] | sra rd, rs |

## I5 Instructions

Instructions that take a 5-bit immediate value within the instruction.

![](img/i5.drawio.png)

| Opcode | Instruction                     | Mnemonic | Operation                                      | Assembly         |
| ------ | ------------------------------- | -------- | ---------------------------------------------- | ---------------- |
| 00001  | add immediate                   | ADDI     | x[rd] = x[rs] + imm                            | addi rd, rs, imm |
| 00010  | sub immediate                   | SUBI     | x[rd] = x[rs] - imm                            | subi rd, rs, imm |
| 00011  | branch if equal                 | BEQ      | if(x[rd] == x[rs]) PC += sext(imm)             | beq rd, rs, imm  |
| 00100  | branch if not equal             | BNQ      | if(x[rd] != x[rs]) PC += sext(imm)             | bnq rd, rs, imm  |
| 00101  | branch if less than             | BLT      | if(x[rd] <<sub>s</sub> x[rs]) PC += sext(imm)  | blt rd, rs, imm  |
| 00110  | branch if greater than or equal | BGE      | if(x[rd] >=<sub>s</sub> x[rs]) PC += sext(imm) | bge rd, rs, imm  |
| 00111  | BLT unsigned                    | BLTU     | if(x[rd] <<sub>u</sub> x[rs]) PC += sext(imm)  | bltu rd, rs, imm |
| 01000  | BGE unsigned                    | BGEU     | if(x[rd] >=<sub>u</sub> x[rs]) PC += sext(imm) | bgeu rd, rs, imm |
| 01001  | jump and link register          | JALR     | x[rd] = PC + 2, PC = x[rs] + sext(imm)         | jalr rd, rs, imm |
| 01010  | load half word                  | LH       | x[rd] = sext(M[x[rs] + sext(imm)][7:0])        | lh rd, rs, imm   |
| 01011  | load half word unsigned         | LHU      | x[rd] = {8'b0, M[x[rs] + sext(imm)][7:0]}      | lhu rd, rs, imm  |
| 01100  | load word                       | LW       | x[rd] = M[x[rs] + sext(imm)]                   | lw rd, rs, imm   |
| 01101  | store half word                 | SH       | M[x[rs] + sext(imm)] = x[rd][7:0]              | sh rd, rs, imm   |
| 01110  | store word                      | SW       | M[x[rs] + sext(imm)] = x[rd]                   | sw rd, rs, imm   |

## I8 Instructions

Instructions that take an 8-bit immediate value within the instruction.

![](img/i8.drawio.png)

| Opcode | Instruction               | Mnemonic | Operation                       | Assembly    |
| ------ | ------------------------- | -------- | ------------------------------- | ----------- |
| 10000  | jump and link             | JAL      | x[rd] = PC + 2, PC += sext(imm) | jal rd, imm |
| 10001  | load immediate low 8 bit  | LIL      | x[rd] = {8'b0, imm}             | lil rd, imm |
| 10010  | load immediate high 8 bit | LIH      | x[rd] = {imm ,8'b0}             | lih rd, imm |

## C1 Instructions

Instructions to operate control registers.

![](img/c1.drawio.png)

| Opcode | Function | Instruction | Mnemonic | Operation              | Assembly |
| ------ | -------- | ----------- | -------- | ---------------------- | -------- |
| 11110  | 00001    | push        | PUSH     | SP -= 2, M[SP] = x[rd] | push rd  |
| 11110  | 00010    | pop         | POP      | x[rd] = M[SP], SP += 2 | pop rd   |
| 11110  | 00011    | read PC     | RPC      | x[rd] = PC + 2         | rpc rd   |
| 11110  | 00100    | read SP     | RSP      | x[rd] = SP             | rsp rd   |
| 11110  | 00101    | read PSR    | RPSR     | x[rd] = PSR            | rpsr rd  |
| 11110  | 00110    | read TLR    | RTLR     | x[rd] = TLR            | rtlr rd  |
| 11110  | 00111    | read THR    | RTHR     | x[rd] = THR            | rthr rd  |
| 11110  | 01000    | read PPC    | RPPC     | x[rd] = PPC            | rppc rd  |
| 11110  | 01001    | read PPSR   | RPPSR    | x[rd] = PPSR           | rppsr rd |
| 11110  | 01010    | write SP    | WSP      | SP = x[rd]             | wsp rd   |
| 11110  | 01011    | write PSR   | WPSR     | PSR = x[rd]            | wpsr rd  |
| 11110  | 01100    | write TLR   | WTLR     | TLR = x[rd]            | wtlr rd  |
| 11110  | 01101    | write THR   | WTHR     | THR = x[rd]            | wthr rd  |
| 11110  | 01110    | write PPC   | WPPC     | WPPC = x[rd]           | wppc rd  |
| 11110  | 01111    | write PPSR  | WPPSR    | WPPSR = x[rd]          | wppsr rd |

## C2 Instructions

Instructions to operate control registers.

![](img/c2.drawio.png)

| Opcode | Function | Instruction                         | Mnemonic | Operation            | Assembly |
| ------ | -------- | ----------------------------------- | -------- | -------------------- | -------- |
| 11111  | 00001    | copy PPC to PC and copy PPSR to PSR | RFI      | PC = PPC, PSR = PPSR | rfi      |
| 11111  | 00010    | read TR                             | RTR      | {THR, TLR} = TR      | rtr      |
| 11111  | 00011    | write TR                            | WTR      | TR = {THR, TLR}      | wtr      |

# Exceptions

Exceptions include reset, undefined instruction exception, software interrupt (trap instruction), and hardware interrupt.

Reset is always executed, but undefined instruction exceptions, software interrupts, and hardware interrupts are masked (disabled) if bit 0 of PSR is set to 1.

## Reset

Starts immediately when RES changes to High. The operation is as follows:

1. CPU and peripheral module registers are initialized.
2. PC is set to 0xB000 (start of the boot area) and execution begins.

## Undefined Instruction Exception

Starts by executing an undefined instruction. The operation is as follows:

1. The PC pointing to the next instruction of the undefined instruction is copied to PPC, and PSR is copied to PPSR.
2. Bit 0 of PSR is set to 1, and bit 1 is set to 1.
3. PC is set to 0x0000 (start of the RAM area) and execution begins.

## Software Interrupt (Trap Instruction)

Starts by executing a trap instruction. The operation is as follows:

1. The PC pointing to the next instruction of the trap instruction is copied to PPC, and PSR is copied to PPSR.
2. Bit 0 of PSR is set to 1, and bit 2 is set to 1.
3. PC is set to 0x0000 (start of the RAM area) and execution begins.

The trap instruction is an instruction with all bit patterns set to 1.

## Hardware Interrupt

When UART receive interrupts are enabled and data is received, the process starts. The operation is as follows:

1. The PC at the time of execution is copied to PPC, and PSR is copied to PPSR.
2. Bit 0 of PSR is set to 1, and bit 3 is set to 1.
3. PC is set to 0x0000 (start of the RAM area) and execution begins.

# Peripherals

ZKTC has peripherals such as LED, UART, and GPIO, which can be operated by MMIO.

| Address | Function                                                                                              | R/W |
| ------- | ----------------------------------------------------------------------------------------------------- | --- |
| 0x8000  | Status of LED0,1,2,3 from the least significant bit (lower 4 bits) <br>0: off 1: on                   | W   |
| 0x8100  | UART transmission status (lower 1 bit) <br>0: not busy 1: busy                                        | R   |
| 0x8102  | UART transmission start (lower 1 bit) <br>0: not start 1: start                                       | W   |
| 0x8104  | UART transmission data (lower 8 bits)                                                                 | W   |
| 0x8110  | UART reception status (lower 1 bit) <br>0: not busy 1: busy                                           | R   |
| 0x8112  | UART reception interrupt (lower 1 bit) <br>0: disable 1: enable                                       | W   |
| 0x8114  | Validity of UART reception data (lower 1 bit) <br>0: invalid 1: valid                                 | R   |
| 0x8116  | UART reception data (lower 8 bits)                                                                    | R   |
| 0x8200  | Output of GPIO0,1,2,3,4,5,6,7 from the least significant bit (lower 8 bits) <br>0: low 1: high        | W   |
| 0x8202  | Input of GPIO0,1,2,3,4,5,6,7 from the least significant bit (lower 8 bits) <br>0: low 1: high         | R   |
| 0x8204  | Direction of GPIO0,1,2,3,4,5,6,7 from the least significant bit (lower 8 bits) <br>0: output 1: input | W   |
