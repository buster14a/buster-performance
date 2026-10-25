#!/bin/bash
# PR #432's review: the deferred reader before (final: e6042e6c, the PR head b542a55d's code) and after (lazy: 9a5f8500,
# no more lanes than bodies, each copying the reader for its first part), in alternating locked processes: six small
# c-testsuite units, then the frozen sqlite3.c.
D=~/buster-fast-bench/deferred-113-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-432-review
export EXCLUSIVE_TITLE="PR #432 review: deferred lanes copy the reader for their first part"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/432"
L="$D/log5.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
(cd "$D/lazy" && LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh) >> "$L" 2>&1
echo "build lazy exit=$? $(date -Is)" >> "$L"
options=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
small=("$D/inputs/00001.c" "$D/inputs/00169.c" "$D/inputs/00213.c" "$D/inputs/00182.c" "$D/inputs/00204.c" "$D/inputs/00200.c")
for round in 1 2 3 4 5; do
    if [ $((round % 2)) -eq 1 ]; then order="final lazy"; else order="lazy final"; fi
    for t in $order; do
        echo "== round $round $t small" >> "$L"
        ~/buster-fast-bench/exclusive.sh "$D/$t/build/compiler" benchmark-checker-deferred --passes 21 --lanes 8 --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "${small[@]}" >> "$L" 2>&1
        echo "exit=$? $(date -Is)" >> "$L"
        sleep 20
    done
done
for round in 1 2 3; do
    if [ $((round % 2)) -eq 1 ]; then order="final lazy"; else order="lazy final"; fi
    for t in $order; do
        echo "== round $round $t sqlite" >> "$L"
        ~/buster-fast-bench/exclusive.sh "$D/$t/build/compiler" benchmark-checker-deferred --passes 9 --lanes 8 --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$corpus/sqlite/sqlite3.c" >> "$L" 2>&1
        echo "exit=$? $(date -Is)" >> "$L"
        sleep 20
    done
done
echo done >> "$L"
