#!/bin/bash
# facts-pad.sh LABEL TAG PAD [shadow options]: measure-node-machine --shadow --facts [options] on sqlite3.c by
# results/LABEL/compiler, CPU 2, one hold of the lock, with no address-space randomization (setarch -R) and an
# environment variable of PAD bytes, which moves the stack down by as much. File results/LABEL/pad-TAG-PAD.txt.
set -u
cd "$(dirname "$0")"
label=$1; tag=$2; pad=$3
shift 3
options="$*"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
out=$PWD/results/$label
filler=$(head -c $pad /dev/zero | tr '\0' x)
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; BUSTER_STACK_PAD=$filler setarch x86_64 -R taskset -c 2 $out/compiler measure-node-machine --shadow --facts $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c; echo status \$?" > $out/pad-$tag-$pad.txt 2>&1
