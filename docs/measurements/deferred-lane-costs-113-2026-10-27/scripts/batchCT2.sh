#!/bin/bash
# c-testsuite's programs in one lock hold, the branch's rule only: eight lanes against one lane in the same process
# (runs.sh). Arguments: LOG PROGRAM...
D=~/buster-fast-bench/deferred-113-lanes-claude
L="$1"
shift 1
for program in "$@"; do
    "$D/runs.sh" "$L" 1 "$program" "$D/../deferred-lanes-claude/c-testsuite/tests/single-exec/$program.c" 24 final:8
done
