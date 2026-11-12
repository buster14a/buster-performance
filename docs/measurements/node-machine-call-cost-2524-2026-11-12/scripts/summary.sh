#!/bin/bash
# summary.sh LABEL[:SUFFIX]...: T's and all three sweeps' cycles and instructions a node from each label's time files.
cd "$(dirname "$0")/results"
for spec in "$@"; do
    label=${spec%%:*}
    suffix=
    [[ $spec == *:* ]] && suffix=${spec#*:}
    for f in time-sqlite3 time-sqlite3-repeat2 time-lua time-lua-repeat2; do
        file=$label/$f$suffix.txt
        [ -f "$file" ] || continue
        t=$(grep -h "time sweeps=T passes" "$file" | sed 's/.*cycles=\([0-9.]*\) instructions=\([0-9.]*\) ticks.*/\1 \2/')
        all=$(grep -h "time sweeps=T+C+X " "$file" | sed 's/.*cycles=\([0-9.]*\) instructions=\([0-9.]*\) ticks.*/\1 \2/')
        printf '%-10s %-22s T %s   all %s\n' "$spec" "$f" "$t" "$all"
    done
    grep -h "argument-memo" $label/time-sqlite3$suffix.txt $label/time-lua$suffix.txt 2>/dev/null
done
