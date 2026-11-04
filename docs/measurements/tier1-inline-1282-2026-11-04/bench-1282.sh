#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# #1282's 9700X record: the compiler built by clang, and self-hosted by Tier 0, by Tier 1 without inlining and by
# Tier 1 with it (tools/ci/selfhost.c's bootstrap flags, each unit by --lanes 1), each running test-lexer and
# benchmark-lexer src on CPU 2. The 9700X's lock is taken per run: the build, each unit's compile, each measurement.
set -u
export EXCLUSIVE_OWNER=claude-1282
export EXCLUSIVE_TITLE="#1282 IR: inline SIMD intrinsic wrappers (9700X record)"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/1324"
lock=~/buster-fast-bench/exclusive.sh
root=~/buster-fast-bench/1282-claude
head=${1:-e6c4fc3c668678a3e552dafac3b48fe3453fad33}
out=$root/results
mkdir -p "$root"
cd "$root"
if [ ! -d repo/.git ]; then
    git clone -q https://github.com/buster14a/buster repo
fi
cd repo
git fetch -q origin "$head" && git checkout -q --detach "$head"
mkdir -p "$out"
{
    echo "head $head"
    echo "host $(uname -n) $(nproc) cpus, $(grep -m1 'model name' /proc/cpuinfo)"
    clang --version | head -1
} > "$out/environment.txt"
export BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none BUSTER_FUZZ_AVAILABLE=0
"$lock" ./build.sh > "$out/build.log" 2>&1 || { echo "build failed"; exit 1; }
./build.sh print-sources > "$out/sources.argv"
./build.sh print-compile-flags > "$out/flags.argv"
mapfile -d '' sources < "$out/sources.argv"
mapfile -d '' all_flags < "$out/flags.argv"
flags=()
for f in "${all_flags[@]}"; do
    case "$f" in -O3|-Wall|-Werror) ;; *) flags+=("$f") ;; esac
done
selfhost() {
    local name=$1
    shift
    local dir=$out/$name
    rm -rf "$dir"
    mkdir -p "$dir"
    local start end objects=()
    start=$(date +%s.%N)
    for s in "${sources[@]}"; do
        local o="$dir/$(basename "$s" .c).o"
        "$lock" ./build/compiler --lanes 1 "${flags[@]}" "$@" -c -o "$o" "$s" 2>> "$dir/report.txt" || { echo "$name: $s failed"; return 1; }
        objects+=("$o")
    done
    end=$(date +%s.%N)
    clang -no-pie -o "$dir/compiler" "${objects[@]}" -lm -ldl -lpthread
    echo "compile seconds (sum of unit runs and lock waits): $(echo "$end - $start" | bc)" >> "$dir/report.txt"
}
selfhost tier0 || exit 1
selfhost tier1-noinline --tier1 --tier1-report --tier1-no-inline || exit 1
selfhost tier1 --tier1 --tier1-report || exit 1
measure() {
    local name=$1 compiler=$2
    for run in 1 2 3; do
        local s e
        s=$(date +%s.%N)
        "$lock" taskset -c 2 "$compiler" test-lexer > "$out/$name-test-lexer-$run.log" 2>&1
        local code=$?
        e=$(date +%s.%N)
        printf '%s\ttest-lexer\t%s\t%s\texit=%s\n' "$name" "$run" "$(echo "$e - $s" | bc)" "$code" >> "$out/timings.tsv"
    done
    "$lock" taskset -c 2 "$compiler" benchmark-lexer src > "$out/$name-benchmark-lexer.log" 2>&1
    printf '%s\tbenchmark-lexer\texit=%s\n' "$name" "$?" >> "$out/timings.tsv"
}
: > "$out/timings.tsv"
measure clang ./build/compiler
measure tier0 "$out/tier0/compiler"
measure tier1-noinline "$out/tier1-noinline/compiler"
measure tier1 "$out/tier1/compiler"
echo done > "$out/DONE"
