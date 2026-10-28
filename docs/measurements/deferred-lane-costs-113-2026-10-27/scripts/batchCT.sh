#!/bin/bash
# Programs' runs in one lock hold: LOG FIRST PROGRAM... (FIRST: the first program's place in the list, for the order).
D=~/buster-fast-bench/deferred-113-lanes-claude
L="$1"
place="$2"
shift 2
for program in "$@"; do
    file="$D/../deferred-lanes-claude/c-testsuite/tests/single-exec/$program.c"
    if [ $((place % 2)) = 0 ]; then
        "$D/runs.sh" "$L" 1 "$program" "$file" 24 main:8 final:8
    else
        "$D/runs.sh" "$L" 1 "$program" "$file" 24 final:8 main:8
    fi
    place=$((place + 1))
done
