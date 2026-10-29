#!/bin/bash
# profile.sh's runs, in its directory.
m=$HOME/buster-fast-bench/refine-claude/inputs/musl
flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
C=$HOME/buster-fast-bench/units-152-claude/exp/tree-final/build/compiler
units=$(cat units.txt)
rm -f *.o; taskset -c 0-7 perf record -q -g -F 4999 -o musl8.data $C --lanes 8 -c $flags $units 2> /dev/null; echo "record8 status=$?"
rm -f *.o; taskset -c 0-7 perf stat -x, -e task-clock,context-switches,cpu-migrations,page-faults -o stat8.csv $C --lanes 8 -c $flags $units 2> /dev/null; echo "stat8 status=$?"
rm -f *.o; taskset -c 0-7 perf stat -x, -e task-clock,context-switches,cpu-migrations,page-faults -o stat1.csv $C --lanes 1 -c $flags $units 2> /dev/null; echo "stat1 status=$?"
rm -f *.o; taskset -c 0-7 strace -f -c -o strace8.txt $C --lanes 8 -c $flags $units 2> /dev/null; echo "strace8 status=$?"
rm -f *.o
