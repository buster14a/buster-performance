#!/bin/bash
# #136's switch jump tables on the 9700X, pinned to CPU 2: sqlite3.c's -c, user instructions and cycles (perf stat
# -r 11, each its own hold of the lock), main's and the branch's in turn, two rounds; then SQLite's shell built from
# each one's -c objects of sqlite3.c and shell.c (linked by cc), running work.sql, main's and the branch's in turn,
# nine rounds, each round one hold of the lock, the outputs compared.
export EXCLUSIVE_OWNER=claude-switch-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
quiet() { grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:"; }
trees=(backend-136-main jump-136-claude)
for round in 1 2; do
    for d in "${trees[@]}"; do
        cd $B/$d || exit 1
        $X taskset -c 2 perf stat -r 11 -x, -e instructions:u,cycles:u ./build/compiler -c -I$Q -o $B/$d/sqlite3.o $Q/sqlite3.c > jt-perf-$round.log 2>&1
        echo "== $d -c perf round $round: $?"; quiet < jt-perf-$round.log | grep -E 'instructions|cycles'
    done
done
for d in "${trees[@]}"; do
    cd $B/$d || exit 1
    ./build/compiler -c -I$Q -o shell-sqlite3.o $Q/sqlite3.c && ./build/compiler -c -I$Q -o shell-shell.o $Q/shell.c && cc -o sq shell-sqlite3.o shell-shell.o -lm -lpthread -ldl || { echo "$d's shell didn't build"; exit 1; }
    size shell-sqlite3.o
done
cp $B/sqlite-136-claude/m/work.sql $B/jump-136-claude/work.sql
: > $B/jump-136-claude/run.times
for round in $(seq 1 9); do
    $X bash -c '
        B=~/buster-fast-bench
        for k in 0 1; do
            i=$(( ('$round' + k) % 2 ))
            d=$([ $i = 0 ] && echo backend-136-main || echo jump-136-claude)
            s=$(date +%s%N); taskset -c 2 $B/$d/sq :memory: < $B/jump-136-claude/work.sql > $B/$d/out.txt; e=$(date +%s%N)
            echo "$d $(( (e - s) / 1000 ))" >> $B/jump-136-claude/run.times
        done' 2>&1 | quiet
done
cmp $B/backend-136-main/out.txt $B/jump-136-claude/out.txt && echo "outputs: the same"
median() { sort -n | awk '{v[NR]=$1} END {printf "%d", v[int((NR+1)/2)]}'; }
for d in "${trees[@]}"; do
    echo "$d: shell run $(grep "^$d " $B/jump-136-claude/run.times | cut -d' ' -f2 | median) us (median of 9), all: $(grep "^$d " $B/jump-136-claude/run.times | cut -d' ' -f2 | sort -n | tr '\n' ' ')"
done
echo done
