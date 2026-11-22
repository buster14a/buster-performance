#!/usr/bin/env bash
# tests.sh TREE NAME: the Tier 1, SSA and IR blocks of TREE's tools/ci/correctness.tests and the ownership block,
# through the tree's own published Develop build (its `parallel` sets BUSTER_COMPILER to itself), in two cost-balanced
# shards, each its own hold of the lock, with CI's Clang 23.1.4 and Ninja 1.13.2 first on PATH and the 9700X's corpus.
set -uo pipefail
. "$HOME/buster-fast-bench/3067-claude/env.sh"
tree=$1; name=$2
export PATH="$CLANG_BIN:$TOOLS_BIN:$PATH"
export BUSTER_CORPUS="$CORPUS" BUSTER_CI_CACHE="$HOME/.cache/buster/ci"
cd "$W/$tree"
if [ ! -d build/c-testsuite/tests ]; then
    rm -rf build/c-testsuite
    bash tools/ci/fetch-c-testsuite.sh build/c-testsuite
fi
if [ ! -d build/sqlite/test ]; then
    rm -rf build/sqlite
    bash tools/ci/fetch-sqlite.sh build/sqlite
fi
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
git -C build/c-testsuite rev-parse HEAD
git -C build/sqlite rev-parse HEAD
list="$W/logs/list-$name.txt"
awk -v re='[Tt]ier ?1|tier1|SSA|ssa|test-ir|IR|ownership-only' -v ex='no-recursion rule|static executables with libc' -f "$W/blocks.awk" tools/ci/correctness.tests > "$list"
grep -c '^== ' "$list"
status=0
# The tree's own published Develop build (the ownership block refuses a detached copy); bin/NAME is its copy.
cmp build/compiler "$W/bin/$name" || exit 1
for shard in 1 2; do
    log="$W/logs/tests-$name-$shard.log"
    { clang --version | head -1; ninja --version; date -u -Iseconds; } > "$log"
    "$LOCK" timeout -k 10 540 taskset -c 0-7 ./build/compiler parallel --jobs 8 --timeout 500 --shard "$shard/2" --costs tools/ci/costs/native-none-O3.costs < "$list" >> "$log" 2>&1
    s=$?
    date -u -Iseconds >> "$log"
    echo "tests $name shard $shard exit $s" | tee -a "$log"
    if [ "$s" != 0 ]; then status=$s; fi
done
exit $status
