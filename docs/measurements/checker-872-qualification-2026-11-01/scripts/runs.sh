#!/bin/bash
# #872: one round of the campaign. Each tree's benchmark command takes the lock for its own run.
# Arguments: LOG ROUND TREE...
. /home/david/buster-fast-bench/872-qual-20261101/scripts/env.sh
L="$1"
round="$2"
shift 2
units=(00213 00182 00204 h16x1 h16x10 00200 d2x1f384s288 l16x19f384 d2x1f480s240 sqlite)
trees=("$@")
nt=${#trees[@]}
nu=${#units[@]}
for ((ui = 0; ui < nu; ui += 1)); do
    unit=${units[$(((ui + (round - 1) * 3) % nu))]}
    passes=24
    if [ "$unit" = sqlite ]; then passes=12; fi
    file=$(unit_file "$unit")
    for ((ti = 0; ti < nt; ti += 1)); do
        tree=${trees[$(((ti + (round - 1) * 2 + ui) % nt))]}
        echo "== round $round $tree $unit" >> "$L"
        ~/buster-fast-bench/exclusive.sh "$D/trees/$tree/build/compiler" benchmark-checker-deferred \
            --passes "$passes" --lanes 8 --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$file" >> "$L" 2>&1
        echo "exit=$? $(date -Is)" >> "$L"
    done
done
