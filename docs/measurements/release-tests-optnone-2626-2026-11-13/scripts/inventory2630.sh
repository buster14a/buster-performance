#!/bin/bash
# #2630 step 1: the correctness inventory (tools/ci/correctness.tests) run by the Tier 1 self-built compiler
# (self/stage2-t1: a11e44ac's units compiled by its own Release executable at --tier1), as the 9700X job's native
# correctness runs it (CI's staged Clang first on PATH, znver5, the frozen corpus, c-testsuite, SQLite, the pragma
# oracle, the predefines), in SHARDS shards, each its own hold of the lock. The runner is the self-built executable, so
# every command's BUSTER_COMPILER is it. Its tree, `ci2630`, is the base tree with its Release build for the build.sh
# calls (check-call-graph) and the inputs.
set -uo pipefail
export LC_ALL=C
d=$HOME/buster-fast-bench/2626-claude
L=$d/scripts/lock.sh
ci=$d/ci2630
out=$d/results/inventory2630
shards=${SHARDS:-12}
mkdir -p "$out" "$d/tmp"
. "$d/scripts/env.sh"
export BUSTER_DEBUG_INFO=0 BUSTER_ORACLE_CACHE=use
export BUSTER_CI_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/buster/ci"
export BUSTER_CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658 BUSTER_PPF_PRAGMA_ORACLE="$d/preprocessor-pragma-oracle"
if [ ! -d "$ci" ]; then
    mkdir "$ci"
    (cd "$d/base" && tar -c --exclude=./build .) | tar -x -C "$ci"
fi
cd "$ci" || exit 2
"$L" bash -c '
    set -e
    ./build.sh --config Release > "$1/prepare.log" 2>&1
    bash tools/ci/build-benchmarks.sh oracle "$BUSTER_PPF_PRAGMA_ORACLE" >> "$1/prepare.log" 2>&1
    clang -dM -E -march="$BUSTER_HOST_ARCH" -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    bash tools/ci/fetch-c-testsuite.sh build/c-testsuite
    bash tools/ci/fetch-sqlite.sh build/sqlite' prepare "$out"
echo "prepare $?"
compiler=$d/self/stage2-t1
sha256sum "$compiler" > "$out/compiler.sha256"
for k in $(seq 1 "$shards"); do
    "$L" bash -c 'cd "$1" && taskset -c 0-7 "$2" parallel --jobs 8 --timeout 600 --shard "$3/$4" --costs tools/ci/costs/vector-none-O3.costs < tools/ci/correctness.tests > "$5/shard-$3-of-$4.log" 2>&1; echo "status $?" >> "$5/shard-$3-of-$4.log"' shard "$ci" "$compiler" "$k" "$shards" "$out"
    tail -1 "$out/shard-$k-of-$shards.log"
done
echo inventory-done
