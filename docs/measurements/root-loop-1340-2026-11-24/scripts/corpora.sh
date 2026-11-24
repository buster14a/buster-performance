#!/bin/bash
# Base against head over the corpora (sqlite3.c, Lua's and musl's units, the c-testsuite): each unit's object and stderr
# with three warning sets, both compilers run from this directory; then the head again with the test's switch
# (BUSTER_TEST_DEFAULT_PATH_LOG), which visits every root and counts the quiet ones whose visit acted, held to the head's
# stderr. Usage: corpora.sh BASE HEAD OUT
set -u
base=$1; head=$2; out=$3
C=/home/user/corpus; musl=$C/libc/musl
mkdir -p "$out"; cd "$out" || exit 1
rm -f differs.txt units.txt visits.log visits-*.log
sets=("" "-Wall -Wextra" "-Wunsequenced -Wunused-value -Wsign-compare -Wshift-overflow")
one() {
    local corpus=$1 file=$2; shift 2
    local s
    for s in 0 1 2; do
        # shellcheck disable=SC2086
        "$base" --lanes 1 -c "$@" ${sets[$s]} -o b.o "$file" 2> b.err; local bs=$?
        # shellcheck disable=SC2086
        "$head" --lanes 1 -c "$@" ${sets[$s]} -o h.o "$file" 2> h.err; local hs=$?
        # shellcheck disable=SC2086
        BUSTER_TEST_DEFAULT_PATH_LOG=$PWD/visits-$corpus.log "$head" --lanes 1 -c "$@" ${sets[$s]} -o v.o "$file" 2> v.err; local vs=$?
        local same=1
        [ $bs = $hs ] && [ $bs = $vs ] && cmp -s b.err h.err && cmp -s b.err v.err || same=0
        if [ $bs = 0 ]; then cmp -s b.o h.o && cmp -s b.o v.o || same=0; fi
        [ $same = 1 ] || echo "$corpus $file set $s: differs (status $bs $hs $vs)" >> differs.txt
        echo "$corpus $s $bs $(grep -c 'warning:' b.err)" >> units.txt
        rm -f b.o h.o v.o
    done
}
one sqlite $C/sqlite/sqlite3.c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite
for f in /home/user/lua/src/*.c; do one lua "$f" -I/home/user/lua/src; done
for f in /home/user/c-testsuite/tests/single-exec/*.c; do one c-testsuite "$f"; done
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    one musl "$f" -std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$C/musl-generated/obj/include" -I "$musl/include"
done
for corpus in sqlite lua c-testsuite musl; do
    awk -v c=$corpus '$1 == c { units[$2] += 1; ok[$2] += $3 == 0; warnings[$2] += $4 } END { for (s = 0; s < 3; s += 1) printf "%s set %d: %d compiles, %d accepted, %d warnings\n", c, s, units[s], ok[s], warnings[s] }' units.txt
    awk -F'[= ]' -v c=$corpus '/roots=/ { roots += $3; quiet += $5; acted += $7 } END { printf "%s with every root visited: %d roots, %d quiet, %d loud, %d quiet whose visit acted\n", c, roots, quiet, roots - quiet, acted }' visits-$corpus.log
done > summary.txt
[ -s differs.txt ] && echo "DIFFERENCES: $(wc -l < differs.txt)" >> summary.txt || echo "no difference in any object, status or stderr" >> summary.txt
cat summary.txt
