SRC_DIR:=../../../src
INCS:=$(SRC_DIR)/include/def.sv
SRCS:=$(SRC_DIR)/zktc_artys7.sv $(SRC_DIR)/core.sv $(SRC_DIR)/decode.sv \
	$(SRC_DIR)/execute.sv $(SRC_DIR)/registers.sv $(SRC_DIR)/c_registers.sv \
	$(SRC_DIR)/boot.sv $(SRC_DIR)/ram.sv
TARGET:=soft_trap_tb.vcd

.SILENT:

.PHONY: all
all: $(TARGET)

soft_trap_tb.vcd: soft_trap_tb
	vvp $<

soft_trap_tb: soft_trap_tb.sv $(SRCS) $(INCS) boot1.mem boot2.mem ram1.mem ram2.mem
	iverilog -g 2012 -o $@ -s $@ $< $(SRCS) -I $(SRC_DIR)  

boot1.mem: soft_trap_boot.asm
	zktc-asm $< -o soft_trap.mem -b 0xb000
	awk 'NR % 2 != 0' soft_trap.mem > $@

boot2.mem: soft_trap_boot.asm
	zktc-asm $< -o soft_trap.mem -b 0xb000
	awk 'NR % 2 == 0' soft_trap.mem > $@

ram1.mem: soft_trap_ram.asm
	zktc-asm $< -o soft_trap.mem -b 0x0000
	awk 'NR % 2 != 0' soft_trap.mem > $@

ram2.mem: soft_trap_ram.asm
	zktc-asm $< -o soft_trap.mem -b 0x0000
	awk 'NR % 2 == 0' soft_trap.mem > $@

.PHONY: clean
clean:
	rm -f *.vcd *.mem soft_trap_tb
