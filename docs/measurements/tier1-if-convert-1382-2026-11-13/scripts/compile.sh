#!/bin/bash
# sqlite3.c's --tier1 -c by main's and the head's compilers (#1382): code size and shape, then time-runs' whole
# processes in one hold of the 9700X's lock, pinned to CPU 2. compile.sh MAIN_TREE HEAD_TREE RUNS
set -u
cd "$(dirname "$0")"
main=$1
head=$2
runs=$3
export EXCLUSIVE_OWNER=claude-1382 EXCLUSIVE_TITLE="#1382 Tier 1 if-conversion of nested, truth and reload regions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1382
sqlite=$PWD/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
options=(--tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
cat > shape.sh <<SHAPE
set -e
head -1 /var/lib/buster-9700x/owner >> holds.txt
for b in main head; do
    tree=\$([ \$b = main ] && echo $main || echo $head)
    \$tree/build/compiler ${options[*]} --tier1-report -o sqlite-\$b.o 2> report-\$b.txt
    size -A sqlite-\$b.o | awk '\$1 == ".text" { print "'\$b' text " \$2 }'
    objdump -d --no-show-raw-insn sqlite-\$b.o > sqlite-\$b.s
    printf '%s cmov %s jcc %s\n' \$b \$(grep -cP '\tcmov' sqlite-\$b.s) \$(grep -cP '\tj(?!mp)[a-z]+ ' sqlite-\$b.s)
done
SHAPE
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash shape.sh > shape.txt 2>&1
cat > time.sh <<TIME
head -1 /var/lib/buster-9700x/owner >> holds.txt
echo "== \$(cat /proc/loadavg)" > compile-busy.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> compile-busy.txt
taskset -c 2 $head/build/compiler time-runs --runs $runs --build main $main/build/compiler --build head $head/build/compiler --list ${options[*]} -o \$PWD/runs.o
echo "== after: \$(cat /proc/loadavg)" >> compile-busy.txt
TIME
~/buster-fast-bench/exclusive.sh timeout -k 5 400 bash time.sh > compile-time.txt 2>&1
echo done
