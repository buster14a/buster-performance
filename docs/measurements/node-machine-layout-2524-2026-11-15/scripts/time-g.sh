#!/bin/bash
# time-g.sh SUFFIX LABEL:BATCH...: time-batch.sh's runs (sqlite3.c and Lua, 11 passes, CPU 2) for each LABEL at BATCH
# ("-": no option), all in one hold of the lock, in the order given; the files are results/LABEL/time-b<BATCH>-<corpus>SUFFIX.txt.
set -u
cd "$(dirname "$0")"
suffix=$1
shift
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$PWD/inputs/lua-5.4.8/src
export LC_ALL=C
commands="head -1 /var/lib/buster-9700x/owner >> $PWD/results/holds-time$suffix.txt"
for pair in "$@"; do
    label=${pair%%:*}
    batch=${pair#*:}
    out=$PWD/results/$label
    option=$([ "$batch" = - ] && echo "" || echo "--batch $batch")
    f=$out/time-b$batch-sqlite3$suffix.txt
    commands="$commands; taskset -c 2 $out/compiler measure-node-machine --shadow --passes 11 $option -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $f 2>&1; echo status \$? >> $f"
    f=$out/time-b$batch-lua$suffix.txt
    commands="$commands; taskset -c 2 $out/compiler measure-node-machine --shadow --passes 11 $option $lua/*.c > $f 2>&1; echo status \$? >> $f"
done
./lock.sh bash -c "$commands"
