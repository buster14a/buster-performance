#!/bin/bash
# The compile A/B's crash: each compiler's -c of sqlite3.c (CI's flags), Tier 0 and Tier 1, exit codes; then a backtrace
# of the first crash under gdb (batch, the process started by gdb, not attached). One hold.
B=~/buster-fast-bench/2678-claude
corpus=~/buster-fast-bench/corpus-391e729af658
cd $B/bench
./lock.sh diagnose bash -c '
    unset CPATH C_INCLUDE_PATH
    corpus=$1; B=$2
    flags="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include"
    crashed=""
    for side in main-2ebfe68a head-e79a6338; do
        for tier in "" --tier1; do
            timeout -k 5 120 $B/$side/build/compiler -c $tier $flags -o /tmp/claude-2678-diag.o $corpus/sqlite/sqlite3.c > /dev/null 2>&1
            status=$?
            echo "compile $side tier=${tier:-0} exit $status"
            if [ $status -ge 128 ] && [ -z "$crashed" ]; then crashed="$side $tier"; fi
        done
    done
    if [ -n "$crashed" ]; then
        set -- $crashed
        echo "backtrace of $1 $2:"
        timeout -k 5 180 gdb -batch -ex run -ex bt -ex "info registers rip" --args $B/$1/build/compiler -c $2 $flags -o /tmp/claude-2678-diag.o $corpus/sqlite/sqlite3.c 2>&1 | tail -40
    fi
    rm -f /tmp/claude-2678-diag.o
    ulimit -a | grep -E "stack|virtual"' _ "$corpus" "$B" > diagnose.txt 2>&1
echo "finished" >> diagnose.txt
