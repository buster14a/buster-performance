#!/bin/bash
# One job's runs (batch.sh runs it inside a lock hold): benchmark-checker-deferred on one unit, a process per run, each
# run's heading, output and exit status appended to the log. Arguments: LOG ROUND UNIT PASSES then one or more runs,
# each TREE:LANES[:every][:warm]. Record A2's runs.sh with this work directory and its trees.
. ~/buster-fast-bench/claude-764/scripts/env.sh
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
        if [ "$f" = every ]; then
            extra+=(--every-lane)
            name="$name-every"
        elif [ "$f" = warm ]; then
            extra+=(--warm)
            name="$name-warm"
        fi
    done
    echo "== round $round $name $unit lanes $lanes" >> "$L"
    "$D/trees/$tree/build/compiler" benchmark-checker-deferred --passes "$passes" --lanes "$lanes" --cpus 2,0,1,3,4,5,6,7 "${extra[@]}" "${options[@]}" "$file" >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
done
