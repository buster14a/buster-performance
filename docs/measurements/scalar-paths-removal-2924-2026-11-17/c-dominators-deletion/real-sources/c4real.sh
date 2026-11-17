#!/bin/bash
# #2924 C4: the final head's tests on CI's real sources (tools/ci/correctness.tests' test-ir-source --dominators lines for
# sqlite3.c and musl), which check every CFG against the definition and the columns' contract. Release, each run under
# the lock.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: dominators' final tests on sqlite3.c and musl" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
if [ ! -d src ]; then git clone -q ../c4del/src-head src || exit 1; fi
git -C src fetch -q "$D/c4final.bundle" "+refs/heads/c4-dominators:refs/heads/c4-final" && git -C src checkout -q --detach c4-final || { echo "bundle failed" >> logs/status.txt; exit 1; }
git -C src rev-parse HEAD > logs/commit.txt
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl="$corpus/libc/musl"
cd src
$L timeout -k 5 1500 ./build/compiler test-ir-source --dominators --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > "$D/logs/sqlite.log" 2>&1
echo "sqlite: $?" >> "$D/logs/status.txt"
$L timeout -k 5 1500 ./build/compiler test-ir-source --dominators --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os \
  -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" \
  "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c > "$D/logs/musl.log" 2>&1
echo "musl: $?" >> "$D/logs/status.txt"
xz -9 -T2 "$D/logs/sqlite.log" "$D/logs/musl.log"
date -u +%FT%TZ > "$D/logs/.done"
