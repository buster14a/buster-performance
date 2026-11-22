#!/usr/bin/env bash
# tests.sh TREE NAME: the Tier 1 inliner's blocks of TREE's tools/ci/correctness.tests and the ownership block,
# through the tree's build/compiler's own `parallel` (which sets BUSTER_COMPILER to itself), under the lock, with CI's clang first.
set -uo pipefail
. "$HOME/buster-fast-bench/3130-claude/env.sh"
tree=$1; name=$2
export PATH="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin:$HOME/.cache/buster/build-tools/cmake-4.4.3-ninja-1.13.2/bin:$PATH"
cd "$W/$tree"
if [ ! -d build/c-testsuite/tests ]; then
    rm -rf build/c-testsuite
    git clone -q --shared --no-checkout "$HOME/.cache/buster/ci/c-testsuite.git" build/c-testsuite
    git -C build/c-testsuite checkout -q --detach 5c7275656d751de0e68b2d340a95b5681858ed07
fi
git -C build/c-testsuite rev-parse HEAD
list="$W/logs/list-$name.txt"
awk -v re='test-ir-inline|test-tier0-inline|test-tier1-pipeline|test-check-debug|c-testsuite --tier1|by Tier 1 on one lane|ownership-only' -f "$W/blocks.awk" tools/ci/correctness.tests > "$list"
grep '^== ' "$list"
log="$W/logs/tests-$name.log"
{ clang --version | head -1; ninja --version; date -u -Iseconds; } > "$log"
# The tree's own published Develop build (the ownership block refuses a detached copy); bin/NAME is its copy.
cmp build/compiler "$W/bin/$name"
"$LOCK" timeout -k 10 1500 ./build/compiler parallel --jobs 8 --timeout 1200 < "$list" >> "$log" 2>&1
status=$?
date -u -Iseconds >> "$log"
echo "tests $name exit $status" | tee -a "$log"
