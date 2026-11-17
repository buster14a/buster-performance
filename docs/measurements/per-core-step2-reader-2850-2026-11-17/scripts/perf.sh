#!/bin/bash
# perf.sh LABEL: one run of the kernel at reader time on sqlite3.c under perf record (user cycles, a sample every 20,011),
# CPU 2, in one hold of the lock; then the batch's passes' function by instruction (results/LABEL/perf-batch.txt) and the
# run's symbols (perf-symbols.txt).
cd "$(dirname "$0")"
label=$1
. ./corpora.sh
out=$PWD/results/$label
data=/dev/shm/claude-2850-facts.perf.data
./lock.sh bash -c "perf record -q -e cycles:u -c 20011 -o $data -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --front-facts $sqlite_arguments > $out/perf-run.txt 2>&1; echo status \$? >> $out/perf-run.txt"
perf report -i $data --stdio --sort symbol 2>/dev/null | grep -v '^#' | grep -v '^$' | head -40 > $out/perf-symbols.txt
perf annotate -i $data --stdio -s node_facts_front_batch 2>/dev/null > $out/perf-batch.txt
rm -f $data
wc -l $out/perf-symbols.txt $out/perf-batch.txt
