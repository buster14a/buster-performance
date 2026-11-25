#!/bin/bash
# counters.sh ROUNDS NAME...: perf stat of bin/compiler-NAME's -c of sqlite3.c on CPU 2, ROUNDS runs each, the
# variants rotated a run at a time; branch and front-end counters for #3592's step 6d.
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
rounds=$1; shift
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
unit=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include"
      -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
tmp=$(mktemp -d /dev/shm/ct-np4nn5.XXXXXX)
ev=cycles:u,instructions:u,branches:u,branch-misses:u,L1-icache-load-misses:u,L1-dcache-load-misses:u,stalled-cycles-frontend:u
for ((r = 0; r < rounds; r++)); do
  for n in "$@"; do
    taskset -c 2 perf stat -x, -e "$ev" -o "$tmp/$n.$r.csv" "$here/bin/compiler-$n" "${unit[@]}" -o "$tmp/out.o" > /dev/null 2>&1
  done
done
for n in "$@"; do
  echo "== $n"
  cat "$tmp"/$n.*.csv | awk -F, '$3 ~ /:u$|^[a-zA-Z]/ && $1 ~ /^[0-9]/ {v[$3] = v[$3] " " $1} END {for (k in v) print k, v[k]}' | while read k vals; do
    echo "$k $(echo $vals | tr ' ' '\n' | sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}')"
  done | sort
done
rm -rf "$tmp"
