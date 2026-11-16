#!/bin/bash
# facts-where.sh LABEL: where the fact words' kernel's arrays and its stack are, at the first window's leaves, in
# results/LABEL/compiler on sqlite3.c (gdb, no address-space randomization, one hold of the lock).
# File results/LABEL/where.txt.
set -u
cd "$(dirname "$0")"
label=$1
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
out=$PWD/results/$label
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; gdb -q -batch -ex 'set pagination off' -ex 'break node_facts_leaves' -ex 'run' -ex 'info registers rdi rsi rdx rsp' -ex 'print *facts' -ex 'print facts' -ex 'bt 6' --args $out/compiler measure-node-machine --shadow --facts --passes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c 2>&1 | head -200" > $out/where.txt 2>&1
