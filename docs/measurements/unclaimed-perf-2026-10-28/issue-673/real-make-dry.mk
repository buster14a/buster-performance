.PHONY: all
all:
	+$(COMPILER) --worker-budget 8 -c $(MISSING) -o $(OUTPUT)
