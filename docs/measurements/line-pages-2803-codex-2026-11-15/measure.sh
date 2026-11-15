#!/bin/bash
set -eu
root="$HOME/buster-fast-bench/2803-codex-6af9ef"
variant="$1"
sqlite="$root/corpus/sqlite"
printf 'before\n'; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
printf 'revision '; git -C "$root/$variant" rev-parse HEAD
sha256sum "$sqlite/sqlite3.c"
cd "$root/$variant"
taskset -c 2 ./build/compiler measure-compile --runs 7 -- --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c"
printf 'after\n'; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
