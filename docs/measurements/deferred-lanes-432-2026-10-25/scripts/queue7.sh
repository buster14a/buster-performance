#!/bin/bash
# PR #432's review: 00182.c (11 bodies) alone in its process, the three trees in rotating rounds, each run locked: does
# its eight-lane slowdown in the fixed trees remain without the units before it in queue6's process?
D=~/buster-fast-bench/deferred-113-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-432-review
export EXCLUSIVE_TITLE="PR #432 review: deferred lanes, 00182.c alone"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/432"
L="$D/log7.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
orders=("final lazy cap" "lazy cap final" "cap final lazy")
for round in 1 2 3 4 5 6; do
    order="${orders[$(((round - 1) % 3))]}"
    for t in $order; do
        echo "== round $round $t alone" >> "$L"
        ~/buster-fast-bench/exclusive.sh "$D/$t/build/compiler" benchmark-checker-deferred --passes 41 --lanes 8 --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$D/inputs/00182.c" >> "$L" 2>&1
        echo "exit=$? $(date -Is)" >> "$L"
        sleep 10
    done
done
echo done >> "$L"
