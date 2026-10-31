#!/usr/bin/env bash
# queue.sh MAIN HEAD: #140's CFG allocation measurements on the 9700X, each step one hold of the shared lock.
# MAIN and HEAD are tree directories under ~/buster-fast-bench/claude-140-cfg, each with a COMMIT file.
# Logs go to logs/, one per step, written from inside the hold.
set -u
cd ~/buster-fast-bench/claude-140-cfg
main=$1
head=$2
mkdir -p logs
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 CFG allocation #140: measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/140
lock=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for tree in "$main" "$head"; do
    "$lock" bash -c "cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh > ../logs/build-$tree.log 2>&1; echo \"exit \$?\" >> ../logs/build-$tree.log"
done
# The allocator's own benchmark, main against head, five rounds in alternating order, each round one hold.
for round in 1 2 3 4 5; do
    if [ $((round % 2)) -eq 1 ]; then order="$main $head"; else order="$head $main"; fi
    "$lock" bash -c "for tree in $order; do (cd \$tree && taskset -c 2 ./build/compiler benchmark-tier1-allocation > ../logs/allocation-\$tree-$round.log 2>&1; echo \"exit \$?\" >> ../logs/allocation-\$tree-$round.log); done"
done
# The CFG allocation on the frozen sqlite3.c, against Tier 0 and the interval allocator alone: three processes, and one
# after 200 ms of scalar work before each vector pass.
for round in 1 2 3; do
    "$lock" bash -c "cd $head && unset CPATH C_INCLUDE_PATH && export SOURCE_DATE_EPOCH=1792454400 && taskset -c 2 ./build/compiler benchmark-tier1-cfg-source $(printf '%q ' "${sqlite[@]}") > ../logs/cfg-source-$round.log 2>&1; echo \"exit \$?\" >> ../logs/cfg-source-$round.log"
done
"$lock" bash -c "cd $head && unset CPATH C_INCLUDE_PATH && export SOURCE_DATE_EPOCH=1792454400 && taskset -c 2 ./build/compiler benchmark-tier1-cfg-source --after-scalar 200 $(printf '%q ' "${sqlite[@]}") > ../logs/cfg-source-after-scalar.log 2>&1; echo \"exit \$?\" >> ../logs/cfg-source-after-scalar.log"
# Tier 0's compile of the same functions, per typed entry: its allocation is part of tier0_compile.
for round in 1 2 3; do
    "$lock" bash -c "cd $head && unset CPATH C_INCLUDE_PATH && export SOURCE_DATE_EPOCH=1792454400 && taskset -c 2 ./build/compiler benchmark-backend-source $(printf '%q ' "${sqlite[@]}") > ../logs/backend-source-$round.log 2>&1; echo \"exit \$?\" >> ../logs/backend-source-$round.log"
done
echo done > logs/done
