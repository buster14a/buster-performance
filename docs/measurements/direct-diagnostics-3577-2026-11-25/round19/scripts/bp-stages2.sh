#!/bin/bash
# bp-stages2.sh: --time-stages of main (base) and the head (work), interleaved, 21 runs each, one hold.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path: stage times of main and head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D" || exit 1
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-s.o)
  for i in $(seq 21); do
    for t in base work; do
      taskset -c 2 ./$t/build/compiler --time-stages "${flags[@]}" 2>&1 | awk -F"\t" -v T=$t "\$1 == \"time-stage\" && (\$2 == \"preprocess\" || \$2 == \"tier0\" || \$2 == \"setup\" || \$2 == \"object-write\" || \$2 == \"total\") {print T, \$2, \$3}"
    done
  done
' x "$sqlite" > stages2.txt
for t in base work; do for s in setup preprocess tier0 object-write total; do
  awk -v T=$t -v S=$s '$1 == T && $2 == S {print $3}' stages2.txt | sort -g | awk -v T=$t -v S=$s '{a[NR]=$1} END {printf "%s %-13s median %.3f (n %d, %.3f to %.3f)\n", T, S, a[int((NR+1)/2)], NR, a[1], a[NR]}'
done; done
echo DONE
