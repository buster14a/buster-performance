#!/bin/bash
# Controls for the head's cycles against main's (jt-head.sh), each interleaved in one hold of the lock, pinned to CPU 2,
# eight rounds of a perf stat -r 3 of each tree, the first alternating by round: -fsyntax-only of sqlite3.c, head
# against main, which reaches neither the lowering nor the object writer; then -c, head against the branch at 1e2bcae3
# (jump-136-claude), which the head changes only in the -c object's symbols and the driver's test.
export EXCLUSIVE_OWNER=claude-switch-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
for pair in "syntax backend-136-main jump-136-head" "compile jump-136-claude jump-136-head"; do
    set -- $pair
    $X bash -c '
        B=~/buster-fast-bench
        Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
        mode='"$1"'; a='"$2"'; b='"$3"'
        for round in 1 2 3 4 5 6 7 8; do
            if [ $((round % 2)) = 1 ]; then order="$a $b"; else order="$b $a"; fi
            for d in $order; do
                if [ $mode = syntax ]; then
                    taskset -c 2 perf stat -r 3 -x, -e instructions:u,cycles:u $B/$d/build/compiler -fsyntax-only -I$Q $Q/sqlite3.c 2> $B/jump-136-head/control.tmp
                else
                    taskset -c 2 perf stat -r 3 -x, -e instructions:u,cycles:u $B/$d/build/compiler -c -I$Q -o $B/$d/control.o $Q/sqlite3.c 2> $B/jump-136-head/control.tmp
                fi
                echo "$mode $round $d $(grep instructions:u $B/jump-136-head/control.tmp | cut -d, -f1) $(grep cycles:u $B/jump-136-head/control.tmp | cut -d, -f1)"
            done
        done
        rm -f $B/jump-136-head/control.tmp
    ' 2>&1 | grep -E "^(syntax|compile) [0-9]+ [a-z0-9-]+ [0-9]+ [0-9]+$"
done
echo done
