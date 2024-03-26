SRC_DIR:=../../src
INCS:=$(SRC_DIR)/include/def.sv
SRCS:=$(SRC_DIR)/core.sv $(SRC_DIR)/decode.sv $(SRC_DIR)/execute.sv \
	$(SRC_DIR)/registers.sv $(SRC_DIR)/c_registers.sv
ASM_DIR:=asm
ASMS:=$(sort $(wildcard $(ASM_DIR)/*.asm))
TARGET:=$(patsubst %.asm, %_tb.vcd, $(notdir $(ASMS)))

.SILENT:

.PHONY: all
all: $(TARGET)

%_tb.vcd: %_tb
	vvp $<

%_tb: %_tb.sv $(SRCS) $(INCS) %_ram1.mem %_ram2.mem
	iverilog -g 2012 -o $@ -s $@ $< $(SRCS) -I $(SRC_DIR)

%_tb.sv: inst_tb_template.sv
	sed -e 's/inst/$*/' $< > $@

%_ram1.mem: $(ASM_DIR)/%.asm
	zktc-asm $< -o $*.mem -b 0xb000
	awk 'NR % 2 != 0' $*.mem > $@

%_ram2.mem: $(ASM_DIR)/%.asm
	zktc-asm $< -o $*.mem -b 0xb000
	awk 'NR % 2 == 0' $*.mem > $@


.PHONY: clean
clean:
	rm -f *.vcd *.mem
