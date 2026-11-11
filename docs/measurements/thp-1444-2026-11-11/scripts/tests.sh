#!/bin/sh
# #1444 item 3: the fast checks of the change on bss2's placement 0, one hold of the 9700X's lock.
d=~/buster-fast-bench/1444-claude-thp
. $d/env.sh
C=$d/shifts-bss2/compiler-0
T=$d/tree-bss2
cd $T
~/buster-fast-bench/exclusive.sh sh -c "
    taskset -c 0-7 $C test-lanes 2>&1 | tail -3; echo test-lanes \$?
    taskset -c 0-7 $C test-check-lanes 2>&1 | tail -3; echo test-check-lanes \$?
    taskset -c 0-7 $C test-checker-driver --executable $C --part 1/4 --in-process 2>&1 | tail -2
    taskset -c 0-7 $C -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c; echo main.c \$?
    BUSTER_HUGE_PAGES=0 taskset -c 2 $C -fsyntax-only $d/inputs/hello.c; echo huge0 \$?
    taskset -c 2 $C parse -fsyntax-only $d/inputs/hello.c; echo parse \$?" > $d/results/tests-bss2.txt 2>&1
