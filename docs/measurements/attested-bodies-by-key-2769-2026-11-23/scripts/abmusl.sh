#!/bin/bash
# abmusl.sh LABEL TREE...: musl's 1,336 units as one -c command, one lane (CPU 2, setarch -R), interleaved rounds (ROUNDS,
# default 7): each tree with --attested=on (the lane's own memo) and --attested=off, one perf stat each;
# results/abmusl-LABEL.csv a line a run (round, tree, way, cycles:u, instructions:u, page-faults) and the medians.
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$HOME/buster-fast-bench/672-rest-claude/common.sh"
out=$here/results
scratch=$here/scratch
mkdir -p "$out" "$scratch"
label=$1
shift
trees=("$@")
rounds=${ROUNDS:-7}
mapfile -t sources < "$HOME/buster-fast-bench/672-rest-claude/scratch/musl-units.txt"
{ echo "== abmusl $label ${trees[*]} $(date -u +%FT%TZ)"; head -3 /var/lib/buster-9700x/owner; cat /proc/loadavg; } >> "$out/holds.txt"
csv=$out/abmusl-$label.csv
: > "$csv"
for round in $(seq 1 "$rounds"); do
    for tree in "${trees[@]}"; do
        for way in on off; do
            rm -rf "$scratch/m"; mkdir -p "$scratch/m"
            (cd "$scratch/m" && setarch -R taskset -c 2 perf stat -x, -o "$scratch/one.csv" -e cycles:u,instructions:u,page-faults -- \
                "$here/$tree/build/compiler" --lanes 1 --attested=$way "${musl_options[@]}" -c "${sources[@]}" > /dev/null 2>> "$out/abmusl-$label.err")
            echo "$round,$tree,$way,$(grep -E 'cycles:u|instructions:u|page-faults' "$scratch/one.csv" | cut -d, -f1 | paste -sd,)" >> "$csv"
        done
    done
done
rm -rf "$scratch/m"
for tree in "${trees[@]}"; do
    for way in on off; do
        printf '%s %s' "$tree" "$way"
        for column in 4 5 6; do
            printf ' %s' "$(grep ",$tree,$way," "$csv" | cut -d, -f$column | sort -n | awk '{v[NR]=$1} END {print v[int((NR+1)/2)]}')"
        done
        echo
    done
done | tee "$out/abmusl-$label-medians.txt"
