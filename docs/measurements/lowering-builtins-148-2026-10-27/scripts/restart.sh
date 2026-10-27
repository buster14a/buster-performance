#!/usr/bin/env bash
# restart.sh: rebuilds the head tree under the lock, then runs rounds.sh 6.
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=ld148-claude EXCLUSIVE_TITLE="#148 long double and __int128 builtins: main vs head" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/148"
( cd head && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh ) > build-head.log 2>&1 || { echo "build head failed"; exit 1; }
head/build/compiler -c -o drive-head.o ~/buster-fast-bench/refine-claude/inputs/sqlite3.c; echo "drive head status $?"
cmp drive-main.o drive-head.o && echo "drive objects identical"
./rounds.sh 6
