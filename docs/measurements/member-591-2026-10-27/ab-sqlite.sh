#!/bin/bash
# ab-sqlite.sh OUT TREE...: in one hold of the lock, 8 rounds of each tree's -c and -fsyntax-only of the frozen sqlite3.c
# (the compile-time step's options), perf stat -r 3 each, the trees' order rotated by round, after a warm-up of each.
cd ~/buster-fast-bench/member-591-claude || exit 1
out="$1"
shift
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/member-591-claude/lock.sh bash -c '
out="$1"; sqlite="$2"; shift 2
trees=("$@")
options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
for tree in "${trees[@]}"; do
    taskset -c 2 "$tree/build/compiler" -c "${options[@]}" -o "$out/$tree.o" > /dev/null 2>&1 || echo "warm-up failed: $tree" >> "$out/errors.txt"
done
count=${#trees[@]}
for round in 1 2 3 4 5 6 7 8; do
    for i in $(seq 0 $((count - 1))); do
        tree="${trees[$(( (i + round) % count ))]}"
        for mode in c fsyntax; do
            if [ $mode = c ]; then args=(-c "${options[@]}" -o "$out/$tree.o"); else args=(-fsyntax-only "${options[@]}"); fi
            taskset -c 2 perf stat -r 3 -x, -e task-clock,cycles:u,instructions:u -o "$out/r$round-$tree-$mode.csv" -- "$tree/build/compiler" "${args[@]}" > /dev/null 2>&1 || echo "run failed: $tree $mode $round" >> "$out/errors.txt"
        done
    done
done
' ab "$out" "$sqlite" "$@"
echo done > "$out/done"
