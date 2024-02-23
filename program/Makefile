SUBDIRS:=boot app

.PHONY: all $(SUBDIRS) 
all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: run
run: 
	zktc-emu boot/boot.mem --ram app/app.mem

.PHONY: clean $(SUBDIRS)
clean: $(SUBDIRS)