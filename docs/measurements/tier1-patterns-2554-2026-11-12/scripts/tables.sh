#!/bin/bash
# tables.sh: the record's tables from 9700x/results and callgrind/: the timed runs against main and each step's base
# (tools/proto_table.py), compile time (tools/compile_table.py) and the patterns' counts.
set -eu
cd "$(dirname "$0")/.."
mkdir -p tables
for base in main identity store dispatch; do echo "### against $base"; python3 scripts/tools/proto_table.py 9700x/results/runs.tsv "$base"; echo; done > tables/runs.txt
{
    echo "### the final head (head2) against main"; python3 scripts/tools/compile_table.py 9700x/results/compile.tsv main head2
    echo "### the head before the escape scan's vector path against main"; python3 scripts/tools/compile_table.py 9700x/results/compile-head.tsv main head
} > tables/compile.txt
for n in main identity store dispatch head; do
    for p in speedtest1 lua; do echo "### $n $p (untagged)"; cat "callgrind/$n/$p.patterns"; echo; done
    for p in speedtest1 lua; do [ -e "callgrind/$n/$p-tagged.patterns" ] && { echo "### $n $p (tagged)"; cat "callgrind/$n/$p-tagged.patterns"; echo; }; done
done > tables/patterns.txt
