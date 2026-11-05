#!/bin/bash
# E2 for #874: one unit, one tree, cold readings, 6 passes on 8 lanes; every page fault with its time, IP, symbol and
# address, and perf stat's counts. Arguments: UNIT TREE.
. ~/buster-fast-bench/874-verify/scripts/env.sh
unit="$1"
tree="$2"
file=$(unit_file "$unit")
L="$D/logs/E2-$unit-$tree.txt"
stat="$D/perf/stat-$tree-$unit.csv"
data="$D/perf/faults-$tree-$unit.data"
echo "== stat $unit $tree cold lanes 8 $(date -Is)" > "$L"
perf stat -x, -e task-clock,page-faults,cycles:u,cycles:k,instructions:u -o "$stat" \
    "$D/trees/$tree/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --cpus 2,0,1,3,4,5,6,7 --cold "${options[@]}" "$file" >> "$L" 2>&1
echo "stat exit=$? $(date -Is)" >> "$L"
grep -v '^#' "$stat" | grep -v '^$' >> "$L"
echo "== faults $unit $tree cold lanes 8 $(date -Is)" >> "$L"
perf record -q -T -e page-faults -c 1 -d -o "$data" \
    "$D/trees/$tree/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --cpus 2,0,1,3,4,5,6,7 --cold "${options[@]}" "$file" >> "$L" 2>&1
echo "faults exit=$? $(date -Is)" >> "$L"
perf script -i "$data" -F pid,tid,time,ip,sym,addr 2>/dev/null | gzip > "$D/perf/faults-$tree-$unit.txt.gz"
rm -f "$data"
