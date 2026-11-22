#!/usr/bin/env bash
# ctest.sh: c-testsuite fetched as CI fetches it (tools/ci/fetch-c-testsuite.sh, from the 9700X's cache), then the
# "c-testsuite's programs with Tier 1's code" block through each PR tree's published Develop build, under the lock.
set -uo pipefail
. "$HOME/buster-fast-bench/3130-claude/env.sh"
export PATH="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin:$HOME/.cache/buster/build-tools/cmake-4.4.3-ninja-1.13.2/bin:$PATH"
for n in 3130 3143; do
    cd "$W/w$n"
    rm -rf build/c-testsuite
    bash tools/ci/fetch-c-testsuite.sh build/c-testsuite
    git -C build/c-testsuite rev-parse HEAD
    ls build/c-testsuite/tests/single-exec | wc -l
    cmp build/compiler "$W/bin/$n-develop" && echo "build/compiler is bin/$n-develop"
    awk -v re='c-testsuite --tier1' -f "$W/blocks.awk" tools/ci/correctness.tests > "$W/logs/list-$n-ctest.txt"
    log="$W/logs/tests-$n-develop-ctest.log"
    { clang --version | head -1; date -u -Iseconds; } > "$log"
    "$LOCK" timeout -k 10 900 ./build/compiler parallel --jobs 8 --timeout 800 < "$W/logs/list-$n-ctest.txt" >> "$log" 2>&1
    echo "ctest $n exit $?" | tee -a "$log"
done
touch "$W/ctest.done"
