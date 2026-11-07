#!/bin/sh
# #1352 round 2 (frontier walk's early stop): rebuild, test, benchmark, sweep; each step under its own lock hold.
# Expects the SEMI-NCA-only executable already saved at ../1352-claude-semi/compiler and the new patch applied.
cd ~/buster-fast-bench/1352-claude || exit 1
corpus=~/buster-fast-bench/corpus-391e729af658
unset CPATH C_INCLUDE_PATH
subset=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt | tr '\n' ' ')
one() {
  ./run.sh r2.log sh -c "$1"
  printf '%.90s: %s | %s\n' "$1" "$(grep -av '^exclusive.sh\|^  title\|^  link\|^  pull request\|^exit' r2.log | tail -1)" "$(tail -1 r2.log)"
}
BUSTER_HOST_ARCH=znver5 ./run.sh build.log ./build.sh
echo "build: $(tail -1 build.log)"
one "taskset -c 2 ./build/compiler test-dominators"
one "taskset -c 2 ./build/compiler test-dominators --seed 9 --count 300"
one "taskset -c 2 ./build/compiler test-dominators --seed 10 --count 300"
one "taskset -c 2 ./build/compiler test-ir-source --dominators tests/ir-source/dominators.c"
one "taskset -c 2 ./build/compiler test-ir-source --dominators $subset"
one "taskset -c 2 ./build/compiler test-ir-source --dominators --predefines $corpus/provenance/gnu17-pinned-predefines.txt --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
one "taskset -c 2 ./build/compiler test-ssa"
one "taskset -c 2 ./build/compiler test-ssa-source --typed --tier1 $subset"
one "taskset -c 2 ./build/compiler test-ssa-source --tier1 --generate 24 --seed 141 --lifetimes --clang clang"
one "./build/compiler test-c-testsuite --tier1 --jobs 8 --subset tests/c-testsuite/subset.txt build/c-testsuite"
one "taskset -c 2 ./build/compiler test-ir-optimize"
one "taskset -c 2 ./build/compiler test-tier1-pipeline --cross-check"
BUSTER_HOST_ARCH=znver5 ./run.sh cg.log ./build.sh check-call-graph
echo "check-call-graph: $(grep -a 'call graph:' cg.log) | $(tail -1 cg.log)"
./run.sh bd-final.log taskset -c 2 ./build/compiler benchmark-dominators --phase analysis
echo "benchmark-dominators: $(tail -2 bd-final.log | head -1)"
./run.sh cfg-final.log taskset -c 2 ./build/compiler benchmark-dominators --cfg sqlite.cfg --outputs tree
echo "benchmark-dominators --cfg tree: $(grep -a 'set=all tree' cfg-final.log)"
./run.sh cfg-all.log taskset -c 2 ./build/compiler benchmark-dominators --cfg sqlite.cfg --outputs all
echo "benchmark-dominators --cfg all: $(grep -a 'set=all all' cfg-all.log)"
./run.sh cfg-all-semi.log taskset -c 2 ../1352-claude-semi/compiler benchmark-dominators --cfg sqlite.cfg --outputs all
echo "semi benchmark-dominators --cfg all: $(grep -a 'set=all all' cfg-all-semi.log)"
for input in gotos-16000 ifs-8000 ifs-16000 ternary-4000 ternary-16000; do
  ./run.sh prof.log ./prof.sh $input
  { grep 'tier0' prof-stages.txt | head -1; cat prof-top.txt; } > prof-$input.txt
  echo "== $input"; cat prof-$input.txt | head -6
done
{ uname -a; clang --version | head -1; cmake --version | head -1; ninja --version; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor; cat /sys/kernel/mm/transparent_hugepage/enabled; sha256sum build/compiler ../1352-claude-semi/compiler ../1352-claude-base/build/compiler; } > host.txt 2>&1
./sweep.sh
echo finished
