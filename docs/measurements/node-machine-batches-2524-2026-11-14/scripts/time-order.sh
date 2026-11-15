#!/bin/bash
# time-order.sh LABEL ORDER BATCH [SUFFIX]: as time-batch.sh, with BUSTER_NODE_SHADOW_ORDER=ORDER (order-b.patch's: 0, all
# three sweeps by batches; 1, T by batches, then C and X an expression at a time; 2, T and C an expression at a time, then
# X by batches); the files are time-o<ORDER>-b<BATCH>-<corpus><SUFFIX>.txt.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1
order=$2
batch=$3
suffix=${4-}
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
lua=$PWD/inputs/lua-5.4.8/src
export LC_ALL=C
./lock.sh bash -c "
head -1 /var/lib/buster-9700x/owner > '$out/time-holder-o$order-b$batch$suffix.txt'
BUSTER_NODE_SHADOW_ORDER=$order taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 --batch $batch -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/time-o$order-b$batch-sqlite3$suffix.txt' 2>&1; echo \"status \$?\" >> '$out/time-o$order-b$batch-sqlite3$suffix.txt'
BUSTER_NODE_SHADOW_ORDER=$order taskset -c 2 '$out/compiler' measure-node-machine --shadow --passes 11 --batch $batch '$lua'/*.c > '$out/time-o$order-b$batch-lua$suffix.txt' 2>&1; echo \"status \$?\" >> '$out/time-o$order-b$batch-lua$suffix.txt'
"
