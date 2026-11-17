#!/bin/bash
# sqlite3.c's --tier1 -c (speedtest1's flags) by main's and head's compilers: the objects' shapes in one hold; time-runs'
# ROUNDS runs of both in one hold, its Williams order, CPU 2, the object on tmpfs; then benchmark-tier1-select-source of
# sqlite3.c by each, alternating, SELECTS runs each, a hold each, CPU 2. Usage: compile.sh ROUNDS SELECTS
set -u
dir=$(cd "$(dirname "$0")" && pwd)
B=$(dirname "$dir")
rounds=${1:-11}
selects=${2:-4}
out=$B/compile
mkdir -p $out
cd $out
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
flags="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite"
main=$B/main/build/compiler
head=$B/head/build/compiler
"$dir/lock.sh" compile-shape bash -c '
    printf "%s  %s\n" 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$4/sqlite3.c" | sha256sum --check
    for side in main head; do
        compiler=$1; [ $side = head ] && compiler=$2
        "$compiler" --tier1 --tier1-report -c $3 "$4/sqlite3.c" -o /dev/shm/claude-2843-$side.o 2> report-$side.txt
        objdump -d --no-show-raw-insn /dev/shm/claude-2843-$side.o > $side.s
        echo "shape $side text=$(size -A /dev/shm/claude-2843-$side.o | awk "\$1==\".text\"{print \$2}") instructions=$(grep -cP "^\s+[0-9a-f]+:\t" $side.s) register-moves=$(grep -cP "\tmov\s+%[a-z0-9]+,%[a-z0-9]+$" $side.s)"
        rm -f /dev/shm/claude-2843-$side.o
    done' _ $main $head "$flags" $sqlite > shape.txt 2>&1
"$dir/lock.sh" compile-time bash -c 'taskset -c 2 "$2" time-runs --runs '"$rounds"' --build main "$1" --build head "$2" --list --tier1 -c $3 "$4/sqlite3.c" -o /dev/shm/claude-2843-runs.o; status=$?; rm -f /dev/shm/claude-2843-runs.o; exit $status' _ $main $head "$flags" $sqlite > compile-time.txt 2>&1
for i in $(seq 1 $selects); do
    for side in head main; do
        compiler=$main; [ $side = head ] && compiler=$head
        "$dir/lock.sh" select-$side-$i bash -c 'taskset -c 2 "$1" benchmark-tier1-select-source $2 "$3/sqlite3.c"' _ $compiler "$flags" $sqlite > select-$side-$i.txt 2>&1
    done
done
