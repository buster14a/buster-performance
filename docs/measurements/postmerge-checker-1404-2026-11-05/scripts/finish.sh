#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Resume after the initial -w same-binary and two build controls. Each invocation
# below is one locked measurement or harness build. Start in the campaign root.
set -euo pipefail
root=$PWD
base=$root/base/build/compiler
head=$root/head/build/compiler
out=$root/results
export EXCLUSIVE_OWNER=codex-1404 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1440
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
sha256sum "$base" "$head" scripts/*.c scripts/*.sh scripts/*.mk > "$out/continuation-identity.txt"
measure same-binary-warnings "$head" time-runs --runs 21 --warmups 2 \
    --list --no-deferred-bodies "${args[@]}" -o "$out/source-warnings.o" \
    --list --deferred-bodies "${args[@]}" -o "$out/deferred-warnings.o"
measure builds-warnings "$head" time-runs --runs 11 --warmups 2 --copies 3 \
    --build baseline "$base" --build postmerge "$head" \
    --list --no-deferred-bodies "${args[@]}" -o "$out/compare.o" \
    --list --deferred-bodies "${args[@]}" -o "$out/compare.o"
cmp "$out/source-warnings.o" "$out/deferred-warnings.o"
printf 'source/deferred objects identical (warnings)\n' >> "$out/objects.txt"
lists=()
for lanes in {2..8}; do
    for mode in source deferred; do
        option=--deferred-bodies
        if [[ $mode == source ]]; then option=--no-deferred-bodies; fi
        lists+=(--list --lanes "$lanes" "$option" -w "${args[@]}" -o "$out/$mode-$lanes.o")
    done
done
# Fourteen rotated cases, fourteen runs: each case occupies each position once.
measure lanes "$head" time-runs --runs 14 --warmups 2 "${lists[@]}"
for lanes in {2..8}; do
    cmp "$out/source-$lanes.o" "$out/deferred-$lanes.o"
    printf 'source/deferred objects identical (lanes %s)\n' "$lanes" >> "$out/objects.txt"
done
for mode in --no-deferred-bodies --deferred-bodies; do
    measure "stages$mode" "$head" "$mode" -w --time-stages "${args[@]}" -o "$out/stages.o"
done
measure deferred-reader "$head" benchmark-checker-deferred --passes 24 --lanes 8 --cpus 2,0,1,3,4,5,6,7 \
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c"
measure harness-build make -j2 -f scripts/harness.mk
mkdir -p "$out/cohorts"
for workload in 0 1 2; do
    measure "cohort-$workload" "$root/scripts/policy_balanced" "$out/cohorts/0-$workload-balanced" \
        "$workload" "$head" "$root/scripts/compile-budget.mk" "$root/scripts/usage_record"
    find "$out/cohorts/0-$workload-balanced" -name '*.o' -print0 | sort -z | xargs -0 sha256sum > "$out/cohorts/$workload-objects.sha256"
    find "$out/cohorts/0-$workload-balanced" -name '*.o' -delete
done
measure baseline-object "$base" -w "${args[@]}" -o "$out/baseline.o"
cmp "$out/baseline.o" "$out/source--w.o"
printf 'baseline/source/deferred objects identical (-w)\n' >> "$out/objects.txt"
sha256sum "$out"/*.o > "$out/objects.sha256"
rm "$out"/*.o
sha256sum "$base" "$head" > "$out/executables-after.sha256"
printf 'complete\n' > "$out/done"
