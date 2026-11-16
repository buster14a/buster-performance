#!/bin/bash
# backend.sh LABEL CORPUS RUNS: benchmark-backend-source on the corpus by results/LABEL/compiler, CPU 2, each run its own
# hold of the lock: the corpus's functions, entries, records and bytes, and every variant's medians an entry and a record.
# results/LABEL/backend-CORPUS-N.txt.
set -u
cd "$(dirname "$0")"
. ./corpora.sh
label=$1; name=$2; runs=$3
out=$PWD/results/$label
options=$(corpus_options "$name")
files=$(corpus_files "$name" | while read -r f; do printf '%q ' "$f"; done)
busy="ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg"
for ((n = 1; n <= runs; n += 1)); do
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; taskset -c 2 $out/compiler benchmark-backend-source $options $files | grep -v '^backend-source: \(configuration\|file=\)'; echo status \${PIPESTATUS[0]}; $busy" > "$out/backend-$name-$n.txt" 2>&1
done
echo done
