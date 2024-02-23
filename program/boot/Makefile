SRCS:=init.zktc.c boot.zktc.c
ASM:=boot.asm
TARGET:=boot.mem


.PHONY: all
all: $(TARGET)

$(TARGET): $(ASM)
	zktc-asm $(ASM) -o $(TARGET) -b 0xb000
	
$(ASM): $(SRCS)
	zktc-c-com $(SRCS) -o $(ASM)

.PHONY: clean
clean:
	rm -rf *.asm
	rm -rf *.mem

