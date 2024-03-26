SRC_DIR:=../../../src
INCS:=$(SRC_DIR)/include/def.sv
SRCS:=$(SRC_DIR)/zktc_artys7.sv $(SRC_DIR)/core.sv $(SRC_DIR)/decode.sv \
	$(SRC_DIR)/execute.sv $(SRC_DIR)/registers.sv $(SRC_DIR)/c_registers.sv \
	$(SRC_DIR)/boot.sv $(SRC_DIR)/ram.sv
TARGET:=led_tb.vcd

.SILENT:

.PHONY: all
all: $(TARGET)

led_tb.vcd: led_tb
	vvp $<

led_tb:led_tb.sv $(SRCS) $(INCS) boot1.mem boot2.mem
	iverilog -g 2012 -o $@ -s $@ $< $(SRCS) -I $(SRC_DIR)  

boot1.mem: led.asm
	zktc-asm $< -o led.mem -b 0xb000
	awk 'NR % 2 != 0' led.mem > $@

boot2.mem: led.asm
	zktc-asm $< -o led.mem -b 0xb000
	awk 'NR % 2 == 0' led.mem > $@

.PHONY: clean
clean:
	rm -f *.vcd *.mem led_tb
