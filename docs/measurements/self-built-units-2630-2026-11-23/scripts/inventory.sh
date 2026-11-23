#!/bin/bash
# #2630 step 2: the correctness inventory (tools/ci/correctness.tests) run by the self-built Develop executable
# (BUSTER_SELF_BUILT=tests, its test units compiled by the tree's Release executable) in its own tree, as the 9700X
# job's native correctness runs it (CI's staged clang first on PATH, the frozen corpus, c-testsuite, SQLite, the pragma
# oracle, the predefines), in SHARDS shards, each its own hold. The runner is that executable, so every command's
# BUSTER_COMPILER is it; BUSTER_SELF_BUILT=tests stays set, so that the inventory's own build.sh calls keep the tree's
# settings.
set -uo pipefail
. "$HOME/buster-fast-bench/2630-claude/scripts/env.sh"
L=$d/scripts/lock.sh
out=$d/results/inventory
shards=${SHARDS:-12}
mkdir -p "$out"
export BUSTER_SELF_BUILT=tests BUSTER_ORACLE_CACHE=use
export BUSTER_CI_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/buster/ci"
export BUSTER_CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658 BUSTER_PPF_PRAGMA_ORACLE="$d/preprocessor-pragma-oracle"
cd "$d/src" || exit 2
"$L" bash -c '
    set -e
    ./build.sh > "$1/prepare.log" 2>&1
    ./build.sh --config Release >> "$1/prepare.log" 2>&1
    ./build.sh >> "$1/prepare.log" 2>&1
    bash tools/ci/build-benchmarks.sh oracle "$BUSTER_PPF_PRAGMA_ORACLE" >> "$1/prepare.log" 2>&1
    clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    bash tools/ci/fetch-c-testsuite.sh build/c-testsuite
    bash tools/ci/fetch-sqlite.sh build/sqlite' prepare "$out"
echo "prepare $?"
compiler=$d/src/build/cmake/native/Develop/compiler
sha256sum "$compiler" > "$out/compiler.sha256"
ls "$d/src/build/cmake/native/Develop/self" >> "$out/compiler.sha256"
for k in $(seq 1 "$shards"); do
    "$L" bash -c 'cd "$1" && rm -f build/oracle-*.tsv && taskset -c 0-7 "$2" parallel --jobs 8 --timeout 600 --shard "$3/$4" --costs tools/ci/costs/native-none-O3.costs < tools/ci/correctness.tests > "$5/shard-$3-of-$4.log" 2>&1; echo "status $?" >> "$5/shard-$3-of-$4.log"' shard "$d/src" "$compiler" "$k" "$shards" "$out"
    tail -1 "$out/shard-$k-of-$shards.log"
done
echo inventory-done
