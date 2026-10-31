#!/bin/bash
set -uo pipefail
cd /tmp/opencode/takeover-942
taskset -c 2 ./build/compiler test-ir-source --dataflow-benchmark $(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt) > bench-testsuite.out 2> bench-testsuite.err
status=$?
printf 'exit=%d\n' "$status" > bench-testsuite.status
exit "$status"
