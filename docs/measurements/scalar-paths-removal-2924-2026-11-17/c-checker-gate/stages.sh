#!/bin/bash
# #2924 C12c: which stage reads fewer cycles with the areas and the parser's root (bit 2) than with the areas alone?
# --time-stages, sqlite3.c -c --lanes 1, five runs each in turn, under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker's area gate, C12c" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
mkdir -p stages
A=$(( (1 << 29) - (1 << 10) ))
B=$(( A | 4 ))
out=/dev/shm/claude-2924-c12c-stages
rm -rf $out; mkdir -p $out
for i in 1 2 3 4 5; do
    for m in $A $B; do
        $L timeout -k 5 600 taskset -c 2 "$D/compilers/bisect/compiler-areas$m" -c --lanes 1 --time-stages "${S[@]}" -o $out/x.o > /dev/null 2> stages/m$m-$i.txt
    done
done
rm -rf $out
echo done >> stages/status.txt
