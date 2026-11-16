#!/bin/bash
# profile.sh LABEL NAME PASSES EVENT PERIOD [shadow options]: perf record of measure-node-machine --shadow --facts
# [options] --passes PASSES on sqlite3.c by results/LABEL/compiler (CPU 2, one hold of the lock); the symbols' shares in
# results/LABEL/profile-EVENT-NAME.txt, the run's own lines in profile-run-EVENT-NAME.txt.
set -u
cd "$(dirname "$0")"
label=$1; name=$2; passes=$3; event=$4; period=$5
shift 5
options="$*"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
out=$PWD/results/$label
./lock.sh bash -c "taskset -c 2 perf record -q -e $event:u -c $period -o $out/perf-$event-$name.data -- $out/compiler measure-node-machine --shadow --facts $options --passes $passes -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $out/profile-run-$event-$name.txt 2>&1; echo status \$?" 2>&1 | tail -c 400 > $out/profile-$event-$name.log
perf report -q --stdio -i $out/perf-$event-$name.data --sort symbol -n 2>/dev/null | grep -v '^$' | head -120 > $out/profile-$event-$name.txt
rm -f $out/perf-$event-$name.data
grep -c . $out/profile-$event-$name.txt
