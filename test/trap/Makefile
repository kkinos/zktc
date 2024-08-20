SRC_DIR:=../../src
INCS:=$(SRC_DIR)/include/def.sv
SRCS:=$(SRC_DIR)/core.sv $(SRC_DIR)/decode.sv $(SRC_DIR)/execute.sv \
	$(SRC_DIR)/registers.sv $(SRC_DIR)/c_registers.sv
TARGET:=trap_tb.vcd

.SILENT:

.PHONY: all
all: $(TARGET)

trap_tb.vcd: trap_tb
	vvp $<

trap_tb: trap_tb.sv $(SRCS) $(INCS)
	iverilog -g 2012 -o $@ -s $@ $< $(SRCS) -I $(SRC_DIR)

.PHONY: clean
clean:
	rm -f trap_tb.vcd trap_tb
