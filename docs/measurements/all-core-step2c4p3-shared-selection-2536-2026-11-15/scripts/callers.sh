#!/bin/bash
# callers.sh: main.c by the head build, -c and --windowed-loop -c, one run each under perf record with DWARF call
# graphs (cycles:u, a period of 1000003), then the callers of the functions that grow under --windowed-loop.
set -u
here=$PWD
out=$PWD/out
mkdir -p "$out/o" "$out/perf"
cd "$here/head" || exit 1
for mode in plain windowed; do
    extra=""
    [ "$mode" = windowed ] && extra=--windowed-loop
    perf record -q -e cycles:u -c 1000003 --call-graph dwarf,16384 -o "$out/perf/main.callers.$mode.data" taskset -c 2 "$here/compiler-head" --lanes 1 $extra -march=native -Isrc -fwrapv -funsigned-char -c src/buster/compiler/main.c -o "$out/o/main.callers.$mode.o" 2> /dev/null < /dev/null
done
for mode in plain windowed; do
    for symbol in check_constant_evaluate check_action_scalar check_init_walk; do
        echo "== $mode $symbol"
        perf report -q -i "$out/perf/main.callers.$mode.data" --no-children --symbols=$symbol,$symbol.buster_split -G --stdio 2> /dev/null | grep -v "^$" | head -40
    done
done > "$out/main.callers.txt"
