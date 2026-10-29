#!/bin/bash
# #847's first measurement: where base pages cost a multi-lane reading. For each unit, head-95fc3668 (base pages where
# the rule plans more than one lane) and headhuge-95fc3668 (huge pages at every reading), by the rule on up to 8 lanes,
# 6 passes: perf stat (page faults, data TLB misses, user and kernel cycles), then every page fault recorded with its
# address (perf record -e page-faults -c 1 -d), summarized by thread and symbol. One lock hold per unit.
. ~/buster-fast-bench/claude-764/scripts/env.sh
L="$D/logs/E1.txt"
mkdir -p "$D/perf847"
for unit in "$@"; do
    file=$(unit_file "$unit")
    cat > "$D/scripts/e1-unit.sh" <<INNER
#!/bin/bash
. ~/buster-fast-bench/claude-764/scripts/env.sh
for tree in head-95fc3668 headhuge-95fc3668; do
    echo "== stat \$tree $unit lanes 8" >> "$L"
    perf stat -x, -e task-clock,page-faults,ls_l1_d_tlb_miss.all,ls_l1_d_tlb_miss.all_l2_miss,cycles:u,cycles:k,instructions:u -o "$D/perf847/stat-\$tree-$unit.csv" \
        "$D/trees/\$tree/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --cpus 2,0,1,3,4,5,6,7 "\${options[@]}" "$file" >> "$L" 2>&1
    echo "exit=\$? \$(date -Is)" >> "$L"
    grep -v "^#" "$D/perf847/stat-\$tree-$unit.csv" | grep -v "^\$" >> "$L"
    echo "== faults \$tree $unit lanes 8" >> "$L"
    perf record -q -e page-faults -c 1 -d -o "$D/perf847/faults-\$tree-$unit.data" \
        "$D/trees/\$tree/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --cpus 2,0,1,3,4,5,6,7 "\${options[@]}" "$file" >> "$L" 2>&1
    echo "exit=\$? \$(date -Is)" >> "$L"
    perf script -i "$D/perf847/faults-\$tree-$unit.data" -F pid,tid,ip,sym,addr 2>/dev/null | gzip > "$D/perf847/faults-\$tree-$unit.txt.gz"
done
INNER
    chmod +x "$D/scripts/e1-unit.sh"
    ~/buster-fast-bench/exclusive.sh "$D/scripts/e1-unit.sh" > /dev/null 2>> "$D/logs/queue.lock.txt"
    sleep 20
done
echo "e1 done $(date -Is)" >> "$D/logs/chain.txt"
