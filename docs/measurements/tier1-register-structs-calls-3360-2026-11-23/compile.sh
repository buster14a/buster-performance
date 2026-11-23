#!/bin/bash
# Compile time of sqlite3.c by base and fix with --tier1 (ab: Williams order, lock per run, CPU 2).
set -uo pipefail
D=~/buster-fast-bench/3360-claude; cd $D; . ./env.sh
fix/build/compiler ab --rounds 11 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh base fix -- --tier1 -c sqlite3.c -o /tmp/3360-sqlite3.o > ab-sqlite.txt 2>&1
echo "ab exit $?" >> compile.status
for t in base fix; do $t/build/compiler --tier1 --time-stages -c sqlite3.c -o /tmp/3360-$t.o 2> stages-$t.txt; done
echo done >> compile.status
