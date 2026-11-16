#!/bin/bash
# census.sh LABEL: measure-tier0-entries by results/LABEL/compiler on sqlite3.c, Lua and musl, each alone with its rows
# (--rows), and the three as one population (--next), CPU 2, each run its own hold of the lock. It is a count: nothing
# is timed. Its totals have the conditional branches by what their group takes and the sites where a compare's value
# is made and tested again, by why. results/LABEL/census-CORPUS.txt and census-all.txt.
set -u
cd "$(dirname "$0")"
. ./corpora.sh
label=$1
out=$PWD/results/$label
busy="ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg"
all=""
for name in sqlite3 lua musl; do
    options=$(corpus_options "$name")
    files=$(corpus_files "$name" | while read -r f; do printf '%q ' "$f"; done)
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; taskset -c 2 $out/compiler measure-tier0-entries --rows $options $files | grep -v '^tier0-census: file='; echo status \${PIPESTATUS[0]}; $busy" > "$out/census-$name.txt" 2>&1
    all="$all${all:+ --next }$options $files"
done
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; taskset -c 2 $out/compiler measure-tier0-entries --rows $all | grep -v '^tier0-census: file='; echo status \${PIPESTATUS[0]}; $busy" > "$out/census-all.txt" 2>&1
echo done
