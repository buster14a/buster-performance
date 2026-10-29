#!/bin/bash
# #847's region diagnostic: diag847 (b2e2169e with BUSTER_847_REGIONS and BUSTER_847_NOFAULT, not committed) on units by
# the rule with no unit large (the rare columns huge pages), 6 passes, with the fault-in and without, each region's state
# before the fault-in and after the lanes (o: own page, z: the huge zero page, -: none), into logs/diag847.txt. A lock
# hold for the whole run.
. ~/buster-fast-bench/claude-764/scripts/env.sh
L="$D/logs/diag847.txt"
for unit in "$@"; do
    file=$(unit_file "$unit")
    for nofault in 0 1; do
        for lanes in 8; do
            echo "== $unit nofault=$nofault lanes=$lanes rule" >> "$L"
            if [ "$nofault" = 1 ]; then
                BUSTER_847_REGIONS=1 BUSTER_847_NOFAULT=1 "$D/trees/diag847/build/compiler" benchmark-checker-deferred --passes 6 --lanes "$lanes" --cpus 2,0,1,3,4,5,6,7 --base-page-tokens 4294967295 "${options[@]}" "$file" >> "$L" 2>&1
            else
                BUSTER_847_REGIONS=1 "$D/trees/diag847/build/compiler" benchmark-checker-deferred --passes 6 --lanes "$lanes" --cpus 2,0,1,3,4,5,6,7 --base-page-tokens 4294967295 "${options[@]}" "$file" >> "$L" 2>&1
            fi
            echo "exit=$? $(date -Is)" >> "$L"
        done
    done
done
