#!/bin/bash
# Campaign M7 (#847): main as #791's branch has it (MAIN) against the main #764's campaigns measured (OLD), each by its
# rule on up to 8 lanes, on the units B6 read more than 2% slower than OLD and two controls, five rounds, one lock hold
# a round, 30 s apart, into logs/M7.txt. Arguments: MAIN OLD.
. ~/buster-fast-bench/claude-764/scripts/env.sh
main="$1"
old="$2"
: > "$D/scripts/m7.jobs"
for unit in 00213 00204 00200 00182 h16x1 h16x10 d2x1f384s288 l16x19f384 d2x1f480s240 sqlite; do
    passes=24
    if [ "$unit" = sqlite ]; then
        passes=12
    fi
    echo "$unit $passes $main:8 $old:8" >> "$D/scripts/m7.jobs"
done
"$D/scripts/queue847.sh" scripts/m7.jobs logs/M7.txt 1 0 5 10 30
echo "m7 done $(date -Is)" >> "$D/logs/chain.txt"
