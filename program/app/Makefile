SAMPLEDIRS:=sample/led sample/gpio

.PHONY: all
all: $(SAMPLEDIRS)

$(SAMPLEDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: clean $(SAMPLEDIRS)
clean: $(SAMPLEDIRS)

