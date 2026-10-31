#!/bin/bash
set -uo pipefail
cd /tmp/opencode/takeover-942
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
taskset -c 2 ./build/compiler test-ir-source --dataflow-benchmark \
  --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" \
  "$corpus/sqlite/sqlite3.c" > bench-sqlite-2.out 2> bench-sqlite-2.err
status=$?
printf 'exit=%d\n' "$status" > bench-sqlite-2.status
exit "$status"
