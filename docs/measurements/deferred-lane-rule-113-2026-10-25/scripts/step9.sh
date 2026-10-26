#!/bin/bash
# One locked step of queue9.sh, its output appended to the log: LOG build|test.
D=~/buster-fast-bench/deferred-lanes-claude
L="$1"
echo "== $2 timed $(date -Is)" >> "$L"
if [ "$2" = build ]; then
    (cd "$D/timed" && LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ./build.sh) >> "$L" 2>&1
else
    "$D/timed/build/compiler" test-checker-deferred >> "$L" 2>&1
fi
echo "exit=$? $(date -Is)" >> "$L"
