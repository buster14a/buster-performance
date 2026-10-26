#!/usr/bin/env bash
# Where rows8's part1 spends its extra cycles against main: top-down metrics, then per-function cycles. Each step under
# the shared lock on its own.
cd "$(dirname "$0")" || exit 1
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_TITLE="#395 DWARF from compiled code (part 1), head 29306d59: cycles" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/426
for t in main part1 main part1; do
    echo "== topdown $t"
    ~/buster-fast-bench/exclusive.sh perf stat -M PipelineL1,PipelineL2 -r 11 taskset -c 2 $t/build/compiler -o tmp/program-$t tmp/program.c 2>&1 >/dev/null | grep -v '^ *$'
done > topdown.log 2>&1
for t in main part1; do
    ~/buster-fast-bench/exclusive.sh perf record -q -e cycles:u -c 200003 -o tmp/cycles-$t.data -- bash -c "for i in \$(seq 40); do taskset -c 2 $t/build/compiler -o tmp/program-$t tmp/program.c; done" > /dev/null 2>&1
    perf report -q -i tmp/cycles-$t.data --stdio --no-children --sort sym -F sample,sym 2>/dev/null > cycles-$t.txt
done
echo "== done"
