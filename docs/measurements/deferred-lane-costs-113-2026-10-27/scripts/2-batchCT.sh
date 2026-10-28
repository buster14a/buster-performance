#!/bin/bash
# c-testsuite programs in one lock hold, round ROUND: eight lanes against one by main rule and by the branch rule, each
# program and run in a process of its own (runs.sh), the runs order alternating by program and by round.
# Arguments: LOG ROUND PROGRAM...
D=~/buster-fast-bench/113-lanes-cloud
L="$1"
round="$2"
shift 2
place=$round
for program in "$@"; do
    file="$D/c-testsuite/tests/single-exec/$program.c"
    if [ $((place % 2)) = 0 ]; then
        "$D/runs.sh" "$L" "$round" "$program" "$file" 24 main:8 branch:8
    else
        "$D/runs.sh" "$L" "$round" "$program" "$file" 24 branch:8 main:8
    fi
    place=$((place + 1))
done
