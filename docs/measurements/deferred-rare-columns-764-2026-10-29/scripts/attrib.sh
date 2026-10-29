#!/bin/bash
# Where the racing lanes' time goes (#764): main and multicols on b16x77 and h16x19, on 8 lanes with every lane, each
# process's counters (perf stat: task-clock, user and kernel cycles, user instructions, page faults, context switches;
# and around it /proc/vmstat's huge-page counters and /proc/interrupts' TLB shootdowns and function call interrupts),
# twice in turn, then a cycles profile of each at a fixed period (perf record -c 200003: samples count cycles, with no
# frequency throttling), whose samples by thread and symbol perf script writes. Run inside one lock hold.
. ~/buster-fast-bench/claude-764/scripts/env.sh
L="$D/logs/attrib.txt"
mkdir -p "$D/perf"
counters()
{
    awk '$1 ~ /^(thp_fault_alloc|thp_fault_fallback|pgalloc_normal|thp_split_pmd|thp_zero_page_alloc)$/ { printf "%s=%s ", $1, $2 }' /proc/vmstat
    awk '$1 == "TLB:" || $1 == "CAL:" { s = 0; for (i = 2; i <= NF; i += 1) if ($i ~ /^[0-9]+$/) s += $i; printf "%s%d ", $1, s }' /proc/interrupts
    echo
}
for unit in b16x77 h16x19; do
    file=$(unit_file "$unit")
    for round in 1 2; do
        for tree in main-bc11fddb multicols-865271ef pop-98023033; do
            echo "== stat round $round $tree $unit lanes 8 every" >> "$L"
            echo "before: $(counters)" >> "$L"
            perf stat -x, -e task-clock,cycles:u,cycles:k,instructions:u,page-faults,context-switches,cpu-migrations -o "$D/perf/stat-$round-$tree-$unit.csv" \
                "$D/trees/$tree/build/compiler" benchmark-checker-deferred --passes 24 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$file" >> "$L" 2>&1
            echo "exit=$? $(date -Is)" >> "$L"
            echo "after: $(counters)" >> "$L"
            cat "$D/perf/stat-$round-$tree-$unit.csv" >> "$L"
        done
    done
    for tree in main-bc11fddb multicols-865271ef pop-98023033; do
        echo "== record $tree $unit lanes 8 every" >> "$L"
        perf record -q -e cycles -c 200003 -o "$D/perf/record-$tree-$unit.data" \
            "$D/trees/$tree/build/compiler" benchmark-checker-deferred --passes 24 --lanes 8 --every-lane --cpus 2,0,1,3,4,5,6,7 "${options[@]}" "$file" >> "$L" 2>&1
        echo "exit=$? $(date -Is)" >> "$L"
        perf script -i "$D/perf/record-$tree-$unit.data" -F pid,tid,ip,sym 2>/dev/null | gzip > "$D/perf/record-$tree-$unit.txt.gz"
    done
done
echo "attrib done $(date -Is)" >> "$L"
