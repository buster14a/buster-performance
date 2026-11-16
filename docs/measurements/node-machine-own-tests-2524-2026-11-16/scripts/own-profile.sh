#!/bin/bash
# own-profile.sh LABEL TAG [shadow options]: measure-node-machine --shadow [options] on sqlite3.c by
# results/LABEL/compiler on CPU 2, under perf record (cycles, user, a sample every 200,003 and more: a period the kernel
# keeps), five processes in one hold of the lock, their periods two apart; the samples by symbol and by source line:
# results/LABEL/op-TAG-symbols.txt and op-TAG-lines.txt (M cycles a process).
set -u
cd "$(dirname "$0")"
label=$1; tag=$2
shift 2
options="$*"
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
run="taskset -c 2 $out/compiler measure-node-machine --shadow $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-own-profile-$tag.txt"
for round in 1 2 3 4 5; do
    commands="$commands; perf record -q -o $out/op-$tag-$round.data -e cycles:u -c $((200003 + 2 * round)) -- $run > /dev/null 2>&1"
done
./lock.sh bash -c "$commands"
: > $out/op-$tag-symbols.txt; : > $out/op-$tag-lines.txt
for round in 1 2 3 4 5; do
    period=$((200003 + 2 * round))
    nice -n 19 perf report -i $out/op-$tag-$round.data --stdio --sort symbol -n 2>/dev/null | awk -v period=$period '/^ +[0-9.]+%/ { printf "%.6f %s\n", $2 * period / 5e6, $4 }' >> $out/op-$tag-symbols.txt
    nice -n 19 perf report -i $out/op-$tag-$round.data --stdio --sort srcline -n 2>/dev/null | awk -v period=$period '/^ +[0-9.]+%/ { printf "%.6f %s\n", $2 * period / 5e6, $3 }' >> $out/op-$tag-lines.txt
    rm -f $out/op-$tag-$round.data
done
echo "own-profile $label $tag done"
