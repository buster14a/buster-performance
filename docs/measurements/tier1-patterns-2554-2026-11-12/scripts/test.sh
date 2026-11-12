#!/bin/bash
# test.sh NAME: src-NAME's optimizer tests (the threading fixtures by both paths), its Tier 1 selection, emission and
# pipeline tests and the #2554 and #1218 driver regressions. Run inside one hold of the lock. results/test-NAME.txt.
cd "$(dirname "$0")/src-$1"
unset CPATH C_INCLUDE_PATH
{
    for t in test-ir-optimize test-tier1-select test-tier1-emit "test-tier1-pipeline --cross-check"; do
        echo "== $t"; taskset -c 2-3 ./build/compiler $t 2>&1 | tail -2; echo "status $?"
    done
    clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tests/driver/tier1_patterns.c -o build/test-driver-tier1-patterns && ./build/test-driver-tier1-patterns build/compiler "$(command -v clang)" 2>&1 | grep -v "^tier1"
    clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tests/driver/tier1_truth.c -o build/test-driver-tier1-truth && ./build/test-driver-tier1-truth build/compiler "$(command -v clang)" 2>&1 | grep -v "^tier1"
} > "../results/test-$1.txt" 2>&1
