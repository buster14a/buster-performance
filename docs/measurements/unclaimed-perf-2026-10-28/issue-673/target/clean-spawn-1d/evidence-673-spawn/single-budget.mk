# Original #673 spare-token control. A single recipe leaves make's other slots available.
.PHONY: all
all:
	+$(LAUNCH) $(COMPILER) $(OPTIONS) --time-stages -c $(SOURCE) -o $(DIRECTORY)/sqlite.o 2> $(DIRECTORY)/sqlite.stderr
