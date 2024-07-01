TESTDIRS:=led soft_trap app uart

.PHONY: all
all: $(TESTDIRS)

$(TESTDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: clean $(TESTDIRS)
clean: $(TESTDIRS)
