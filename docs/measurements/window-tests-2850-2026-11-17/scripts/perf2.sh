#!/bin/bash
# perf2.sh LABEL: as perf.sh's cycles' run, with every symbol kept and the kernel's flush (where the window's tests are
# inlined) by instruction.
cd "$(dirname "$0")"
label=$1
. ./corpora.sh
out=$PWD/results/$label
data=/dev/shm/claude-2850-tests.perf.data
./lock.sh bash -c "perf record -q -e cycles:u -c 20011 -o $data -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --window-tests $sqlite_arguments > $out/perf2-run.txt 2>&1; echo status \$? >> $out/perf2-run.txt"
perf report -i $data --stdio --sort symbol 2>/dev/null | grep -v '^$' > $out/perf2-symbols.txt
perf annotate -i $data --stdio -s node_facts_reader_flush 2>/dev/null > $out/perf2-annotate-flush.txt
rm -f $data
wc -l $out/perf2-*.txt
