#!/bin/bash
# ab3.sh: ab2.sh with the C driver's options for the tier1 step (the driver refuses --no-default-config, which only the
# source benchmark takes, so ab2.sh's tier1 compiles all exited at once with status 1). The rest of #866's 9700X A/B, with fewer lock acquisitions than ab.sh (which built the placements and ran most of
# the synthetic step) because the lock was heavily contended. Every acquisition is one process (or one ab round, which
# takes the lock per run itself), pinned to CPU 2. Steps: synthetic3 (round 3's remaining placements), source
# (benchmark-ir-source with every variant, so gvn and gvn-scalar come from one process), tier1 (ab + time-runs of -c
# --tier1 with and without --tier1-gvn, then one compile per tree for the object comparison), perf (the candidate's
# gvn profile). Usage: ab3.sh STEP...
set -u
ROOT=${ROOT:-$HOME/buster-fast-bench/866-claude}
OUT=$ROOT/results
mkdir -p "$OUT"
cd "$ROOT" || exit 1
export EXCLUSIVE_OWNER=claude-866
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/866
export EXCLUSIVE_TITLE="Solve 866 (GVN acyclic numbering) A/B"
LOCK=$HOME/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
pre=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
sqlite="$corpus/sqlite/sqlite3.c"
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
for step in "$@"; do
    case "$step" in
    synthetic3)
        for entry in base:256 base:1024 cand:0 cand:256 cand:1024; do
            tree=${entry%:*}
            place=${entry#*:}
            if [ "$place" = 0 ]; then exe="$ROOT/$tree/build/compiler"; else exe="$ROOT/shifts-$tree/compiler-$place"; fi
            echo "### run=3 tree=$tree place=$place"
            "$LOCK" taskset -c 2 "$exe" benchmark-ir-optimize-passes --pass gvn --instructions 4096 --samples 21
        done >> "$OUT/synthetic.log" 2>&1
        ;;
    source)
        for run in 1 2 3; do
            if [ $((run % 2)) -eq 1 ]; then order=(cand base); else order=(base cand); fi
            for tree in "${order[@]}"; do
                echo "### run=$run tree=$tree"
                "$LOCK" taskset -c 2 "$ROOT/$tree/build/compiler" benchmark-ir-source "${pre[@]}" "$sqlite"
            done
        done >> "$OUT/source.log" 2>&1
        ;;
    tier1)
        "$ROOT/cand/build/compiler" ab --rounds 3 --cpu 2 --lock "$LOCK" "$ROOT/base" "$ROOT/cand" -- time-runs --runs 5 \
            --list -c --tier1 "${driver[@]}" -o "$OUT/ab-tier1.o" "$sqlite" \
            --list -c --tier1 --tier1-gvn "${driver[@]}" -o "$OUT/ab-tier1-gvn.o" "$sqlite" >> "$OUT/tier1.log" 2>&1
        for tree in base cand; do
            "$LOCK" taskset -c 2 "$ROOT/$tree/build/compiler" -c --tier1 --tier1-gvn "${driver[@]}" -o "$OUT/$tree-tier1-gvn.o" "$sqlite" >> "$OUT/tier1.log" 2>&1
        done
        if cmp -s "$OUT/base-tier1-gvn.o" "$OUT/cand-tier1-gvn.o"; then echo "--tier1-gvn: base and cand objects identical"; else echo "--tier1-gvn: objects DIFFER"; fi >> "$OUT/tier1.log"
        size "$OUT/base-tier1-gvn.o" "$OUT/cand-tier1-gvn.o" >> "$OUT/tier1.log" 2>&1
        ;;
    perf)
        "$LOCK" taskset -c 2 perf record -e cycles -F 4999 -o "$OUT/perf-cand-gvn.data" "$ROOT/cand/build/compiler" benchmark-ir-source --only gvn "${pre[@]}" "$sqlite" > "$OUT/perf-cand-gvn.log" 2>&1
        perf report -i "$OUT/perf-cand-gvn.data" --no-children --sort sym 2> /dev/null | grep -v '^#' | grep '%' | head -40 > "$OUT/perf-cand-gvn.report"
        ;;
    esac
done
echo "ab3.sh: done $*"
