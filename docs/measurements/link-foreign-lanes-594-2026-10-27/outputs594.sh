#!/bin/bash
# outputs594.sh: each confirmation case's last output by every variant (outc/VARIANT-CASE), by sha256, grouped by case:
# every variant of a case must have written the same bytes.
set -u
cd ~/buster-fast-bench/perf-594-claude/outc
status=0
for case in $(ls | grep -v '^w' | sed 's/^[a-z0-9]*-//' | sort -u); do
    sums=$(sha256sum *-"$case" | grep -v ' w' | awk '{print $1}' | sort -u | wc -l)
    printf '%-14s %s variants, %s distinct: %s\n' "$case" "$(ls *-"$case" | grep -vc '^w')" "$sums" "$(sha256sum $(ls *-"$case" | grep -v '^w') | awk '{print substr($1,1,16)}' | sort -u | tr '\n' ' ')"
    [ "$sums" = 1 ] || status=1
done
exit $status
