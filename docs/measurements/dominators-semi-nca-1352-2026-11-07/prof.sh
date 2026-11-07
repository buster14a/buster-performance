#!/bin/sh
# Profile one --tier1 compile of an #1352 input with the SEMI-NCA build (run under the lock): stages and top symbols.
cd ~/buster-fast-bench/1352-claude || exit 1
input=$1
taskset -c 2 ./build/compiler -c --tier1 --time-stages -o /tmp/1352-claude.o inputs/$input.c 2> prof-stages.txt
taskset -c 2 perf record -q -e cycles:u -o prof.data ./build/compiler -c --tier1 -o /tmp/1352-claude.o inputs/$input.c
perf report -i prof.data --no-children --percent-limit 1 --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -25 > prof-top.txt
