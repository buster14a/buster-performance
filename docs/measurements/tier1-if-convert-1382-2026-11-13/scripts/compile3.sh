#!/bin/bash
# sqlite3.c's --tier1 -c by each named tree's compiler (#1382): code size and shape, then time-runs' whole processes
# in one hold of the 9700X's lock, pinned to CPU 2. compile3.sh RUNS NAME=TREE...
set -u
cd "$(dirname "$0")"
runs=$1
shift
export EXCLUSIVE_OWNER=claude-1382 EXCLUSIVE_TITLE="#1382 Tier 1 if-conversion of nested, truth and reload regions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1382
sqlite=$PWD/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check || exit 1
options="--tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
builds=""
{
    echo "set -e"
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    for pair in "$@"; do
        name=${pair%%=*}
        tree=${pair#*=}
        builds="$builds --build $name $tree/build/compiler"
        echo "echo $name \$(cat $tree/COMMIT) \$(sha256sum < $tree/build/compiler | cut -c1-16)"
        echo "$tree/build/compiler $options --tier1-report -o sqlite-$name.o 2> report-$name.txt"
        echo "size -A sqlite-$name.o | awk '\$1 == \".text\" { print \"$name text \" \$2 }'"
        echo "objdump -d --no-show-raw-insn sqlite-$name.o > sqlite-$name.s"
        echo "printf '%s cmov %s jcc %s\\n' $name \$(grep -cP '\\tcmov' sqlite-$name.s) \$(grep -cP '\\tj(?!mp)[a-z]+ ' sqlite-$name.s)"
    done
} > shape.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash shape.sh > shape.txt 2>&1
last=${!#}
{
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    echo "echo \"== \$(cat /proc/loadavg)\" > compile-busy.txt"
    echo "ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> compile-busy.txt"
    echo "taskset -c 2 ${last#*=}/build/compiler time-runs --runs $runs $builds --list $options -o \$PWD/runs.o"
    echo "echo \"== after: \$(cat /proc/loadavg)\" >> compile-busy.txt"
} > time.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 500 bash time.sh > compile-time.txt 2>&1
echo done
