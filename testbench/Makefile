SRC_DIR:=../src
SRCS:=$(SRC_DIR)/mem.sv $(SRC_DIR)/zktc.sv
TARGET:=mem_tb.vcd zktc_tb.vcd

.PHONY: all
all: $(TARGET)

mem_tb.vcd: mem_tb.vvp
	vvp $<

zktc_tb.vcd: zktc_tb.vvp
	vvp $<

mem_tb.vvp: mem_tb.sv $(SRCS)
	iverilog -g 2012 -o $@ $^

zktc_tb.vvp: zktc_tb.sv $(SRCS)
	iverilog -g 2012 -o $@ $^

.PHONY: clean
clean:
	rm -f *.vvp *.vcd
