#!/bin/bash
# How many of test-ssa-source's parts run at once: its children, sampled every 0.2 s, over 16 c-testsuite files.
set -u
tree=$HOME/buster-fast-bench/2658-claude/glue
exe=$tree/build/cmake/x86-64-g0/Release/compiler
cd "$tree"
mapfile -t files < <(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt )
BUSTER_PARALLEL_CPUS=4 taskset -c 4,12,5,13 "$exe" test-ssa-source --typed --tier1 "${files[@]}" > /tmp/parts-debug.out 2>&1 &
main=$!
for i in $(seq 90); do
    sleep 0.5
    kids=$(ps -o pid=,stat=,comm= --ppid $main 2>/dev/null | wc -l)
    grand=$(for k in $(ps -o pid= --ppid $main 2>/dev/null); do ps -o pid= --ppid $k; done | wc -l)
    printf "%s children=%s grandchildren=%s states=%s\n" "$i" "$kids" "$grand" "$(ps -o stat= --ppid $main 2>/dev/null | tr -d " " | sort | uniq -c | tr "\n" " ")"
    kill -0 $main 2>/dev/null || break
done
wait $main; echo status=$?
tail -2 /tmp/parts-debug.out | cut -c1-200
