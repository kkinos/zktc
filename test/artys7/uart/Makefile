SRC_DIR:=../../../src
INCS:=$(SRC_DIR)/include/def.sv
SRCS:=$(SRC_DIR)/zktc_artys7.sv $(SRC_DIR)/core.sv $(SRC_DIR)/decode.sv \
	$(SRC_DIR)/execute.sv $(SRC_DIR)/registers.sv $(SRC_DIR)/c_registers.sv \
	$(SRC_DIR)/boot.sv $(SRC_DIR)/ram.sv $(SRC_DIR)/uart.sv $(SRC_DIR)/uart_tx.sv \
	$(SRC_DIR)/uart_rx.sv

PROG_DIR:=../../../program
COMMON:=$(PROG_DIR)/common/lib.zktc.c
BOOT_DIR:=$(PROG_DIR)/boot
BOOT:=$(BOOT_DIR)/boot.zktc.c $(BOOT_DIR)/init.zktc.c
KERNEL_DIR:=$(PROG_DIR)/kernel
KERNEL:=$(KERNEL_DIR)/queue.zktc.c $(KERNEL_DIR)/task.zktc.c $(KERNEL_DIR)/interrupt_handler.zktc.c $(KERNEL_DIR)/init.zktc.c \
$(KERNEL_DIR)/dispatch.zktc.c $(KERNEL_DIR)/memory.zktc.c $(KERNEL_DIR)/semaphore.zktc.c $(KERNEL_DIR)/kernel.zktc.c
APP:=usermain.zktc.c

TARGET:=uart_tb.vcd

.SILENT:

.PHONY: all
all: $(TARGET)

uart_tb.vcd: uart_tb
	vvp $<

uart_tb: uart_tb.sv $(SRCS) $(INCS) boot1.mem boot2.mem ram1.mem ram2.mem
	iverilog -g 2012 -o $@ -s $@ $< $(SRCS) -I $(SRC_DIR)  

boot1.mem: $(COMMON) $(BOOT)
	zktc-c-com $(COMMON) $(BOOT) -o boot.asm
	zktc-asm boot.asm -o boot.mem -b 0xb000
	awk 'NR % 2 != 0' boot.mem > $@

boot2.mem: $(COMMON) $(BOOT)
	zktc-c-com $(COMMON) $(BOOT) -o boot.asm
	zktc-asm boot.asm -o boot.mem -b 0xb000
	awk 'NR % 2 == 0' boot.mem > $@

ram1.mem: $(COMMON) $(KERNEL) $(APP)
	zktc-c-com $(COMMON) $(KERNEL) $(APP) -o ram.asm
	zktc-asm ram.asm -o ram.mem -b 0x0000
	awk 'NR % 2 != 0' ram.mem > $@

ram2.mem: $(COMMON) $(KERNEL) $(APP)
	zktc-c-com $(COMMON) $(KERNEL) $(APP) -o ram.asm
	zktc-asm ram.asm -o ram.mem -b 0x0000
	awk 'NR % 2 == 0' ram.mem > $@

.PHONY: clean
clean:
	rm -f *.vcd *.mem *.asm uart_tb
