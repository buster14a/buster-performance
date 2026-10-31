#!/usr/bin/env bash
# queue-b.sh BASE HEAD: #140 step 4's main-vs-head on the 9700X, BASE the branch it stacks on. Both builds, then
# benchmark-tier1-select five rounds and benchmark-tier1-cfg-source on the frozen sqlite3.c three rounds, the two trees
# in alternating order per round, each round one hold of the shared lock. Logs in logs-b-HEAD/.
set -u
cd ~/buster-fast-bench/claude-140-cfg
base=$1
head=$2
logs=logs-b-$head
mkdir -p "$logs"
export EXCLUSIVE_OWNER=claude-140-cfg
export EXCLUSIVE_TITLE="Tier 1 edge moves #140: measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/140
lock=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for tree in "$base" "$head"; do
    "$lock" bash -c "cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh > ../$logs/build-$tree.log 2>&1; echo \"exit \$?\" >> ../$logs/build-$tree.log; sha256sum build/compiler >> ../$logs/build-$tree.log"
done
for round in 1 2 3 4 5; do
    if [ $((round % 2)) -eq 1 ]; then order="$base $head"; else order="$head $base"; fi
    "$lock" bash -c "for tree in $order; do (cd \$tree && taskset -c 2 ./build/compiler benchmark-tier1-select > ../$logs/select-\$tree-$round.log 2>&1; echo \"exit \$?\" >> ../$logs/select-\$tree-$round.log); done"
done
for round in 1 2 3; do
    if [ $((round % 2)) -eq 1 ]; then order="$base $head"; else order="$head $base"; fi
    "$lock" bash -c "unset CPATH C_INCLUDE_PATH; export SOURCE_DATE_EPOCH=1792454400; for tree in $order; do (cd \$tree && taskset -c 2 ./build/compiler benchmark-tier1-cfg-source $(printf '%q ' "${sqlite[@]}") > ../$logs/cfg-source-\$tree-$round.log 2>&1; echo \"exit \$?\" >> ../$logs/cfg-source-\$tree-$round.log); done"
done
echo done > "$logs/done"
