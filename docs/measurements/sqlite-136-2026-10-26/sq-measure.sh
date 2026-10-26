#!/bin/bash
# #136's SQLite measurements on the 9700X, pinned to CPU 2, under one hold of the lock (about a minute): sqlite3.c's
# compile time by this compiler, clang -O0 and tcc, 11 rounds in a rotating order; the objects' sizes; and SQLite's
# shell built from each one's objects of sqlite3.c and shell.c (linked by cc), running work.sql 7 times in a rotating
# order, each run's output compared with clang's.
set -u
B=~/buster-fast-bench/sqlite-136-claude
Q=~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
C=$B/build/compiler
mkdir -p $B/m && cd $B/m || exit 1
compile() {
    case $1 in
        ours) taskset -c 2 $C -c -I$Q -o $3 $2 ;;
        clang) taskset -c 2 clang -O0 -c -I$Q -o $3 $2 ;;
        tcc) taskset -c 2 tcc -c -I$Q -o $3 $2 ;;
    esac
}
compilers=(ours clang tcc)
# tcc's objects need its own runtime (libtcc1.a's __floatundidf) and have FDEs GNU ld refuses: tcc links its shell, and
# a shell that doesn't link isn't run.
runners=()
for c in "${compilers[@]}"; do
    compile $c $Q/sqlite3.c $c-sqlite3.o || { echo "$c failed on sqlite3.c"; exit 1; }
    compile $c $Q/shell.c $c-shell.o || { echo "$c failed on shell.c"; exit 1; }
    linker=cc
    [ $c = tcc ] && linker=tcc
    if $linker -o sq-$c $c-sqlite3.o $c-shell.o -lm -lpthread -ldl; then runners+=($c); else echo "$c's shell didn't link by $linker"; fi
done
: > compile.times
for r in $(seq 0 10); do
    for i in 0 1 2; do
        c=${compilers[$(( (r + i) % 3 ))]}
        s=$(date +%s%N); compile $c $Q/sqlite3.c $c-sqlite3.o; e=$(date +%s%N)
        echo "$c $(( (e - s) / 1000 ))" >> compile.times
    done
done
: > run.times
for r in $(seq 0 6); do
    for i in $(seq 0 $(( ${#runners[@]} - 1 ))); do
        c=${runners[$(( (r + i) % ${#runners[@]} ))]}
        s=$(date +%s%N); taskset -c 2 ./sq-$c :memory: < work.sql > out-$c.txt; e=$(date +%s%N)
        echo "$c $(( (e - s) / 1000 ))" >> run.times
        cmp -s out-$c.txt out-clang.txt 2>/dev/null || [ ! -e out-clang.txt ] || echo "$c's output differs from clang's"
    done
done
median() { sort -n | awk '{v[NR]=$1} END {printf "%d", v[int((NR+1)/2)]}'; }
for c in "${compilers[@]}"; do
    echo "$c: compile $(grep "^$c " compile.times | cut -d' ' -f2 | median) us (median of 11), shell run $(grep "^$c " run.times | cut -d' ' -f2 | median) us (median of 7)"
done
size ours-sqlite3.o clang-sqlite3.o tcc-sqlite3.o
md5sum out-*.txt
