#!/bin/bash
# head against base (measure-compile's Williams design, 41 runs each), sqlite3.c's default -c, one locked run; output kept.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
cd "$D/head" || exit 1
./build/compiler --version > /dev/null || exit 1
../base/build/compiler --version > /dev/null || exit 1
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_TITLE="#3577 direct path diagnostics: sqlite3.c A/B against main" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
~/buster-fast-bench/exclusive.sh timeout -k 5 560 taskset -c 2 ./build/compiler measure-compile --runs 41 --reference ../base/build/compiler -- \
    -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" > "$D/ab-$1.log" 2>&1
echo "status $?"
grep -vE "^run [0-9]+ " "$D/ab-$1.log"
