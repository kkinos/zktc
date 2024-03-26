TESTDIRS:=led uart gpio

.PHONY: all
all: $(TESTDIRS)

$(TESTDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: clean $(TESTDIRS)
clean: $(TESTDIRS)
