# Original #673 build cohort. Every recipe is recursive for GNU make's inherited pipe protocol.
.PHONY: all compile_files
jobs := $(addprefix budget_,0 1 2 3 4 5 6 7)
all:
	+$(dir $(lastword $(MAKEFILE_LIST)))usage_record $(DIRECTORY)/cohort.usage $(MAKE) --no-print-directory -f $(lastword $(MAKEFILE_LIST)) compile_files
compile_files: $(jobs)
budget_%:
	+$(dir $(lastword $(MAKEFILE_LIST)))usage_record $(DIRECTORY)/$*.usage $(LAUNCH) $(COMPILER) $(OPTIONS) --time-stages -c $(if $(filter $*,$(LARGE_INDICES)),$(LARGE),$(SMALL)) -o $(DIRECTORY)/$*.o 2> $(DIRECTORY)/$*.stderr
