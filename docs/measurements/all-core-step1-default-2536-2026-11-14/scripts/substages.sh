#!/bin/bash
# substages.sh DIR...: each gauge's median of the back half's sub-stages by cohort, from the counted runs' reports.
for d in "$@"; do
    for cohort in one eight; do
        printf "%-22s %-6s" "$d" "$cohort"
        for s in lower.prepare lower.statements lower.bodies lower.validate lower.rest lower tier0 emit-setup branch-sizing encode unwind code-atoms; do
            v=$(cat $d/counted/r*.$cohort/w*.txt 2>/dev/null | awk -v s="$s" -F'\t' '$1 == "time-stage" && $2 == s { print $3 }' | sort -n | awk '{ a[NR] = $1 } END { print a[int((NR + 1) / 2)] }')
            printf " %s=%s" "$s" "$v"
        done
        echo
    done
done
