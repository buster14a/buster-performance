#!/usr/bin/env bash
# AVX-512.s gathers and scatters (buster #148), the first tree against the second, in one hold of the
# lock: -c of the frozen sqlite3.c (the 9700X job's compile-time options) and of stb_image with -march=native, which
# call none of them: what their catalog rows, checks and recipes cost the units that don't use them. First the receipts, a
# drive check of each tree and unit (its status, the objects compared, and each object's sections' sizes and alignments),
# then 8 rounds in which each tree, in an order alternated by round, compiles each unit 3 times under perf stat on CPU 2,
# each run's exit status beside its counters, into measure-UNIT.log. $1 and $2: the trees.
set -uo pipefail
a="$1"
b="$2"
dir="$HOME/buster-fast-bench/header-148"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sqlite_options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
stb_options=(-c -march=native "-I$dir/stb" "$dir/stb/stb_image.c")
cd "$dir" || exit 1
echo "date $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "host $(uname -a)"
echo "cpu $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2-)"
echo "governor cpu2 $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor)"
echo "clang $(clang --version | head -1)"
echo "perf $(perf --version)"
echo "lock $(head -1 /var/lib/buster-9700x/owner 2>/dev/null)"
echo "trees $a $(cat "$a/COMMIT") $b $(cat "$b/COMMIT")"
sha256sum "$a/build/compiler" "$b/build/compiler" "$sqlite/sqlite3.c" stb/stb_image.h stb/stb_image.c
for unit in sqlite stb; do
    for tree in "$a" "$b"; do
        if [ "$unit" = sqlite ]; then options=("${sqlite_options[@]}"); else options=("${stb_options[@]}"); fi
        taskset -c 2 "./$tree/build/compiler" "${options[@]}" -o "$dir/$unit-$tree.o"
        echo "drive $unit $tree status $?"
    done
    cmp "$unit-$a.o" "$unit-$b.o" && echo "$unit objects identical"
    sha256sum "$unit-$a.o" "$unit-$b.o"
    for tree in "$a" "$b"; do
        echo "sections $unit $tree"
        readelf -SW "$unit-$tree.o" | grep -E "\] \.(text|data|bss|rodata)" | awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^\./) { print "  " $i, $(i + 4), $NF; break } }'
    done
done
for unit in sqlite stb; do
    if [ "$unit" = sqlite ]; then options=("${sqlite_options[@]}"); else options=("${stb_options[@]}"); fi
    for round in 1 2 3 4 5 6 7 8; do
        if [ $((round % 2)) -eq 1 ]; then order="$a $b"; else order="$b $a"; fi
        for tree in $order; do
            for run in 1 2 3; do
                perf stat -x, -o "$dir/perf-$unit.csv" -e instructions:u,cycles:u,task-clock taskset -c 2 "./$tree/build/compiler" "${options[@]}" -o "$dir/$unit-$tree-run.o" > /dev/null 2>&1
                status=$?
                grep -E 'instructions|cycles|task-clock' "$dir/perf-$unit.csv" | sed "s/^/round $round $tree run $run status $status,/" >> "$dir/measure-$unit.log"
            done
        done
    done
done
echo done
