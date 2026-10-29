#!/bin/bash
# #847: one job's runs (batch847.sh runs it inside a lock hold): benchmark-checker-deferred on one unit, a process per
# run, each run's heading, output and exit status appended to the log. Arguments: LOG ROUND UNIT PASSES then one or more
# runs, each TREE:LANES[:FLAG]..., the flags `every` (--every-lane), `warm` (--warm), `huge` (--base-page-tokens
# 4294967295: no unit is large, so the rare columns stay huge pages, faulted in before more than one lane) and `base`
# (--base-page-tokens 1: every unit is large, so the rare columns are base pages where more than one lane reads). runs.sh
# with the flags of #847.
. ~/buster-fast-bench/claude-764/scripts/env.sh
L="$1"
round="$2"
unit="$3"
passes="$4"
shift 4
file=$(unit_file "$unit")
for run in "$@"; do
    IFS=: read -r tree lanes f1 f2 f3 <<< "$run"
    extra=()
    name="$tree"
    for f in "$f1" "$f2" "$f3"; do
        if [ "$f" = every ]; then
            extra+=(--every-lane)
            name="$name-every"
        elif [ "$f" = warm ]; then
            extra+=(--warm)
            name="$name-warm"
        elif [ "$f" = huge ]; then
            extra+=(--base-page-tokens 4294967295)
            name="$name-huge"
        elif [ "$f" = base ]; then
            extra+=(--base-page-tokens 1)
            name="$name-base"
        fi
    done
    echo "== round $round $name $unit lanes $lanes" >> "$L"
    "$D/trees/$tree/build/compiler" benchmark-checker-deferred --passes "$passes" --lanes "$lanes" --cpus 2,0,1,3,4,5,6,7 "${extra[@]}" "${options[@]}" "$file" >> "$L" 2>&1
    echo "exit=$? $(date -Is)" >> "$L"
done
