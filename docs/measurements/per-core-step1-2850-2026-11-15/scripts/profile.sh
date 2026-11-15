#!/bin/bash
# profile.sh LABEL PASSES EVENT PERIOD [shadow options]: perf record of measure-node-machine --shadow --facts [options]
# --passes PASSES on sqlite3.c by results/LABEL/compiler (CPU 2, one hold of the lock); the symbols' shares in
# results/LABEL/profile-EVENT.txt (the kernel's functions' samples counted in its last lines).
set -u
cd "$(dirname "$0")"
label=$1; passes=$2; event=$3; period=$4
shift 4
options="$*"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
out=$PWD/results/$label
./lock.sh bash -c "taskset -c 2 perf record -q -e $event:u -c $period -o $out/perf-$event.data -- $out/compiler measure-node-machine --shadow --facts $options --passes $passes -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $out/profile-run-$event.txt 2>&1; echo status \$?" > $out/profile-$event.log 2>&1
perf report -q --stdio -i $out/perf-$event.data --sort symbol -n 2>/dev/null | grep -v '^$' | head -60 > $out/profile-$event.txt
grep 'node_facts\|memmove\|memset' $out/profile-$event.txt
grep 'node-facts: the kernel' $out/profile-run-$event.txt | cut -c1-200
