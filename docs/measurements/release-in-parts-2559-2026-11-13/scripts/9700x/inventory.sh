#!/bin/bash
# The correctness inventory (tools/ci/correctness.tests) on the head's Release executable (in parts) on the 9700X, as
# the 9700X job's native correctness runs it: CI's staged Clang 23.1.4 first on PATH, BUSTER_HOST_ARCH=znver5,
# BUSTER_DEBUG_INFO=0, the frozen corpus, c-testsuite, SQLite, the pragma oracle and the predefines; the inventory in
# SHARDS shards (parallel --shard K/N with the vector row's costs), each its own hold of the lock (lock.sh). Adapted
# from #2559's Develop record (develop-configuration-2559-2026-11-12's scripts/9700x/inventory.sh). In the clone `ci`:
#   inventory.sh prepare           build Release and the oracle, fetch the inputs (under the lock)
#   inventory.sh shard K N         run shard K of N (under the lock)
set -euo pipefail
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-release-claude
ci=$d/ci
mkdir -p "$d/results/inventory" "$d/tmp"
cd "$ci"
. "$d/scripts/env.sh"
export BUSTER_DEBUG_INFO=0 BUSTER_ORACLE_CACHE=use
export BUSTER_CI_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/buster/ci"
export BUSTER_CORPUS="$HOME/buster-fast-bench/2559-claude/corpus/preprocessor-391e729af658" BUSTER_PPF_PRAGMA_ORACLE="$d/preprocessor-pragma-oracle"
case "$1" in
    prepare)
        clang --version | head -1
        ./build.sh --config Release
        bash tools/ci/build-benchmarks.sh oracle "$BUSTER_PPF_PRAGMA_ORACLE"
        clang -dM -E -march="$BUSTER_HOST_ARCH" -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
        bash tools/ci/fetch-c-testsuite.sh build/c-testsuite
        bash tools/ci/fetch-sqlite.sh build/sqlite
        grep "parallel native generation" build/cmake/znver5-g0/CMakeCache.txt build.log 2> /dev/null || true
        sha256sum "$(./build.sh print-output --config Release)"
        ;;
    shard)
        compiler=$(./build.sh print-output --config Release)
        head -1 /var/lib/buster-9700x/owner > "$d/results/inventory/shard-$2-of-$3.holder.txt"
        status=0
        taskset -c 0-7 "$compiler" parallel --jobs 8 --timeout 600 --shard "$2/$3" --costs tools/ci/costs/vector-none-O3.costs \
            < tools/ci/correctness.tests > "$d/results/inventory/shard-$2-of-$3.log" 2>&1 || status=$?
        echo "status $status" >> "$d/results/inventory/shard-$2-of-$3.log"
        exit "$status"
        ;;
    *) echo "usage: inventory.sh prepare | shard K N" >&2; exit 2 ;;
esac
