#!/bin/bash
# own-annotate.sh LABEL TAG SYMBOL [shadow options]: one perf record (cycles, user, period 100,003) of
# measure-node-machine --shadow [options] on sqlite3.c by results/LABEL/compiler on CPU 2 under the lock, then SYMBOL's
# instructions with their samples and source lines: results/LABEL/oa-TAG.txt (the lines with 0.15% of the symbol or more,
# each with the ten instructions before it for its place).
set -u
cd "$(dirname "$0")"
label=$1; tag=$2; symbol=$3
shift 3
options="$*"
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
run="taskset -c 2 $out/compiler measure-node-machine --shadow $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200 > /dev/null; for i in 1 2 3; do perf record -q -o $out/oa-$tag-\$i.data -e cycles:u -c \$((100003 + 2 * i)) -- $run > /dev/null 2>&1; done"
nice -n 19 perf annotate -i $out/oa-$tag-1.data --stdio -l --symbol=$symbol 2>/dev/null > $out/oa-$tag-full.txt
grep -c '' $out/oa-$tag-full.txt
awk '{ line[NR] = $0 } $1 + 0 >= 0.15 && $1 ~ /^[0-9.]+$/ { hot[NR] = 1 } END { for (i = 1; i <= NR; i++) if (hot[i]) { for (j = i - 3; j <= i; j++) if (j > 0 && !printed[j]) { print line[j]; printed[j] = 1 } } }' $out/oa-$tag-full.txt > $out/oa-$tag.txt
rm -f $out/oa-$tag-2.data $out/oa-$tag-3.data $out/oa-$tag-1.data
echo "own-annotate $label $tag done" >> results/job45.log
