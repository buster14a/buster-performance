#!/bin/bash
# perf3.sh LABEL: the window's tests at reader time on sqlite3.c under perf record, CPU 2, one hold of the lock: user
# cycles, a sample every 2,003, and the kernel's flush (where the window's tests are inlined) by instruction with its
# source lines.
cd "$(dirname "$0")"
label=$1
. ./corpora.sh
out=$PWD/results/$label
data=/dev/shm/claude-2850-tests.perf.data
./lock.sh bash -c "perf record -q -e cycles:u -c 2003 -o $data -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-tests $sqlite_arguments > $out/perf3-run.txt 2>&1; echo status \$? >> $out/perf3-run.txt"
perf report -i $data --stdio --sort symbol 2>/dev/null | grep -v '^$' | head -80 > $out/perf3-symbols.txt
perf annotate -i $data --stdio -l -s node_facts_reader_flush 2>/dev/null > $out/perf3-annotate-flush.txt
rm -f $data
wc -l $out/perf3-*.txt
echo perf3 done
