SUBDIRS:=boot app

.PHONY: all $(SUBDIRS) 
all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)


.PHONY: clean $(SUBDIRS)
clean: $(SUBDIRS)