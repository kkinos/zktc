SRC_DIR:=../../src
INCS:=$(SRC_DIR)/include/def.sv
SRCS:=$(SRC_DIR)/core.sv $(SRC_DIR)/decode.sv $(SRC_DIR)/execute.sv \
	$(SRC_DIR)/registers.sv $(SRC_DIR)/c_registers.sv
TARGET:=ill_inst_tb.vcd

.SILENT:

.PHONY: all
all: $(TARGET)

ill_inst_tb.vcd: ill_inst_tb
	vvp $<

ill_inst_tb: ill_inst_tb.sv $(SRCS) $(INCS)
	iverilog -g 2012 -o $@ -s $@ $< $(SRCS) -I $(SRC_DIR)

.PHONY: clean
clean:
	rm -f ill_inst_tb.vcd ill_inst_tb
