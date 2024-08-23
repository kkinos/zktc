TESTDIRS:=led uart gpio uart_interrupt

.PHONY: all
all: $(TESTDIRS)

$(TESTDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: clean $(TESTDIRS)
clean: $(TESTDIRS)
