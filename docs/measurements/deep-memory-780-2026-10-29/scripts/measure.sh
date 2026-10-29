#!/usr/bin/env bash
# -c of the frozen sqlite3.c (the 9700X job's compile-time options), the first tree against the second, in one hold of
# the lock. First the receipts (host, tools, CPU 2's governor, the trees' commits, the executables' and the input's
# SHA-256), a drive check of each tree (its status and object), then 8 rounds in which each tree, in an order alternated
# by round, runs 3 times under perf stat on CPU 2, each run's exit status written beside its counters. $1 and $2: trees.
set -uo pipefail
a="$1"
b="$2"
dir="$HOME/buster-fast-bench/merged-759-780-claude"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
cd "$dir" || exit 1
echo "date $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "host $(uname -a)"
echo "cpu $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2-)"
echo "governor cpu2 $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor)"
echo "clang $(clang --version | head -1)"
echo "perf $(perf --version)"
echo "lock $(head -1 /var/lib/buster-9700x/owner 2>/dev/null)"
echo "trees $a $(cat "$a/COMMIT") $b $(cat "$b/COMMIT")"
sha256sum "$a/build/compiler" "$b/build/compiler" "$sqlite/sqlite3.c"
for tree in "$a" "$b"; do
    taskset -c 2 "./$tree/build/compiler" "${options[@]}" -o "$dir/$tree.o"
    echo "drive $tree status $?"
done
cmp "$a.o" "$b.o" && echo "objects identical"
sha256sum "$a.o" "$b.o"
for round in 1 2 3 4 5 6 7 8; do
    if [ $((round % 2)) -eq 1 ]; then order="$a $b"; else order="$b $a"; fi
    for tree in $order; do
        for run in 1 2 3; do
            perf stat -x, -o "$dir/perf-$a-$b.csv" -e instructions:u,cycles:u,task-clock taskset -c 2 "./$tree/build/compiler" "${options[@]}" -o "$dir/$tree-run.o" > /dev/null 2>&1
            status=$?
            grep -E 'instructions|cycles|task-clock' "$dir/perf-$a-$b.csv" | sed "s/^/round $round $tree run $run status $status,/"
        done
    done
done
echo done
