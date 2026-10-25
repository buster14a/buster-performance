#!/bin/bash
# run2.sh PID: after run.sh (the process PID) ends, link-foreign (the executable unit, its linker modules in the
# dynamic unit's home) as benchmark-link runs it, the same trees and executables, under ab --rounds 3 --lock, unpinned,
# since benchmark-link pins its one-thread runs itself and runs the others on every CPU.
set -u
while kill -0 "$1" 2> /dev/null; do
    sleep 10
done
D=~/buster-fast-bench/build-270-claude/ab3
L=$D/run2.log
export EXCLUSIVE_OWNER=claude-270
export EXCLUSIVE_TITLE="Build: main.c's compile is build.sh's critical path (#270)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/424
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
LOCK=~/buster-fast-bench/exclusive.sh
echo "=== start $(date -Is)" >> "$L"
cd "$D/base"
"$D/base/build/compiler" ab --rounds 3 --lock "$LOCK" "$D/base" "$D/head" \
    -- benchmark-link --only linkers --linkers link-foreign --kinds dynamic,static --functions 2000,102400 --runs 11 \
        --directory /tmp >> "$L" 2>&1
echo "ab status $?" >> "$L"
echo "done $(date -Is)" >> "$L"
