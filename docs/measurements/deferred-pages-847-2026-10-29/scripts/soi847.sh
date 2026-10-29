#!/bin/bash
# Source order's instructions (#847, as #764's soi.sh): benchmark-checker-deferred with --lanes 1 (every reading on one lane, the same
# pages in both trees) under perf stat (user instructions and cycles), on the units at SO5's ends and two more, three
# processes of each tree in turn, in one lock hold, into logs/SOI.txt. Arguments: TREE TREE.
. ~/buster-fast-bench/claude-764/scripts/env.sh
L="$D/logs/SOI847.txt"
for unit in d2x1f480s240 d16x19f384s288 h16x19 sqlite; do
    file=$(unit_file "$unit")
    passes=24
    if [ "$unit" = sqlite ]; then
        passes=12
    fi
    for round in 1 2 3; do
        for tree in "$@"; do
            echo "== round $round $tree $unit lanes 1" >> "$L"
            perf stat -x, -e instructions:u,cycles:u -o "$D/logs/soi847.csv" "$D/trees/$tree/build/compiler" benchmark-checker-deferred --passes "$passes" --lanes 1 \
                --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$file" >> "$L" 2>&1
            echo "exit=$? $(date -Is)" >> "$L"
            grep -E "instructions|cycles" "$D/logs/soi847.csv" >> "$L"
        done
    done
done
