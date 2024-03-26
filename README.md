# ZKTC

[WIP]

ZKTC project is a hobby project that involves designing a CPU, creating a compiler for it, and running some programs on the CPU.

# ZKTC (CPU)

`./src`

16-bit CPU implemented in SystemVerilog.

[Document (Japanese)](docs/zktc_document_ja.md)

[Document (English)]()

# ZKTC-C-com (Compiler)

https://github.com/kkinos/zktc-c-com

ZKTC-C compiler implemented in Rust. ZKTC-C is a C-like programming language for ZKTC.

# Programs

`./program`

Some programs written in ZKTC-C that can be run on the ZKTC.

## Bootloader

`./program/boot`

Small bootloader for ZKTC that can copy applications transferred by XMODEM to RAM.

## Z-kernel (Kernel)

`./program/kernel`

Small kernel for ZKTC with support for multitasking, semaphores and memory management.

[Document (Japanese)](docs/z_kernel_document_ja.md)

[Document (English)]()

# Other Toolchain

- [zktc-asm](https://github.com/kkinos/zktc-asm) : ZKTC assembler
- [zktc-emu](https://github.com/kkinos/zktc-emu) : ZKTC emulator
