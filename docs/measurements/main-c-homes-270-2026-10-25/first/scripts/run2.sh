#!/bin/bash
# run2.sh PID: after run.sh (the process PID) ends, the whole drivers whose code calls into another unit's home, the
# same trees and executables: -E and parse (the frontend's unit, the lexer's home in the driver's unit), the direct
# path's compile and link of c-testsuite's largest declared program (the checker's driver, Tier 0, and the linker
# modules' home in the dynamic unit), under ab --rounds 5 --cpu 2 --lock; then link-foreign (the executable unit, its
# linker modules in the dynamic unit's home) as benchmark-link runs it, under ab --rounds 3 --lock, unpinned, since
# benchmark-link pins its one-thread runs itself and runs the others on every CPU.
set -u
while kill -0 "$1" 2> /dev/null; do
    sleep 10
done
D=~/buster-fast-bench/build-270-claude/ab2
L=$D/run2.log
export EXCLUSIVE_OWNER=claude-270
export EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/424
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
LOCK=~/buster-fast-bench/exclusive.sh
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
driver=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
program=$D/c-testsuite/tests/single-exec/00216.c
mkdir -p "$D/out"
echo "=== start $(date -Is)" >> "$L"
cd "$D/base"
"$D/base/build/compiler" ab --rounds 5 --cpu 2 --lock "$LOCK" "$D/base" "$D/head" \
    -- time-runs --runs 21 --list -E -o /dev/null "${driver[@]}" "$C/sqlite/sqlite3.c" \
        --list parse -fsyntax-only "${driver[@]}" "$C/sqlite/sqlite3.c" \
        --list -o "$D/out/program" -lm "$program" \
        --list -c -o "$D/out/program.o" "$program" >> "$L" 2>&1
echo "ab status $?" >> "$L"
"$D/base/build/compiler" ab --rounds 3 --lock "$LOCK" "$D/base" "$D/head" \
    -- benchmark-link --only linkers --linkers link-foreign --kinds dynamic,static --functions 2000,102400 --runs 11 \
        --directory /tmp >> "$L" 2>&1
echo "ab status $?" >> "$L"
echo "done $(date -Is)" >> "$L"
