#!/bin/bash
# #113: one locked build, then three locked benchmark processes a minute apart.
D=~/buster-fast-bench/deferred-113-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-113-deferred
export EXCLUSIVE_TITLE="#113 deferred function bodies: build and benchmark-checker-deferred"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113"
L="$D/log.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
echo "build start $(date -Is)" >> "$L"
LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh >> "$L" 2>&1
echo "build exit=$? $(date -Is)" >> "$L"
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for run in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh ./build/compiler benchmark-checker-deferred --passes 9 --lanes 8 --cpus 2,0,1,3,4,5,6,7 "${source[@]}" >> "$L" 2>&1
    echo "benchmark $run exit=$? $(date -Is)" >> "$L"
    sleep 60
done
echo done >> "$L"
