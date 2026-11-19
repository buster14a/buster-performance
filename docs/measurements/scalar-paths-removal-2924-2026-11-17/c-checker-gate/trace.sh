#!/bin/bash
# #2924 C12c: which functions run with the areas alone and not with the areas and the parser's root (bit 2), or the
# other way? start-trace of sqlite3.c -c --lanes 1 by each, under the lock.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker's area gate, C12c" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
mkdir -p trace
A=$(( (1 << 29) - (1 << 10) ))
out=/dev/shm/claude-2924-c12c-trace
rm -rf $out; mkdir -p $out
for m in $A $(( A | 4 )) $(( A | 16 )); do
    [ -e compilers/bisect/compiler-areas$m ] || cp compilers/compiler-areas0 compilers/bisect/compiler-areas$m
    rm -f trace/m$m.txt
    $L timeout -k 5 1200 "$D/compilers/main" start-trace trace/m$m.txt "$D/compilers/bisect/compiler-areas$m" -c --lanes 1 "${S[@]}" -o $out/x.o > /dev/null 2> trace/m$m.err
done
readelf -sW compilers/compiler-areas0 > trace/symbols.txt
rm -rf $out
echo done >> trace/status.txt
