#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE.
set -euo pipefail
d="$HOME/buster-fast-bench/891-codex-20261105"
sqlite="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
base="$HOME/buster-fast-bench/pr1310-ab-base-20261105/build/compiler"
head="$d/head/build/compiler"
export EXCLUSIVE_OWNER=codex-891 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1313
export LC_ALL=C
opts=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum -c
sha256sum "$base" "$head" "$sqlite/sqlite3.c" > "$d/inputs.sha256"
printf 'base=441db2428d2bd8d28503037b28c1b3740fe4b25a\nhead=5929d0e2e2ab5a179313c082811b59a3ccdd0e0d\nbuild=Clang 23.1.1, Release O3, BUSTER_HOST_ARCH=znver5, BUSTER_DEBUG_INFO=0\ncpu=2\nevent=instructions:u\n' > "$d/identity.txt"
printf 'argv=' >> "$d/identity.txt"
printf '%q ' -c "${opts[@]}" -o "$d/out.o" >> "$d/identity.txt"
printf '\n' >> "$d/identity.txt"
export EXCLUSIVE_TITLE="PR 1313 preprocessed input inspection"
timeout 90 "$HOME/buster-fast-bench/exclusive.sh" "$base" -E "${opts[@]}" -o "$d/sqlite.i" > "$d/preprocess.out" 2> "$d/preprocess.err"
sha256sum "$d/sqlite.i" >> "$d/inputs.sha256"
if grep -En '__attribute__[[:space:]]*\(\([^)]*(__target__|target)[[:space:]]*\(' "$d/sqlite.i" > "$d/target-attributes.txt"; then
  echo "target attribute detected in preprocessed unit" >&2
  exit 1
fi
run_one() {
  local role="$1" n="$2" binary
  if [ "$role" = base ]; then binary="$base"; else binary="$head"; fi
  export EXCLUSIVE_TITLE="PR 1313 $role instruction count $n"
  timeout 90 "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 perf stat -x, -e instructions:u -o "$d/$role-$n.perf" -- "$binary" -c "${opts[@]}" -o "$d/out.o" > "$d/$role-$n.out" 2> "$d/$role-$n.err"
  sha256sum "$d/out.o" >> "$d/outputs.sha256"
}
for n in 1 2 3; do
  if [ "$n" = 2 ]; then run_one head "$n"; run_one base "$n"; else run_one base "$n"; run_one head "$n"; fi
done
