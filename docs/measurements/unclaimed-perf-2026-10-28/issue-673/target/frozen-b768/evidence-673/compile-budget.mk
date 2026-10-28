# Original #673 build cohort. Every recipe is recursive for GNU make's inherited pipe protocol.
.PHONY: all
jobs := $(addprefix budget_,0 1 2 3 4 5 6 7)
all: $(jobs)
budget_%:
	+$(COMPILER) $(OPTIONS) --time-stages -c $(if $(filter $*,$(LARGE_INDICES)),$(LARGE),$(SMALL)) -o $(DIRECTORY)/$*.o 2> $(DIRECTORY)/$*.stderr
