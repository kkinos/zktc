TESTDIRS:=led soft_trap app

.PHONY: all
all: $(TESTDIRS)

$(TESTDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: clean $(TESTDIRS)
clean: $(TESTDIRS)
