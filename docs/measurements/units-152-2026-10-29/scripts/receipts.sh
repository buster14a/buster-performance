#!/bin/bash
# #152's receipts for the final round: the host, the tools, the binaries and the inputs.
W=$HOME/buster-fast-bench/units-152-claude
E=$W/exp
echo "== host"; uname -a; grep -m1 "model name" /proc/cpuinfo; nproc
echo "== governors (CPUs 0 to 7)"; for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor 2>/dev/null)"; done
echo "== transparent huge pages"; cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag
echo "== tools"; clang --version | head -1; tcc -v 2>&1 | head -1; make --version | head -1; cc --version | head -1; perf --version 2>/dev/null
echo "== binaries"; sha256sum $E/tree-final/build/compiler $E/tree-main2/build/compiler
echo "== sources (sha256 of each file under src, tools and build.sh)"
for t in final main2; do (cd $E/tree-$t && find build.sh src tools -type f | LC_ALL=C sort | xargs sha256sum > $W/final/manifest-$t.txt; echo "tree-$t: $(wc -l < $W/final/manifest-$t.txt) files, manifest sha256 $(sha256sum < $W/final/manifest-$t.txt | cut -c1-64)"); done
echo "== inputs"
sha256sum $HOME/buster-fast-bench/refine-claude/inputs/sqlite3.c $W/floor/tiny.c $W/inputs/c-testsuite/tests/single-exec/00220.c
echo "lua: $(cd $W/inputs/lua-5.4.8/src && ls *.c | LC_ALL=C sort | xargs cat | sha256sum | cut -c1-64) over $(ls $W/inputs/lua-5.4.8/src/*.c | wc -l) .c files"
echo "synth: $(cd $W/explore/synth && ls unit_*.c | LC_ALL=C sort | xargs cat | sha256sum | cut -c1-64) over $(ls $W/explore/synth/unit_*.c | wc -l) units"
echo "musl: $(cd $HOME/buster-fast-bench/refine-claude/inputs/musl && git log --oneline -1 2>/dev/null || cat VERSION 2>/dev/null)"
