COMMON:=../common/lib.zktc.c
KERNEL:=../kernel/task.zktc.c ../kernel/interrupt_handler.zktc.c ../kernel/init.zktc.c \
../kernel/dispatch.zktc.c ../kernel/memory.zktc.c ../kernel/kernel.zktc.c
APP:=usermain.zktc.c
SRCS:=$(COMMON) $(KERNEL) $(APP)

ASM:=app.asm
TARGET:=app.mem


.PHONY: all
all: $(TARGET)

$(TARGET): $(ASM)
	zktc-asm $(ASM) -o $(TARGET) 
	
$(ASM): $(SRCS)
	zktc-c-com $(SRCS) -o $(ASM)

.PHONY: clean
clean:
	rm -rf *.asm
	rm -rf *.mem

