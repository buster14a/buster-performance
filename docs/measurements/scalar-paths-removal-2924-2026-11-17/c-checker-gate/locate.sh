#!/bin/bash
# #2924 C12c: which functions retire more instructions with the areas alone than with the areas and the roots?
# perf record of user instructions by symbol, sqlite3.c -c --lanes 1, three runs each at moving periods, under the lock.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker's area gate, C12c" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
mkdir -p locate
areas=$(( (1 << 29) - (1 << 10) ))
both=$(( areas | 252 ))
out=/dev/shm/claude-2924-c12c-locate
rm -rf $out; mkdir -p $out
for name in areas both; do
    mask=$areas; [ $name = both ] && mask=$both
    for i in 0 1 2; do
        $L timeout -k 5 600 taskset -c 2 perf record -q -e instructions:u -c $((50021 + 2 * i)) -o $out/$name-$i.data "$D/compilers/compiler-areas$mask" -c --lanes 1 "${S[@]}" -o $out/x.o > /dev/null 2>> locate/err.txt
        perf report -q -i $out/$name-$i.data --sort sym --stdio 2> /dev/null | head -400 > locate/$name-$i.txt
    done
done
rm -rf $out
echo done >> locate/status.txt
