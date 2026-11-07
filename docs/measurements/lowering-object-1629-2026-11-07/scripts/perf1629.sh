#!/bin/bash
# #1629: cycles profiles of the harness on 1,000 copies of c-testsuite's 00001.c (9 tokens), one tree per lock hold,
# for the object and publication stages' fixed cost: main418 and c6 (the merged #1658).
cd ~/buster-fast-bench/1629-claude
export EXCLUSIVE_OWNER=claude-1629 EXCLUSIVE_TITLE="Take the remaining work of 442 (#1629)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1629
mkdir -p perf
files=$(for i in $(seq 1000); do echo -n "cts/tests/single-exec/00001.c "; done)
for t in main418 c6; do
    ~/buster-fast-bench/exclusive.sh taskset -c 2 perf record -q -e cycles:u -c 20000 -o perf/$t.data trees/$t/build/compiler benchmark-emit-ab --passes 101 $files > perf/$t.txt 2>&1
    perf report -i perf/$t.data --no-children --stdio -q --sort sym --percent-limit 0.05 2>/dev/null > perf/$t.report
    echo "$t $(tail -1 perf/$t.txt | cut -c1-200)"
done
echo perf-done
