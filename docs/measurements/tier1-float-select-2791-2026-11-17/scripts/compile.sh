#!/bin/bash
# sqlite3.c's --tier1 -c by main's and the head's compilers: the object's shape, then time-runs' 11 runs in one hold,
# CPU 2, the object on tmpfs (/dev/shm); then benchmark-tier1-select-source of sqlite3.c by each, one hold each.
set -u
cd ~/buster-fast-bench/2791-claude/compile
export EXCLUSIVE_OWNER=claude-2791 EXCLUSIVE_TITLE="#2791 Tier 1: a select of a floating comparison is ucomis and cmovCC" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2791
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
flags="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite"
t=~/buster-fast-bench/2791-claude
sha256sum $sqlite/sqlite3.c > inputs.txt
{
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    for b in main head; do
        echo "$t/$b/build/compiler --tier1 -c $flags $sqlite/sqlite3.c -o /dev/shm/claude-2791-$b.o"
        echo "objdump -d --no-show-raw-insn /dev/shm/claude-2791-$b.o | awk -v b=$b '/^ +[0-9a-f]+:/ { n++; o = \$2; c[o]++ } END { printf \"%s records %d\", b, n; split(\"cmova cmovae cmovb cmovbe cmovp cmovne cmove sete setne setnp setp seta setae setb setbe ucomisd ucomiss test\", w, \" \"); for (i in w) printf \" %s=%d\", w[i], c[w[i]]; printf \"\\n\" }' >> shape.txt"
        echo "size -A /dev/shm/claude-2791-$b.o | awk -v b=$b '/^.text/ { print b, \".text\", \$2 }' >> shape.txt"
    done
    echo "rm -f /dev/shm/claude-2791-main.o /dev/shm/claude-2791-head.o"
} > shape.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash shape.sh > shape.log 2>&1
{
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    echo "echo \"== \$(cat /proc/loadavg)\" > busy.txt"
    echo "ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> busy.txt"
    echo "taskset -c 2 $t/head/build/compiler time-runs --runs 11 --build main $t/main/build/compiler --build head $t/head/build/compiler --list --tier1 -c $flags $sqlite/sqlite3.c -o /dev/shm/claude-2791-runs.o"
    echo "rm -f /dev/shm/claude-2791-runs.o"
    echo "echo \"== after \$(cat /proc/loadavg)\" >> busy.txt"
} > time.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash time.sh > compile-time.txt 2>&1
for round in 1 2; do
    for b in main head; do
        ~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; taskset -c 2 $t/$b/build/compiler benchmark-tier1-select-source $flags $sqlite/sqlite3.c" > select-$b-$round.txt 2>&1
    done
done
echo done > compile.done
