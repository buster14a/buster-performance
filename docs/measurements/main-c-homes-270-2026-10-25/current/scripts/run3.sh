#!/bin/bash
# run3.sh PID: after run2.sh (the process PID) ends, the other benchmarks of the first study whose code the homes
# move, whose sources main didn't change since it, the same trees and executables, under ab --rounds 3 --cpu 2 --lock,
# from the base tree, whose sources and predefines are the inputs.
set -u
while kill -0 "$1" 2> /dev/null; do
    sleep 10
done
D=~/buster-fast-bench/build-270-claude/ab3
L=$D/run3.log
export EXCLUSIVE_OWNER=claude-270
export EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/424
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
LOCK=~/buster-fast-bench/exclusive.sh
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
self=(-march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c)
echo "=== start $(date -Is)" >> "$L"
cd "$D/base"
"$D/base/build/compiler" ab --rounds 3 --cpu 2 --lock "$LOCK" "$D/base" "$D/head" \
    -- benchmark-checker-source "${system[@]}" "$C/sqlite/sqlite3.c" \
    -- benchmark-checker-bindings --passes 5 "${system[@]}" "$C/sqlite/sqlite3.c" \
    -- benchmark-parser-bindings "${self[@]}" \
    -- benchmark-gnu "${self[@]}" \
    -- benchmark-foreign-strings --counts 64,4096 --runs 3 \
    -- benchmark-debug >> "$L" 2>&1
echo "ab status $?" >> "$L"
echo "done $(date -Is)" >> "$L"
