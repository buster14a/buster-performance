#!/bin/bash
# Experiment builds (never pushed): benchmark-tier1-select with X_SHAPE (one shape, its selection phase only) and X_REPS
# (a fixed repetition count), on main 8d4025fbf and the rebased head; then perf stat of the wide and chain selections.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's selection" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
rm -rf shape; mkdir -p shape
git -C src-base fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> shape/status.txt; exit 1; }
git -C src-base checkout -q --detach 8d4025fbf && git -C src-base reset -q --hard
git -C src-head checkout -q --detach c7b-final2 && git -C src-head reset -q --hard
for side in base head; do
    f=src-$side/src/buster/compiler/tier1_select_benchmark.c
    sed -i 's/for (uint32_t shape = 0; valid \&\& shape < 3; shape += 1)/for (uint32_t shape = getenv("X_SHAPE") ? (uint32_t)atoi(getenv("X_SHAPE")) : 0; valid \&\& shape < (getenv("X_SHAPE") ? (uint32_t)atoi(getenv("X_SHAPE")) + 1 : 3); shape += 1)/; s/for (uint32_t phase = 0; valid \&\& phase < 2; phase += 1)/for (uint32_t phase = 0; valid \&\& phase < (getenv("X_SHAPE") ? 1u : 2u); phase += 1)/; s/} while (valid \&\& end - start < BUSTER_TIER1_SELECT_BENCH_SAMPLE_NS);/} while (valid \&\& (getenv("X_REPS") ? repetitions < (uint32_t)atoi(getenv("X_REPS")) : end - start < BUSTER_TIER1_SELECT_BENCH_SAMPLE_NS));/' $f
    echo "$side patched lines: $(grep -c 'X_SHAPE\|X_REPS' $f)" >> shape/status.txt
    (cd src-$side && $L timeout -k 5 1500 ./build.sh --config Release > "$D/shape/build-$side.log" 2>&1) || { echo "build $side failed" >> shape/status.txt; git -C src-$side checkout -q -- .; exit 1; }
    cp src-$side/build/compiler shape/$side
    git -C src-$side checkout -q -- .
done
for shape in 1 0; do
    for round in 1 2 3; do
        for side in base head; do
            cp shape/$side shape/$side-run
            $L timeout -k 5 300 env X_SHAPE=$shape X_REPS=40 taskset -c 2 perf stat -x, -e instructions:u,cycles:u -o shape/stat-$side-$shape-$round.txt ./shape/$side-run benchmark-tier1-select --only vector > shape/out-$side-$shape-$round.txt 2>&1
            echo "stat $side shape $shape round $round: $?" >> shape/status.txt
            rm -f shape/$side-run
        done
    done
done
date -u +%FT%TZ > shape/.done
