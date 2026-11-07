#!/bin/bash
# #866's acyclic-numbering A/B on the 9700X: `base` is main at ec5f0f6b, `cand` the same commit with the change. Both
# are built with BUSTER_DEBUG_INFO=0 (build-both.sh). Every process takes the shared host lock for itself alone and is
# pinned to CPU 2. Steps: shifts (code placements 256 and 1024 bytes later in main_unit_backend.c), synthetic
# (benchmark-ir-optimize-passes), source (benchmark-ir-source on the frozen sqlite3.c), tier1 (-c --tier1 with and
# without --tier1-gvn of the same file), perf (one profile of each GVN path). Usage: ab.sh STEP...
set -u
ROOT=${ROOT:-$HOME/buster-fast-bench/866-claude}
OUT=$ROOT/results
mkdir -p "$OUT"
cd "$ROOT" || exit 1
export EXCLUSIVE_OWNER=claude-866
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/866
LOCK=$HOME/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
pre=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
sqlite="$corpus/sqlite/sqlite3.c"
for step in "$@"; do
    case "$step" in
    shifts)
        for tree in base cand; do
            (cd "$tree" && EXCLUSIVE_TITLE="866 shifts $tree" BUSTER_DEBUG_INFO=0 "$LOCK" ./build.sh shifts "$ROOT/shifts-$tree" main_unit_backend.c 256 1024) > "$OUT/shifts-$tree.log" 2>&1
            tail -1 "$OUT/shifts-$tree.log"
        done
        ;;
    synthetic)
        for run in 1 2 3; do
            if [ $((run % 2)) -eq 1 ]; then order=(base cand); else order=(cand base); fi
            for tree in "${order[@]}"; do
                for place in 0 256 1024; do
                    if [ "$place" = 0 ]; then exe="$ROOT/$tree/build/compiler"; else exe="$ROOT/shifts-$tree/compiler-$place"; fi
                    echo "### run=$run tree=$tree place=$place"
                    EXCLUSIVE_TITLE="866 synthetic $run $tree $place" "$LOCK" taskset -c 2 "$exe" benchmark-ir-optimize-passes --pass gvn --instructions 4096 --samples 21
                done
            done
        done >> "$OUT/synthetic.log" 2>&1
        ;;
    source)
        for run in 1 2 3; do
            if [ $((run % 2)) -eq 1 ]; then order=(cand base); else order=(base cand); fi
            for tree in "${order[@]}"; do
                for variant in gvn gvn-scalar; do
                    echo "### run=$run tree=$tree variant=$variant"
                    EXCLUSIVE_TITLE="866 source $run $tree $variant" "$LOCK" taskset -c 2 "$ROOT/$tree/build/compiler" benchmark-ir-source --only "$variant" "${pre[@]}" "$sqlite"
                done
            done
        done >> "$OUT/source.log" 2>&1
        ;;
    tier1)
        for run in 1 2 3 4 5; do
            for tree in base cand; do
                for mode in tier1 tier1-gvn; do
                    flags=(--tier1)
                    [ "$mode" = tier1-gvn ] && flags=(--tier1 --tier1-gvn)
                    start=$(date +%s%N)
                    EXCLUSIVE_TITLE="866 tier1 $run $tree $mode" "$LOCK" taskset -c 2 "$ROOT/$tree/build/compiler" -c "${flags[@]}" "${pre[@]}" -o "$OUT/$tree-$mode.o" "$sqlite" 2> "$OUT/$tree-$mode.err"
                    status=$?
                    end=$(date +%s%N)
                    echo "run=$run tree=$tree mode=$mode status=$status ms=$(( (end - start) / 1000000 ))"
                done
            done
        done >> "$OUT/tier1.log" 2>&1
        for mode in tier1 tier1-gvn; do
            if cmp -s "$OUT/base-$mode.o" "$OUT/cand-$mode.o"; then echo "$mode: base and cand objects identical"; else echo "$mode: objects DIFFER"; fi
            size "$OUT/base-$mode.o" "$OUT/cand-$mode.o" | tail -2
        done >> "$OUT/tier1.log" 2>&1
        ;;
    perf)
        for tree in base cand; do
            for variant in gvn gvn-scalar; do
                EXCLUSIVE_TITLE="866 perf $tree $variant" "$LOCK" taskset -c 2 perf record -e cycles -F 4999 -o "$OUT/perf-$tree-$variant.data" "$ROOT/$tree/build/compiler" benchmark-ir-source --only "$variant" "${pre[@]}" "$sqlite" > "$OUT/perf-$tree-$variant.log" 2>&1
                perf report -i "$OUT/perf-$tree-$variant.data" --no-children --sort sym 2> /dev/null | grep -v '^#' | grep '%' | head -40 > "$OUT/perf-$tree-$variant.report"
            done
        done
        ;;
    esac
done
echo "ab.sh: done $*"
