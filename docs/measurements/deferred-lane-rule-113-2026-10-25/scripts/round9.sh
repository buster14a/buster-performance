#!/bin/bash
# One round of the six units' three runs: LOG ROUND. Each unit's runs and the units' order rotate by round.
D=~/buster-fast-bench/deferred-lanes-claude
L="$1"
round="$2"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
units=(synthetic/h16x1.c synthetic/h16x19.c synthetic/h16x154.c synthetic/x16x19.c synthetic/b16x19.c sqlite)
runs=(timed:2:every timed:8:every balanced:8:every)
count=${#units[@]}
for ((i = 0; i < count; i += 1)); do
    unit="${units[$(((i + round - 1) % count))]}"
    passes=24
    file="$D/$unit"
    if [ "$unit" = sqlite ]; then
        passes=12
        file="$corpus/sqlite/sqlite3.c"
    fi
    first=$(((i + round) % 3))
    "$D/runs.sh" "$L" "$round" "$unit" "$file" "$passes" "${runs[$first]}" "${runs[$(((first + 1) % 3))]}" "${runs[$(((first + 2) % 3))]}"
done
