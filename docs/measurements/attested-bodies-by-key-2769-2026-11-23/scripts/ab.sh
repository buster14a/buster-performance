#!/bin/bash
# ab.sh LABEL TREE...: #2769's interleaved A/B on the 9700X, one hold of the lock (run by qab.sh), pinned to CPU 2 with
# address-space randomization off. Each TREE's warm memo of sqlite3.c (made by its own compiler, once), then ROUNDS
# rounds (default 11), each running every tree's -c sqlite3.c with its memo and with --attested=off, one perf stat each,
# in the round's order; results/ab-LABEL.csv has a line a run: round, tree, way, cycles:u, instructions:u, page-faults.
# Then perf record of five warm compiles a tree, the attested symbols' shares (results/ab-LABEL-record-TREE.txt).
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$HOME/buster-fast-bench/672-rest-claude/common.sh"
out=$here/results
scratch=$here/scratch
mkdir -p "$out" "$scratch"
label=$1
shift
trees=("$@")
rounds=${ROUNDS:-11}
{ echo "== ab $label ${trees[*]} $(date -u +%FT%TZ)"; head -3 /var/lib/buster-9700x/owner; cat /proc/loadavg; grep -E "MemFree|AnonHugePages" /proc/meminfo; } >> "$out/holds.txt"
for tree in "${trees[@]}"; do
    if [ ! -d "$scratch/memo-$tree" ]; then
        rm -rf "$scratch/t"; mkdir -p "$scratch/t"
        (cd "$scratch/t" && setarch -R taskset -c 2 "$here/$tree/build/compiler" "${sqlite_options[@]}" --attested-memo="$scratch/memo-$tree" -c "$sqlite/sqlite3.c" > /dev/null 2>> "$out/ab-$label.err")
        chmod -R a-w "$scratch/memo-$tree"
    fi
done
csv=$out/ab-$label.csv
: > "$csv"
rm -rf "$scratch/t"; mkdir -p "$scratch/t"
for round in $(seq 1 "$rounds"); do
    for tree in "${trees[@]}"; do
        for way in memo off; do
            option=(--attested=off)
            [ "$way" = memo ] && option=(--attested-memo="$scratch/memo-$tree")
            (cd "$scratch/t" && setarch -R taskset -c 2 perf stat -x, -o "$scratch/one.csv" -e cycles:u,instructions:u,page-faults -- \
                "$here/$tree/build/compiler" "${sqlite_options[@]}" "${option[@]}" -c "$sqlite/sqlite3.c" > /dev/null 2>> "$out/ab-$label.err")
            echo "$round,$tree,$way,$(grep -E 'cycles:u|instructions:u|page-faults' "$scratch/one.csv" | cut -d, -f1 | paste -sd,)" >> "$csv"
        done
    done
done
for tree in "${trees[@]}"; do
    for i in 1 2 3 4 5; do printf '%q ' "$here/$tree/build/compiler" "${sqlite_options[@]}" --attested-memo="$scratch/memo-$tree" -c "$sqlite/sqlite3.c"; echo; done > "$scratch/five.sh"
    (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e cycles:u -F 50000 -o "$scratch/ab-$tree.data" -- bash "$scratch/five.sh" > /dev/null 2>&1)
    { perf report -i "$scratch/ab-$tree.data" --stdio 2> /dev/null | grep -m1 'of event'; perf report -i "$scratch/ab-$tree.data" --no-children --comm compiler --sort symbol --stdio 2> /dev/null | grep -E 'attested'; } > "$out/ab-$label-record-$tree.txt"
done
rm -rf "$scratch/t"
# Medians a tree and way: cycles, instructions, page faults.
for tree in "${trees[@]}"; do
    for way in memo off; do
        printf '%s %s' "$tree" "$way"
        for column in 4 5 6; do
            printf ' %s' "$(grep ",$tree,$way," "$csv" | cut -d, -f$column | sort -n | awk '{v[NR]=$1} END {print v[int((NR+1)/2)]}')"
        done
        echo
    done
done | tee "$out/ab-$label-medians.txt"
