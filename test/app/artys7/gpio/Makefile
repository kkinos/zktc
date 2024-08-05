SRC_DIR:=../../../../src
INCS:=$(SRC_DIR)/include/def.sv
TOP:=$(SRC_DIR)/top/zktc_artys7.sv
SRCS:=$(wildcard $(SRC_DIR)/*.sv)

PROG_DIR:=../../../../program
BOOT_DIR:=../../testboot
KERNEL_DIR:=$(PROG_DIR)/kernel
COMMON:=$(wildcard $(PROG_DIR)/common/*.zktc.c)
BOOT:=$(wildcard $(BOOT_DIR)/*.zktc.c)
KERNEL:=$(KERNEL_DIR)/queue.zktc.c $(KERNEL_DIR)/task.zktc.c $(KERNEL_DIR)/interrupt_handler.zktc.c $(KERNEL_DIR)/init.zktc.c \
$(KERNEL_DIR)/dispatch.zktc.c $(KERNEL_DIR)/memory.zktc.c $(KERNEL_DIR)/semaphore.zktc.c $(KERNEL_DIR)/kernel.zktc.c

APP:=gpio_tb.zktc.c

TARGET:=gpio_tb.vcd

.SILENT:

.PHONY: all
all: $(TARGET)

gpio_tb.vcd: gpio_tb
	vvp $<

gpio_tb: gpio_tb.sv $(TOP) $(SRCS) $(INCS) boot1.mem boot2.mem ram1.mem ram2.mem
	iverilog -g 2012 -o $@ -s $@ $< $(TOP) $(SRCS) -I $(SRC_DIR)  

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
	rm -f *.vcd *.mem *.asm gpio_tb
