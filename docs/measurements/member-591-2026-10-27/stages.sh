#!/bin/bash
# stages.sh OUT TREE...: in one hold, 15 rounds of each tree's `--time-stages -c` of the frozen sqlite3.c (the compile-time
# step's options), the trees' order rotated by round, after a discarded warm-up of each; each run's report kept.
cd ~/buster-fast-bench/member-591-claude || exit 1
out="$1"
shift
mkdir -p "$out"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/member-591-claude/lock.sh bash -c '
out="$1"; sqlite="$2"; shift 2
trees=("$@")
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
count=${#trees[@]}
for round in $(seq 1 15); do
    for i in $(seq 0 $((count - 1))); do
        tree="${trees[$(( (i + round) % count ))]}"
        if [ $round = 1 ]; then taskset -c 2 "$tree/build/compiler" --time-stages "${options[@]}" -o "$out/$tree.o" > /dev/null 2>&1; fi
        taskset -c 2 "$tree/build/compiler" --time-stages "${options[@]}" -o "$out/$tree.o" > /dev/null 2> "$out/r$round-$tree.txt" || echo "failed: $tree $round" >> "$out/errors.txt"
    done
done
' stages "$out" "$sqlite" "$@"
echo done > "$out/done"
