SRC_DIR:=../../src
SRCS:=$(SRC_DIR)/uart_tx.sv $(SRC_DIR)/uart_rx.sv
TARGET:=uart_tb.vcd

.SILENT:

.PHONY: all
all: $(TARGET)

uart_tb.vcd: uart_tb
	vvp $<

uart_tb: uart_tb.sv $(SRCS)
	iverilog -g 2012 -o $@ -s $@ $< $(SRCS)

.PHONY: clean
clean:
	rm -f *.vcd uart_tb
