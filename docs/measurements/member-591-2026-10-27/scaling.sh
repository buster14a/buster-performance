#!/bin/bash
# scaling.sh OUT TREE...: in one hold, each tree's -fsyntax-only and -c of each scaling unit, perf stat -r 3, the trees
# taking turns per unit.
cd ~/buster-fast-bench/member-591-claude || exit 1
out="$1"
shift
mkdir -p "$out"
python3 gen.py units
~/buster-fast-bench/member-591-claude/lock.sh bash -c '
out="$1"; shift
for unit in units/records-*.c units/members-*.c; do
    name=$(basename "$unit" .c)
    for tree in "$@"; do
        for mode in fsyntax c; do
            if [ $mode = c ]; then args=(-c "$unit" -o "$out/$tree-$name.o"); else args=(-fsyntax-only "$unit"); fi
            taskset -c 2 perf stat -r 3 -x, -e task-clock,instructions:u -o "$out/$name-$tree-$mode.csv" -- "$tree/build/compiler" "${args[@]}" > /dev/null 2>&1 || echo "failed: $tree $name $mode" >> "$out/errors.txt"
        done
    done
done
' scaling "$out" "$@"
echo done > "$out/done"
