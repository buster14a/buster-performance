#!/bin/bash
# One job's runs: benchmark-checker-deferred on one unit, a process per run. Arguments: LOG ROUND UNIT PASSES then runs,
# each TREE:LANES[:FLAG]..., flags `cold` (--cold) and `warm` (--warm).
. ~/buster-fast-bench/874-verify/scripts/env.sh
L="$1"
round="$2"
unit="$3"
passes="$4"
shift 4
file=$(unit_file "$unit")
for run in "$@"; do
    IFS=: read -r tree lanes f1 f2 <<< "$run"
    extra=()
    name="$tree"
    for f in "$f1" "$f2"; do
        if [ "$f" = cold ]; then
            extra+=(--cold)
            name="$name-cold"
        elif [ "$f" = warm ]; then
            extra+=(--warm)
            name="$name-warm"
        fi
    done
    echo "== round $round $name $unit lanes $lanes" >> "$L"
    "$D/trees/$tree/build/compiler" benchmark-checker-deferred --passes "$passes" --lanes "$lanes" --cpus 2,0,1,3,4,5,6,7 "${extra[@]}" "${options[@]}" "$file" >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
done
