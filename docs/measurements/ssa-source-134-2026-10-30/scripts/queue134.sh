#!/bin/bash
# #134's 9700X runs: each build, test and benchmark run takes the shared lock by itself (exclusive.sh).
W=$HOME/buster-fast-bench/ssa-134-claude
H=$W/head-12bf987a
M=$W/main-caef4ea2
L=$W/logs
mkdir -p $L
export EXCLUSIVE_OWNER=ssa-134-claude
export EXCLUSIVE_TITLE="solve 134: SSA on real and generated C"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/134"
X=$HOME/buster-fast-bench/exclusive.sh
corpus=$W/corpus
musl="$corpus/libc/musl"
sqlite_options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
musl_options=(--no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
export TMPDIR=$W/tmp
mkdir -p $TMPDIR
step() { # name dir command...
  local name=$1 dir=$2; shift 2
  (cd $dir && $X bash -c 'start=$(date +%s.%N); "$@"; status=$?; end=$(date +%s.%N); echo "step-status=$status seconds=$(echo "$end - $start" | bc)"' bash "$@") > $L/$name.log 2>&1
}
subset=$(sed -n "s|^\([0-9][0-9]*\)$|$W/c-testsuite/tests/single-exec/\1.c|p" $H/tests/c-testsuite/subset.txt)
step build-head $H env BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh
step build-main $M env BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh
step ssa-source-subset $H taskset -c 0-7 ./build/compiler test-ssa-source $subset
step ssa-source-sqlite $H taskset -c 0-7 ./build/compiler test-ssa-source "${sqlite_options[@]}" "$corpus/sqlite/sqlite3.c"
step ssa-source-musl $H taskset -c 0-7 ./build/compiler test-ssa-source "${musl_options[@]}" "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c
step ssa-source-generated $H taskset -c 0-7 ./build/compiler test-ssa-source --generate 48 --clang clang
step test-ssa $H taskset -c 0-7 ./build/compiler test-ssa
step test-ssa-ir $H taskset -c 0-7 ./build/compiler test-ssa-ir
step test-ir-interpreter $H taskset -c 0-7 ./build/compiler test-ir-interpreter
step test-interpreter $H taskset -c 0-7 ./build/compiler test-interpreter
step test-interpreter-native $H taskset -c 0-7 ./build/compiler test-interpreter-native
step test-interpreter-link $H taskset -c 0-7 ./build/compiler test-interpreter-link
step test-ir-lowering $H taskset -c 0-7 ./build/compiler test-ir-lowering
step test-ir-source-subset $H taskset -c 0-7 ./build/compiler test-ir-source $subset
step test-ir-source-sqlite $H taskset -c 0-7 ./build/compiler test-ir-source "${sqlite_options[@]}" "$corpus/sqlite/sqlite3.c"
step call-graph $H taskset -c 0-7 ./build.sh check-call-graph
for round in 1 2 3 4 5 6; do
  if [ $((round % 2)) = 1 ]; then order="head main"; else order="main head"; fi
  for tree in $order; do
    dir=$H; [ $tree = main ] && dir=$M
    step bench-$round-$tree $dir taskset -c 2 ./build/compiler benchmark-ir-source "${sqlite_options[@]}" "$corpus/sqlite/sqlite3.c"
  done
done
for round in 1 2 3; do
  for tree in head main; do
    dir=$H; [ $tree = main ] && dir=$M
    step bench-after-$round-$tree $dir taskset -c 2 ./build/compiler benchmark-ir-source --only promote --after-scalar 200 "${sqlite_options[@]}" "$corpus/sqlite/sqlite3.c"
  done
done
echo done > $L/queue.done
