SAMPLEDIRS:=sample/led sample/gpio sample/mandelbrot sample/hangman 

.PHONY: all
all: $(SAMPLEDIRS)

$(SAMPLEDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: clean $(SAMPLEDIRS)
clean: $(SAMPLEDIRS)

