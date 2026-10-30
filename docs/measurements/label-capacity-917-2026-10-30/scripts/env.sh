#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
Q=/home/david/buster-fast-bench/codex-917-label-20261030
TC=/home/david/buster-fast-bench/codex-883-qualification-6a-b68/cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export PATH="$TC/bin:$PATH" LD_LIBRARY_PATH="$TC/lib"
export BUSTER_CLANG_RESOURCE_DIR="$TC/lib/clang/23"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none BUSTER_LINKER=/usr/bin/wild
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
unset BUSTER_HOST_RUNTIME BUSTER_FUZZ_AVAILABLE BUSTER_FUZZ_ENTRY BUSTER_SANITIZER_OPTIMIZATION
test "${BUSTER_9700X_HELD:-}" = 1
printf '%s  %s\n' c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67 "$TC/bin/clang" \
  8d85c1057d742e597985c7d4e6320b015a9139385cff4cbae06ffc0ebe89afee "$TC/LICENSE.TXT" \
  8446253a800c27c5312e85fc95288ddc1b965a7f2f6b5805255eb8323daf9c51 /usr/bin/wild | sha256sum --check --status
test "$(cat "$TC/.complete")" = efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
test "$(cat "$TC/.correctness-complete")" = efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
common=(--predefines "$CORPUS/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc
  -isystem "$CORPUS/headers/usr/lib/clang/23/include" -isystem "$CORPUS/headers/usr/local/include" -isystem "$CORPUS/headers/usr/include")
sqlite=(-c "${common[@]}" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE
  "-I$CORPUS/sqlite" "$CORPUS/sqlite/sqlite3.c")
