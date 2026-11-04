#!/usr/bin/env bash
# equal15.sh: after #142's campaign at c5f4863a (queue14.sh), each of its programs compiled again by its recorded Tier 1
# command with c5f4863a's build and with b6d9570c's (equal15.py), one hold of the shared lock per chunk, pinned to CPU 2:
# equal15/diff-head-c5f4863a.tsv and equal15/diff-scalar-head-c5f4863a.tsv.
. ~/buster-fast-bench/claude-141-wide/common.sh
mkdir -p equal15
for d in diff-head-c5f4863a diff-scalar-head-c5f4863a; do
    rm -f equal15/$d.tsv
    for chunk in $d/chunk-*/; do
        "$lock" taskset -c 2 python3 $PWD/equal15.py $PWD/$chunk $PWD/equal15/$d.tsv
    done
done
touch equal15/done
