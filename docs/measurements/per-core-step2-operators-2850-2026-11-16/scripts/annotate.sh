#!/bin/bash
# annotate.sh LABEL NAME PASSES EVENT PERIOD SYMBOL [shadow options]: perf annotate of SYMBOL from a perf record of the
# kernel on sqlite3.c; results/LABEL/annotate-EVENT-NAME-SYMBOL.txt
set -u
cd "$(dirname "$0")"
label=$1; name=$2; passes=$3; event=$4; period=$5; symbol=$6
shift 6
options="$*"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
out=$PWD/results/$label
./lock.sh bash -c "taskset -c 2 perf record -q -e $event:u -c $period -o $out/perf-annotate.data -- $out/compiler measure-node-machine --shadow --facts $options --passes $passes -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > /dev/null 2>&1; echo status \$?" 2>&1 | tail -c 200
for s in ${symbol//,/ }; do
    perf annotate --stdio -i $out/perf-annotate.data -s $s --no-source 2>/dev/null | grep -v '^\s*$' > $out/annotate-$event-$name-$s.txt
    wc -l $out/annotate-$event-$name-$s.txt
done
rm -f $out/perf-annotate.data
