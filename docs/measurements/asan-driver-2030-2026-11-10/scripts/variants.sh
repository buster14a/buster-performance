#!/bin/bash
# Builds each sanitizer-flag variant worktree (CI's ASan row with one compile-time group changed), one after another.
set -u
export LC_ALL=C
out=$HOME/.cache/claude-pr2056-review/2030
for v in asan-only asan-ubsan uar-runtime; do
    cd "$out/wt/$v" || exit 2
    TIMEFORMAT='%R %U %S'
    { time env -u CPATH BUSTER_SANITIZER=address ./build.sh --jobs "${CORES:-6}" > "$out/variant-$v.log" 2>&1; } 2> "$out/variant-$v.time"
    echo "$v rc=$? $(cat "$out/variant-$v.time") | $(grep 'units compiled' "$out/variant-$v.log")" >> "$out/variants.txt"
    cp build/compiler "$out/compiler-$v" 2>/dev/null
done
