#!/bin/bash
# #426: where part 1's extra user instructions go, without -g: fixed-period samples of 20 whole compiles per tree.
cd ~/buster-fast-bench/dwarf395/rows3 || exit 1
for t in main part1; do
    perf record -q -e instructions:u -c 200003 -o tmp/perf-$t.data -- taskset -c 2 bash -c "for i in \$(seq 20); do $t/build/compiler -o tmp/program-$t tmp/program.c; done" > /dev/null 2>&1
    perf report -i tmp/perf-$t.data --comm compiler --sort sym --stdio -n 2> /dev/null | grep -v "^#" | grep -v "^$" > tmp/report-$t.txt
done
