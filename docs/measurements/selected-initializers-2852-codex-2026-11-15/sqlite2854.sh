#!/bin/bash
set -eu
root="$HOME/buster-fast-bench/2803-codex-6af9ef"
sqlite="$root/corpus/sqlite"
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
for v in base pr2854 clang; do
    if [ "$v" = clang ]; then cc="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin/clang"; else cc="$root/$v/build/cmake/znver5/Release/compiler"; fi
    taskset -c 2 "$cc" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c" -o "$root/data-comparison/sqlite-$v.o"
    printf '%s\n' "$v"
    size -A "$root/data-comparison/sqlite-$v.o" | awk '$1 ~ /^\.(rodata|data|bss)/ {print}'
done
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
