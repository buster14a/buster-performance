#!/bin/bash
# The fault round: the reach filter's generated-trees test (test-checker-driver --reach-filter-only) under each fault of
# the switch. A fault is caught where the test fails. Arguments: the fault build, the faults' list, the output.
compiler=$1; list=$2; out=$3
: > "$out"
"$compiler" test-checker-driver --executable "$compiler" --reach-filter-only > /dev/null 2>&1; echo "0	no fault	status=$?" >> "$out"
while IFS=$'\t' read -r number name; do
    BUSTER_EXPERIMENT_REACH_FAULT=$number "$compiler" test-checker-driver --executable "$compiler" --reach-filter-only > "$out.$number.log" 2>&1
    status=$?
    lost=$(grep -o '[0-9]* lost' "$out.$number.log" | head -1)
    echo "$number	$name	status=$status	$lost	$([ $status -ne 0 ] && echo caught || echo SURVIVED)" >> "$out"
    rm -f "$out.$number.log"
done < "$list"
