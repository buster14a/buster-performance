#!/bin/bash
# usage: fe-workers.sh LABEL COMPILER -- the front end alone (parse, -E) on 1 and 8 independent processes pinned one per
# physical core, with huge pages as the system has them (1) and base pages (0), rounds rotating. Run under the lock.
cd ~/buster-fast-bench/672-claude
label=$1; C=$2
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
d=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
out=results/$label; mkdir -p $out
for r in 1 2 3 4 5; do
  for cmd in parse E; do
    for hp in 1 0; do
      for n in 1 8; do
        s=$(date +%s%N)
        for ((c = 0; c < n; c++)); do
          if [ $cmd = parse ]; then BUSTER_HUGE_PAGES=$hp taskset -c $c $C parse "${d[@]}" > /dev/null & else BUSTER_HUGE_PAGES=$hp taskset -c $c $C -E "${d[@]}" -o $out/e$c.i & fi
        done
        wait
        e=$(date +%s%N)
        echo "round $r cmd $cmd hp $hp workers $n wall_ns $((e-s))" >> $out/fe-workers.txt
      done
    done
  done
done
echo done >> $out/fe-workers.txt
