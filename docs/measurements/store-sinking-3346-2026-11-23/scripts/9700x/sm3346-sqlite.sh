#!/bin/bash
# sqlite3.c with the pass and without it (the earlier run passed --no-default-config, which -c doesn't take): the
# report's store motion line for each, whether the objects differ, and 11 timed runs of each by time-runs, pinned to
# CPU 2; one hold of the lock for the reports and one for the timing.
W=/tmp/3346-claude
export EXCLUSIVE_OWNER=claude-3346 EXCLUSIVE_TITLE='buster #3346: loop store motion sinks stores (sqlite3 compile)' EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxnh2KB6UMiNcgm6mK5q
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
L=$HOME/buster-fast-bench/exclusive.sh
C=$W/tree/build/compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
driver="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include"
cd $W || exit 1
mkdir -p logs scratch
$L bash -c "echo receipt: \$(head -1 /var/lib/buster-9700x/owner) at \$(date -u +%FT%TZ); sha256sum $C
for v in off on; do opt=; [ \$v = on ] && opt=--tier1-passes=+storemotion
    $C --tier1 \$opt --tier1-report --lanes 1 -c -o scratch/sqlite3-\$v.o $driver $sqlite/sqlite3.c 2>&1 | grep -E 'store-motion|error' | sed \"s/^/report sqlite3 \$v /\"
done
cmp -s scratch/sqlite3-on.o scratch/sqlite3-off.o && echo 'sqlite3 objects identical' || echo 'sqlite3 objects differ'" > logs/sqlite3-reports.txt 2>&1
$L bash -c "echo receipt: \$(head -1 /var/lib/buster-9700x/owner) at \$(date -u +%FT%TZ); taskset -c 2 $C time-runs --runs 11 --warmups 1 --executable $C --list --tier1 --lanes 1 -c -o scratch/sqlite3-t.o $driver $sqlite/sqlite3.c --list --tier1 --tier1-passes=+storemotion --lanes 1 -c -o scratch/sqlite3-t.o $driver $sqlite/sqlite3.c" > logs/compile-sqlite3.txt 2>&1
echo "sqlite3 exit $? $(date -u +%FT%TZ)" >> logs/queue.txt
