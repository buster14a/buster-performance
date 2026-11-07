#!/bin/bash
# #1634's A/B on the 9700X: `main` (687f44c3) against `cand` (main with the vector use-list builder), both with
# BUSTER_DEBUG_INFO=0. Every process takes the shared lock for itself (ab takes it per run), pinned to CPU 2.
# Steps: build (cand's tree), shifts (main_unit_backend.c 256 and 1024 bytes later in both), ir (benchmark-ir over
# three placements, three rounds), source (benchmark-ir-source, all variants, three rounds), tier1 (time-runs of
# -c --tier1 over three rounds, then one compile per tree for the object comparison). Usage: uses-ab.sh STEP...
set -u
D=$HOME/buster-fast-bench/uses-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-uses EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1634
export EXCLUSIVE_TITLE="#1634 use-list builder A/B"
LOCK=$HOME/buster-fast-bench/exclusive.sh
OUT=$D/results
mkdir -p "$OUT"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
sqlite="$corpus/sqlite/sqlite3.c"
AB=$D/cand/build/compiler
for step in "$@"; do
    case "$step" in
    build)
        (cd cand && BUSTER_DEBUG_INFO=0 "$LOCK" ./build.sh) > "$OUT/build-cand.log" 2>&1
        tail -1 "$OUT/build-cand.log"
        ;;
    shifts)
        for tree in main cand; do
            (cd "$tree" && BUSTER_DEBUG_INFO=0 "$LOCK" ./build.sh shifts "$D/shifts-$tree" main_unit_backend.c 256 1024) > "$OUT/shifts-$tree.log" 2>&1
            tail -1 "$OUT/shifts-$tree.log"
        done
        ;;
    ir)
        "$AB" ab --rounds 3 --cpu 2 --lock "$LOCK" main/build/compiler cand/build/compiler shifts-main/compiler-256 shifts-cand/compiler-256 shifts-main/compiler-1024 shifts-cand/compiler-1024 -- benchmark-ir > "$OUT/ir.log" 2>&1
        ;;
    source)
        "$AB" ab --rounds 3 --cpu 2 --lock "$LOCK" main/build/compiler cand/build/compiler -- benchmark-ir-source "${source[@]}" "$sqlite" > "$OUT/source.log" 2>&1
        ;;
    tier1)
        "$AB" ab --rounds 3 --cpu 2 --lock "$LOCK" main/build/compiler cand/build/compiler -- time-runs --runs 5 --list -c --tier1 "${driver[@]}" -w -o "$OUT/ab-tier1.o" "$sqlite" > "$OUT/tier1.log" 2>&1
        for tree in main cand; do
            "$LOCK" taskset -c 2 "$tree/build/compiler" -c --tier1 "${driver[@]}" -w -o "$OUT/$tree-tier1.o" "$sqlite" >> "$OUT/tier1.log" 2>&1
        done
        if cmp -s "$OUT/main-tier1.o" "$OUT/cand-tier1.o"; then echo "--tier1: main and cand objects identical"; else echo "--tier1: objects DIFFER"; fi >> "$OUT/tier1.log"
        ;;
    esac
done
echo "uses-ab.sh: done $*"
