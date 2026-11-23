#!/bin/bash
# sqlite3.c -c, base and new alternating, 11 rounds, pinned to CPU 2, in one lock hold.
cd /tmp/1383-claude
export EXCLUSIVE_OWNER=claude-1383 EXCLUSIVE_TITLE="buster #1383: floating record members and short rows" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1383
printf 'input\tbinary\trun\tms\trss_kb\texit\n' > sqlite.tsv
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
    { echo "== sqlite interleaved before"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> load.log
    for run in $(seq 1 11); do
        for tree in base new; do
            taskset -c 2 ./measure $tree/build/compiler -c -o /tmp/1383-claude/objects/sqlite3.$tree.o inputs/sqlite3.c 2> m.tmp > /dev/null
            printf "sqlite3\t%s\t%s\t%s\n" $tree $run "$(tail -1 m.tmp | tr " " "\t")" >> sqlite.tsv
        done
    done
    { echo "== sqlite interleaved after"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> load.log
' 2>> lock.log
echo done > sqlite.status
