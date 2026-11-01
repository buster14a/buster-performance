SHELL := /bin/bash
COMPILER := $(HOME)/buster-937/build/compiler
SQLITE := $(HOME)/buster-937-measure/sqlite3.c
MAIN := $(HOME)/buster-937-measure/main.c
HELPER := $(HOME)/buster-937-measure/helper.c
OUT := $(HOME)/buster-937-measure/out

.PHONY: compile link noop

compile:
	+$(COMPILER) -c $(SQLITE) -o $(OUT)/sqlite3.o

link:
	+$(COMPILER) $(SQLITE) $(MAIN) $(HELPER) -lm -o $(OUT)/program

noop:
	@true
