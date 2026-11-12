#!/bin/bash
# ab.sh: -c of the frozen sqlite3.c (the 9700X job's compile_time options) by main 2db047f3's compiler and by this
# step's (results/c3494a5f), whole processes in time-runs' Williams order, 21 runs each after 2 warm-ups, CPU 2, in one
# hold of the lock (each build of main's tree in a hold of its own).
set -u
cd "$(dirname "$0")"
out=$PWD/results/ab
mkdir -p "$out"
test -d main || git -C src worktree add -q --detach ../main 2db047f350d42c9c5428058a135ec0e1d7e164da
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd main && ./build.sh" > "$out/build-main.log" 2>&1
cp main/build/compiler "$out/compiler-main"
cp results/c3494a5f/compiler "$out/compiler-head"
sha256sum "$out/compiler-main" "$out/compiler-head" > "$out/compilers.txt"
ls -l "$out/compiler-main" "$out/compiler-head" >> "$out/compilers.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > '$out/holder.txt'; taskset -c 2 '$out/compiler-head' time-runs --runs 21 --warmups 2 --directory '$out/work' --build main '$out/compiler-main' --build head '$out/compiler-head' --list -c -o /dev/null -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I'$sqlite' '$sqlite/sqlite3.c' > '$out/time-runs.txt' 2>&1; echo \"status \$?\" >> '$out/time-runs.txt'"
date -u +%FT%TZ > "$out/.done"
