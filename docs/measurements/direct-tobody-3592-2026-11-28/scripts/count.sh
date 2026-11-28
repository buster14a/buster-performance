#!/bin/bash
# count.sh NAME...: under the 9700X's lock, sqlite3.c's -c (CI's count flags, as bench.sh) by bin/compiler-NAME, perf stat
# -r 7 on CPU 2, the names in turn: user instructions, which repeat exactly, and the object's hash.
set -uo pipefail
here=$HOME/buster-fast-bench/3592-tobody-claude
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
tmp=$(mktemp -d /dev/shm/3592-tobody-claude/count.XXXXXX)
sflags=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
echo "== before"; cat /proc/loadavg
for n in "$@"; do
    echo "== sqlite3.c by $n"
    taskset -c 2 perf stat -r 7 -x ';' --no-big-num -e instructions:u,cycles:u,task-clock -- "$here/bin/compiler-$n" "${sflags[@]}" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" -c "$C/sqlite/sqlite3.c" -o "$tmp/s.o" 2>&1 | awk -F';' '{printf "%s %s (+-%s)\n", $3, $1, $4}'
    sha256sum < "$tmp/s.o" | cut -c1-16
done
echo "== after"; cat /proc/loadavg
rm -rf "$tmp"
