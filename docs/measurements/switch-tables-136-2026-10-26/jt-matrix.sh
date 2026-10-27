#!/bin/bash
# The four executables' -c of sqlite3.c in one hold of the lock (about 20 s), pinned to CPU 2, six rounds of a
# perf stat -r 3 of each, the order rotated by round: main; the switched executable with the tables off (main's work,
# main's object, another compile of the code); the same with them on (the tables' work); and the head (the tables and
# the object's temporaries).
export EXCLUSIVE_OWNER=claude-switch-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
unset CPATH C_INCLUDE_PATH
~/buster-fast-bench/exclusive.sh bash -c '
    B=~/buster-fast-bench
    Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
    variants=(main off on head)
    for round in 1 2 3 4 5 6; do
        for k in 0 1 2 3; do
            v=${variants[$(( (round + k) % 4 ))]}
            case $v in
                main) e="env -u BUSTER_NO_JUMP_TABLES"; d=backend-136-main ;;
                off) e="env BUSTER_NO_JUMP_TABLES=1"; d=jump-136-toggle ;;
                on) e="env -u BUSTER_NO_JUMP_TABLES"; d=jump-136-toggle ;;
                head) e="env -u BUSTER_NO_JUMP_TABLES"; d=jump-136-head ;;
            esac
            taskset -c 2 $e perf stat -r 3 -x, -e instructions:u,cycles:u $B/$d/build/compiler -c -I$Q -o $B/$d/matrix.o $Q/sqlite3.c 2> $B/jump-136-head/matrix.tmp
            echo "$round $v $(grep instructions:u $B/jump-136-head/matrix.tmp | cut -d, -f1) $(grep cycles:u $B/jump-136-head/matrix.tmp | cut -d, -f1)"
        done
    done
    rm -f $B/jump-136-head/matrix.tmp
' 2>&1 | grep -E "^[0-9]+ (main|off|on|head) [0-9]+ [0-9]+$"
echo done
