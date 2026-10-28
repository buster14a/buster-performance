#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
count=0
for input in inputs/*.c; do
    name=$(basename "$input" .c)
    mode=${name%-*}
    size=${name##*-}
    cmp "objects/$name-base.o" "objects/$name-head.o"
    readelf -W -S -s -r "objects/$name-head.o" > "objects/$name.elf.txt"
    clang -O0 -w -c "$input" -o objects/clang.o
    for role in head clang; do
        object="objects/$name-head.o"
        [[ "$role" != clang ]] || object=objects/clang.o
        clang -O2 verify.c "$object" -pthread -o objects/verify
        ./objects/verify "$mode" "$size"
        count=$((count + 1))
    done
done
cmp objects/sqlite-base.o objects/sqlite-head.o
printf '43 synthetic objects and SQLite byte-identical; %s successful Buster/Clang runtime checks\n' "$count"
sha256sum objects/*-base.o objects/*-head.o > object-identities.txt
stat -c '%n %s' objects/*-base.o objects/*-head.o > object-sizes.txt
sha256sum "$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c" > sqlite-after.sha256
