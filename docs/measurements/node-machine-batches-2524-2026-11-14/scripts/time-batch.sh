#!/bin/bash
# time-batch.sh LABEL BATCH [SUFFIX]: the shadow's sweeps timed on sqlite3.c and Lua 5.4.8 by results/LABEL's compiler
# (or results/LABEL/COPY's with COMPILER=COPY), 11 passes (each sweep set's least), --batch BATCH ("-": no option, for a
# compiler without it), CPU 2, one hold of the lock; the files are time-b<BATCH>-<corpus><SUFFIX>.txt.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
batch=$2
suffix=${3-}
compiler=$out/${COMPILER:-compiler}
option=$([ "$batch" = - ] && echo "" || echo "--batch $batch")
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$PWD/inputs/lua-5.4.8/src
export LC_ALL=C
./lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner > '$out/time-holder-b$batch$suffix.txt'
taskset -c 2 '$compiler' measure-node-machine --shadow --passes 11 $option -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/time-b$batch-sqlite3$suffix.txt' 2>&1; echo \"status \$?\" >> '$out/time-b$batch-sqlite3$suffix.txt'
taskset -c 2 '$compiler' measure-node-machine --shadow --passes 11 $option '$lua'/*.c > '$out/time-b$batch-lua$suffix.txt' 2>&1; echo \"status \$?\" >> '$out/time-b$batch-lua$suffix.txt'
"
