SRC_DIR:=../src
SRCS:=$(SRC_DIR)/mem.sv
TARGET:=mem_tb.vcd

.PHONY: all
all: $(TARGET)

mem_tb.vcd: mem_tb.vvp
	vvp $<

mem_tb.vvp: mem_tb.sv $(SRCS)
	iverilog -g 2012 -o $@ $^

.PHONY: clean
clean:
	rm -f *.vvp *.vcd
