#!/bin/bash
# #1372's compile-time comparison, run under one hold of the 9700X's lock: the frozen sqlite3.c's -c and a stress of
# 32,768 bit-field accesses (gen_fields.c), each by time-runs over the base and head builds, 21 runs each, on CPU 2.
set -euo pipefail
cd ~/buster-fast-bench/1372-claude
corpus=~/buster-fast-bench/corpus-391e729af658
clang -O2 gen_fields.c -o out/gen_fields
out/gen_fields > out/fields.c
sqlite=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
        -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
taskset -c 2 head/build/compiler time-runs --runs 21 --warmups 2 --build base base/build/compiler --build head head/build/compiler \
    --list -c "${sqlite[@]}" "$corpus/sqlite/sqlite3.c" -o /tmp/1372-claude-sqlite.o > out/time-sqlite-c.txt 2>&1
taskset -c 2 head/build/compiler time-runs --runs 21 --warmups 2 --build base base/build/compiler --build head head/build/compiler \
    --list -c out/fields.c -o /tmp/1372-claude-fields.o > out/time-fields-c.txt 2>&1
sha256sum "$corpus/sqlite/sqlite3.c" out/fields.c >> out/identities.sha256
echo compiled
