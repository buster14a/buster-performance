#!/bin/bash
# #872: instruction and cycle counts for the endpoint trees on two units, for the stage attribution.
# Arguments: LOG TREE...
. /home/david/buster-fast-bench/872-qual-20261101/scripts/env.sh
L="$1"
shift
for tree in "$@"; do
    for unit in 00204 sqlite; do
        passes=24
        if [ "$unit" = sqlite ]; then passes=6; fi
        file=$(unit_file "$unit")
        echo "== perf $tree $unit $(cat "$D/trees/$tree/COMMIT")" >> "$L"
        ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -r 3 -e instructions:u,cycles:u \
            "$D/trees/$tree/build/compiler" benchmark-checker-deferred --passes "$passes" --lanes 1 \
            "${options[@]}" "$file" > /dev/null 2>> "$L"
        echo "exit=$? $(date -Is)" >> "$L"
    done
done
