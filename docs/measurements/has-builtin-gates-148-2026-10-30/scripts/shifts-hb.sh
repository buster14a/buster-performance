#!/bin/bash
# #148's __has_builtin gates over the front end unit's placements (#509's method, docs/profiling.md): main d12fd583
# and 4c2b9fad, each linked with the unit shifted by six offsets across a page, run from three fresh copies, with
# main again as the floor; -E and -c of the frozen sqlite3.c; ab takes the lock per time-runs process.
cd ~/buster-fast-bench/solve-148-claude
export EXCLUSIVE_OWNER=claude-solve-148 EXCLUSIVE_TITLE="solve #137 #147 #148 (#148: __has_builtin gates placements)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148
shifts="0 704 1408 2112 2816 3520"
mkdir -p shifts
(cd main-d12fd583 && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ../hb-4c2b9fad/build.sh shifts ../shifts/main main_unit_frontend.c $shifts > ../shifts-main.log 2>&1); echo "shifts main: $?"
(cd hb-4c2b9fad && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh shifts ../shifts/hb main_unit_frontend.c $shifts > ../shifts-hb.log 2>&1); echo "shifts hb: $?"
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
O=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
builds=()
for b in main:main hb:hb main-again:main; do
    for s in $shifts; do builds+=(--build "${b%%:*}" "shifts/${b#*:}/compiler-$s"); done
done
mkdir -p copies
./hb-4c2b9fad/build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ./hb-4c2b9fad/build/compiler \
    -- time-runs --runs 3 --copies 3 --directory copies "${builds[@]}" --list -E "${O[@]}" -o /tmp/s148-sh.i --list -c "${O[@]}" -o /tmp/s148-sh.o > ab-shifts-hb.log 2>&1
echo "ab shifts: $?"
sha256sum shifts/main/compiler-* shifts/hb/compiler-* > shifts-sha256.txt
echo done
