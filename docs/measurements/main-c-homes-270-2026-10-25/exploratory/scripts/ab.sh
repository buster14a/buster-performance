#!/bin/bash
# ab.sh LOG ROUNDS: the A/B of the benchmarks whose code the homes move (#270), main's tree against the final one. Each
# round runs every benchmark on both trees (build/compiler ab --rounds 1, pinned to CPU 2) under one hold of the 9700X's
# lock, the trees in turn first, 30 s apart; from main's tree, whose sources and predefines are the inputs.
B=~/buster-fast-bench/build-270-claude
cd "$B/base"
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
export EXCLUSIVE_OWNER=claude-270
export EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/270
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(--predefines "$C/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
self=(-march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c)
for round in $(seq "$2"); do
    if [ $((round % 2)) -eq 1 ]; then trees=("$B/base" "$B/final"); else trees=("$B/final" "$B/base"); fi
    echo "=== ab round $round $(date -Is)" >> "$1"
    ~/buster-fast-bench/exclusive.sh "$B/base/build/compiler" ab --rounds 1 --cpu 2 "${trees[@]}" \
        -- benchmark-checker-source "${system[@]}" "$C/sqlite/sqlite3.c" \
        -- benchmark-checker-bindings --passes 5 "${system[@]}" "$C/sqlite/sqlite3.c" \
        -- benchmark-parser-bindings "${self[@]}" \
        -- benchmark-gnu "${self[@]}" \
        -- benchmark-assembler \
        -- benchmark-foreign-strings --counts 64,4096 --runs 3 \
        -- benchmark-debug \
        -- benchmark-lexer src \
        -- benchmark-x86-encoder --only x86_encode_64 \
        -- time-runs --runs 11 --list -fsyntax-only "${system[@]}" "$C/sqlite/sqlite3.c" >> "$1" 2>&1
    sleep 30
done
echo "done $(date -Is)" >> "$1"
