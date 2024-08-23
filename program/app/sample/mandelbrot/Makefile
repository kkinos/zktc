COMMON:=$(wildcard ../../../common/*.zktc.c)
KERNEL_DIR:=../../../kernel
KERNEL:=$(KERNEL_DIR)/queue.zktc.c $(KERNEL_DIR)/task.zktc.c $(KERNEL_DIR)/interrupt_handler.zktc.c $(KERNEL_DIR)/interrupt_entry.zktc.c $(KERNEL_DIR)/init.zktc.c \
$(KERNEL_DIR)/dispatch.zktc.c $(KERNEL_DIR)/memory.zktc.c $(KERNEL_DIR)/semaphore.zktc.c $(KERNEL_DIR)/kernel.zktc.c

APP:=mandelbrot.zktc.c

ASM:=mandelbrot.asm
TARGET:=mandelbrot.mem mandelbrot.bin


.PHONY: all
all: $(TARGET)

mandelbrot.bin: mandelbrot.mem
	cat mandelbrot.mem | xxd -r -p > mandelbrot.bin

mandelbrot.mem: $(ASM)
	zktc-asm $(ASM) -o $@ 
	
$(ASM): $(COMMON) $(KERNEL) $(APP)
	zktc-c-com $(COMMON) $(KERNEL) $(APP) -o $(ASM)

.PHONY: clean
clean:
	rm -rf *.asm
	rm -rf *.mem
	rm -rf *.bin

