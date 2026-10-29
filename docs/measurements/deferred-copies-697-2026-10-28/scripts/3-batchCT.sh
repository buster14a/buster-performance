#!/bin/bash
# c-testsuite programs in one lock hold, round ROUND: eight lanes against one by main3's rule and by final3's, each
# program and run in a process of its own (3-runs.sh), the runs' order alternating by program and by round.
# Arguments: LOG ROUND PROGRAM... Record A2's batchCT.sh with this work directory and trees.
D=~/buster-fast-bench/697-cloud
L="$1"
round="$2"
shift 2
place=$round
for program in "$@"; do
    file="$D/c-testsuite/tests/single-exec/$program.c"
    if [ $((place % 2)) = 0 ]; then
        "$D/3-runs.sh" "$L" "$round" "$program" "$file" 24 main3:8 final3:8
    else
        "$D/3-runs.sh" "$L" "$round" "$program" "$file" 24 final3:8 main3:8
    fi
    place=$((place + 1))
done
