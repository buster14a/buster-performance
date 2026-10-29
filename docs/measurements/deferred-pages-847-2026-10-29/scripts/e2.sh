#!/bin/bash
# #847's E2: whether the claims leave each 2 MB region of the rare columns one lane's fault. For each unit, the claim
# tree with no unit large (`huge`: the lanes claim where more than one reads), main as the tree has it (huge pages, the
# lanes racing) and the claim tree as it is, by the rule on up to 8 lanes, 6 passes: perf stat (task-clock, page faults,
# user and kernel cycles), then every page fault recorded with its time and address (perf record -e page-faults -c 1 -d
# -T). One lock hold per unit. Arguments: TREE MAIN UNIT...
. ~/buster-fast-bench/claude-764/scripts/env.sh
L="$D/logs/E2.txt"
tree="$1"
main="$2"
shift 2
mkdir -p "$D/perf847e2"
for unit in "$@"; do
    file=$(unit_file "$unit")
    cat > "$D/scripts/e2-unit.sh" <<INNER
#!/bin/bash
. ~/buster-fast-bench/claude-764/scripts/env.sh
for run in $tree:huge $main: $tree:; do
    t=\${run%%:*}
    flag=\${run#*:}
    extra=()
    name=\$t
    if [ "\$flag" = huge ]; then
        extra=(--base-page-tokens 4294967295)
        name=\$t-huge
    fi
    echo "== stat \$name $unit lanes 8" >> "$L"
    perf stat -x, -e task-clock,page-faults,cycles:u,cycles:k,instructions:u -o "$D/perf847e2/stat-\$name-$unit.csv" \
        "$D/trees/\$t/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --cpus 2,0,1,3,4,5,6,7 "\${extra[@]}" "\${options[@]}" "$file" >> "$L" 2>&1
    echo "exit=\$? \$(date -Is)" >> "$L"
    grep -v "^#" "$D/perf847e2/stat-\$name-$unit.csv" | grep -v "^\$" >> "$L"
    echo "== faults \$name $unit lanes 8" >> "$L"
    perf record -q -T -e page-faults -c 1 -d -o "$D/perf847e2/faults-\$name-$unit.data" \
        "$D/trees/\$t/build/compiler" benchmark-checker-deferred --passes 6 --lanes 8 --cpus 2,0,1,3,4,5,6,7 "\${extra[@]}" "\${options[@]}" "$file" >> "$L" 2>&1
    echo "exit=\$? \$(date -Is)" >> "$L"
    perf script -i "$D/perf847e2/faults-\$name-$unit.data" -F pid,tid,time,ip,sym,addr 2>/dev/null | gzip > "$D/perf847e2/faults-\$name-$unit.txt.gz"
    rm -f "$D/perf847e2/faults-\$name-$unit.data"
done
INNER
    chmod +x "$D/scripts/e2-unit.sh"
    ~/buster-fast-bench/exclusive.sh "$D/scripts/e2-unit.sh" > /dev/null 2>> "$D/logs/queue.lock.txt"
    sleep 20
done
echo "e2 done $(date -Is)" >> "$D/logs/chain.txt"
