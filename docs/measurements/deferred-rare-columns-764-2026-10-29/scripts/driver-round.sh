#!/bin/bash
. ~/buster-fast-bench/claude-764/scripts/env.sh
round="$1"; shift
for tree in "$@"; do
    echo "== round $round $tree driver sqlite3.c" >> "$D/logs/driver.txt"
    perf stat -r 11 -x, -e task-clock,cycles:u,instructions:u -o "$D/logs/driver-$round-$tree.csv" "$D/trees/$tree/build/compiler" -fsyntax-only \
        --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" \
        -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" >> "$D/logs/driver.txt" 2>&1
    echo "exit=$? $(date -Is)" >> "$D/logs/driver.txt"
    cat "$D/logs/driver-$round-$tree.csv" >> "$D/logs/driver.txt"
done
