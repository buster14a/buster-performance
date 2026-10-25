#!/bin/bash
# run5.sh: six more rounds of benchmark-checker-source alone, the same trees and executables, under ab --rounds 6 --cpu 2
# --lock, from the base tree: run3.sh's three rounds had the head's body checking 4.5% to 15.7% slower in cycles per
# node, falling from round to round, where the first study had one of main's rounds 13% slower and the others even.
set -u
D=~/buster-fast-bench/build-270-claude/ab3
L=$D/run5.log
export EXCLUSIVE_OWNER=claude-270
export EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/424
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
LOCK=~/buster-fast-bench/exclusive.sh
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
echo "=== start $(date -Is)" >> "$L"
cd "$D/base"
"$D/base/build/compiler" ab --rounds 6 --cpu 2 --lock "$LOCK" "$D/base" "$D/head" \
    -- benchmark-checker-source "${system[@]}" "$C/sqlite/sqlite3.c" >> "$L" 2>&1
echo "ab status $?" >> "$L"
echo "done $(date -Is)" >> "$L"
