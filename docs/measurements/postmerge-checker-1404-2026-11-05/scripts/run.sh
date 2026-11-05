#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# #1404 whole-process acceptance. Start in ~/buster-fast-bench/1404-final.
# Native baseline and head use identical Clang/znver5 settings. Each measurement
# invocation owns the host lock; source/deferred order rotates inside time-runs.
set -euo pipefail
root=$PWD
base=$root/base/build/compiler
head=$root/head/build/compiler
out=$root/results
mkdir -p "$out"
export EXCLUSIVE_OWNER=codex-1404 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1404
lock=$HOME/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
measure()
{
    local name=$1
    shift
    EXCLUSIVE_TITLE="Issue 1404 $name" "$lock" taskset -c 0-7 "$@" > "$out/$name.txt" 2>&1
    printf '%s\t0\n' "$name" | tee -a "$out/status.tsv"
}
{
    for tree in base head; do
        git -C "$root/$tree" rev-parse HEAD
        git -C "$root/$tree" status --porcelain
        git -C "$root/$tree" diff | sha256sum
    done
    sha256sum "$base" "$head" "$sqlite/sqlite3.c" scripts/*
    uname -srm
    clang --version
    lscpu
    for cpu in {0..7}; do
        printf 'cpu%s ' "$cpu"
        cat "/sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor"
    done
} > "$out/identity.txt" 2>&1
 : > "$out/status.tsv"
measure "builds--w--deferred-bodies" "$head" time-runs --runs 11 --warmups 2 --copies 3 \
    --build baseline "$base" --build postmerge "$head" \
    --list --deferred-bodies -w "${args[@]}" -o "$out/compare.o"
measure "same-binary--w" "$head" time-runs --runs 21 --warmups 2 \
    --list --no-deferred-bodies -w "${args[@]}" -o "$out/source--w.o" \
    --list --deferred-bodies -w "${args[@]}" -o "$out/deferred--w.o"
measure "builds--w--no-deferred-bodies" "$head" time-runs --runs 11 --warmups 2 --copies 3 \
    --build baseline "$base" --build postmerge "$head" \
    --list --no-deferred-bodies -w "${args[@]}" -o "$out/compare.o"
cmp "$out/source--w.o" "$out/deferred--w.o"
printf 'source/deferred objects identical (-w)\n' >> "$out/objects.txt"
exec bash scripts/finish.sh
