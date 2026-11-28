#!/bin/bash
# The scan alone on sqlite3.c: counters of 1 round and of 201, each under the lock.
cd /tmp/2850-fermat
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
E=cycles:u,instructions:u,branch-misses:u
./bp-run.sh "pass A" perf stat -x, -e $E -o a1.csv ./scan_test --time 1 $S > a1.out 2>&1
./bp-run.sh "pass A" perf stat -x, -e $E -o a201.csv ./scan_test --time 201 $S > a201.out 2>&1
touch a.done
