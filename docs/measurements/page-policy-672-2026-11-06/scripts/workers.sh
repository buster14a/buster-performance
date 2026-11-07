#!/bin/bash
# usage: workers.sh LABEL COMPILER [ENV=VALUE...] -- 1/2/4/8 independent -c compiles pinned one per physical core, rounds
# rotating the worker counts; records wall per round and per-round vmstat deltas. Run under the lock.
cd ~/buster-fast-bench/672-claude
label=$1; C=$2; shift 2
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
d=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" --lanes 1)
out=results/$label; mkdir -p $out
vm() { awk '$1=="thp_fault_alloc"||$1=="pgalloc_normal"||$1=="pgfault" {printf "%s=%s ", $1, $2}' /proc/vmstat; }
for r in 1 2 3 4 5; do
  for n in 1 8 2 4; do
    a=$(vm); s=$(date +%s%N)
    for ((c = 0; c < n; c++)); do env "$@" taskset -c $c $C "${d[@]}" -o $out/w$c.o & done
    wait
    e=$(date +%s%N); b=$(vm)
    echo "round $r workers $n wall_ns $((e-s)) before $a after $b" >> $out/workers.txt
  done
done
for n in 1 8; do
  perf stat -a -x, -e task-clock,cycles:u,cycles:k,instructions:u -o $out/perf-w$n.csv -- bash -c 'for ((c = 0; c < '$n'; c++)); do env '"$*"' taskset -c $c '"$C"' '"$(printf '%q ' "${d[@]}")"' -o '"$out"'/w$c.o & done; wait'
done
sha256sum $out/w*.o > $out/workers-objects.sha256
echo done >> $out/workers.txt
