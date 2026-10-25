#!/bin/bash
# #113: the deferred reader before (old) and after (final: the copy index, base-page lane arenas and one change record a lane),
# in alternating locked processes.
D=~/buster-fast-bench/deferred-113-claude
cd "$D" || exit 1
while ! grep -qx done "$D/log3.txt"; do sleep 30; done
export EXCLUSIVE_OWNER=claude-113-deferred
export EXCLUSIVE_TITLE="#113 deferred function bodies: paired benchmark-checker-deferred"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113"
L="$D/log4.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
(cd "$D/final" && LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh) >> "$L" 2>&1
echo "build final exit=$? $(date -Is)" >> "$L"
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for round in 1 2 3; do
    if [ $((round % 2)) -eq 1 ]; then order="old final"; else order="final old"; fi
    for t in $order; do
        echo "== round $round $t" >> "$L"
        ~/buster-fast-bench/exclusive.sh "$D/$t/build/compiler" benchmark-checker-deferred --passes 9 --lanes 8 --cpus 2,0,1,3,4,5,6,7 "${source[@]}" >> "$L" 2>&1
        echo "exit=$? $(date -Is)" >> "$L"
        sleep 30
    done
done
echo done >> "$L"
