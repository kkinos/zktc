COMMON:=$(wildcard ../common/*.zktc.c)
BOOT:=init.zktc.c xmodem.zktc.c boot.zktc.c

ASM:=boot.asm
TARGET:=boot.mem boot1.mem boot2.mem


.PHONY: all
all: $(TARGET)

boot.mem: $(ASM)
	zktc-asm $(ASM) -o boot.mem -b 0xb000

boot1.mem: boot.mem
	awk 'NR % 2 != 0' boot.mem > $@

boot2.mem: boot.mem
	awk 'NR % 2 == 0' boot.mem > $@
	
$(ASM):$(COMMON) $(BOOT)
	zktc-c-com $(COMMON) $(BOOT) -o $(ASM)

.PHONY: clean
clean:
	rm -rf *.asm
	rm -rf *.mem

