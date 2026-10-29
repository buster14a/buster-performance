#!/usr/bin/env bash
# #775: where the head's extra instructions go. Each executable compiles each unit with -c under perf record, sampling
# every 10,007 user instructions, and each symbol's samples are compared between them. $1 and $2: the base's and the
# head's executables; $3: the frozen sqlite3.c's directory; $4: stb's directory (stb_image.h and stb_image.c).
set -uo pipefail
base="$1"
head="$2"
sqlite="$3"
stb="$4"
out="$(cd "$(dirname "$0")" && pwd)"
echo "cpu $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2-)"
echo "perf $(perf --version)"
sha256sum "$base" "$head" "$sqlite/sqlite3.c" "$stb/stb_image.h" "$stb/stb_image.c"
for unit in sqlite stb; do
    if [ "$unit" = sqlite ]; then
        options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
    else
        options=(-c -march=native "-I$stb" "$stb/stb_image.c")
    fi
    for tree in base head; do
        if [ "$tree" = base ]; then executable="$base"; else executable="$head"; fi
        perf record -q -e instructions:u -c 10007 -o "$out/$unit-$tree.data" taskset -c 2 "$executable" "${options[@]}" -o "$out/$unit-$tree.o" > /dev/null 2>&1
        echo "$unit $tree status $?"
        perf report -q -i "$out/$unit-$tree.data" --no-children --sort symbol -F sample,symbol --stdio 2>/dev/null | sed 's/^ *//' > "$out/$unit-$tree.symbols"
        perf stat -x, -e instructions:u -o "$out/$unit-$tree.stat" taskset -c 2 "$executable" "${options[@]}" -o "$out/$unit-$tree.o" > /dev/null 2>&1
        echo "$unit $tree instructions $(grep instructions "$out/$unit-$tree.stat" | cut -d, -f1)"
    done
    cmp "$out/$unit-base.o" "$out/$unit-head.o" && echo "$unit objects identical"
done
