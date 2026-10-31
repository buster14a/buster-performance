#!/bin/bash
# #866's source-derived IR A/B on the 9700X, against the frozen sqlite3.c and the 9700X job's options. Each process
# takes the shared lock for one benchmark run and is pinned to CPU 2. ROOT holds `cand` and `basegvn` as ab-synthetic.sh
# describes. Run this script on benchpress.
set -e
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
ROOT=${ROOT:-$HOME/gvn946}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
pre=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for run in 1 2 3; do
    if [ $((run % 2)) -eq 1 ]; then order=(cand basegvn); else order=(basegvn cand); fi
    for tree in "${order[@]}"; do
        for variant in gvn gvn-scalar; do
            echo "### run=$run tree=$tree variant=$variant"
            EXCLUSIVE_OWNER=opencode-gvn946 \
            EXCLUSIVE_TITLE="GVN 946 source $run $tree $variant" \
            EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/946" \
                "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 "$ROOT/$tree/build/compiler" \
                benchmark-ir-source --only "$variant" "${pre[@]}"
        done
    done
done
