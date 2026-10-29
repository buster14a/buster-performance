#!/bin/bash
# #777/#778/#779's receipts: the host, the tools, the binaries, the measured trees' manifests and the inputs.
W=$HOME/buster-fast-bench/units-152-claude
E=$W/exp
OUT=$W/receipts778
mkdir -p $OUT
echo "== host"; uname -a; grep -m1 "model name" /proc/cpuinfo; nproc
echo "== governors (CPUs 0 to 7)"; for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor 2>/dev/null)"; done
echo "== transparent huge pages"; cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag
echo "== tools"; clang --version | head -1; cc --version | head -1; perf --version 2>/dev/null; gdb --version | head -1; llvm-dwarfdump --version 2>/dev/null | grep -m1 version
echo "== binaries"; for t in t763 t779 t778 ccad t778m t777 t776; do [ -x $E/tree-$t/build/compiler ] && sha256sum $E/tree-$t/build/compiler; done
echo "== sources (sha256 of each file under src, tools and build.sh)"
for t in t763 t779 t778 ccad t778m t777 t776; do [ -d $E/tree-$t ] && (cd $E/tree-$t && find build.sh src tools -type f | LC_ALL=C sort | xargs sha256sum > $OUT/manifest-$t.txt; echo "tree-$t: $(wc -l < $OUT/manifest-$t.txt) files, manifest sha256 $(sha256sum < $OUT/manifest-$t.txt | cut -c1-64)"); done
echo "== inputs"
sha256sum $HOME/buster-fast-bench/refine-claude/inputs/sqlite3.c $W/inputs/c-testsuite/tests/single-exec/00220.c $HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400/sqlite3.c $HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400/shell.c
echo "lua: $(cd $W/inputs/lua-5.4.8/src && ls *.c | LC_ALL=C sort | xargs cat | sha256sum | cut -c1-64) over $(ls $W/inputs/lua-5.4.8/src/*.c | wc -l) .c files"
echo "synth: $(cd $W/explore/synth && ls unit_*.c | LC_ALL=C sort | xargs cat | sha256sum | cut -c1-64) over $(ls $W/explore/synth/unit_*.c | wc -l) units"
echo "musl: $(cat $HOME/buster-fast-bench/refine-claude/inputs/musl/VERSION 2>/dev/null)"
