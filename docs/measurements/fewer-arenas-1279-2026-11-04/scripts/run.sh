#!/bin/sh
# The commands behind raw/, run on benchpress from ~/buster-fast-bench/652-658-claude, where base-1279 and head-1279
# are `git worktree`s of the two revisions in README.md, each built with
#   BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh
# and inputs/ holds empty.c (no bytes) and tiny.c ("int main(void){return 0;}\n").
B=$PWD/base-1279/build/cmake/znver5-g0/Release/compiler
H=$PWD/head-1279/build/cmake/znver5-g0/Release/compiler
s=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
cd inputs
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 300 --warmups 20 --copies 3 \
    --build main $B --build head $H --build main-again $B \
    --list -fsyntax-only empty.c --list -E -P empty.c -o /dev/null --list -c tiny.c -o /dev/null > ../ab-1279-small.txt 2>&1
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 15 --warmups 2 --copies 3 \
    --build main $B --build head $H --build main-again $B \
    --list -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$s $s/sqlite3.c \
    --list -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$s $s/sqlite3.c -o /dev/null > ../ab-1279-sqlite.txt 2>&1
