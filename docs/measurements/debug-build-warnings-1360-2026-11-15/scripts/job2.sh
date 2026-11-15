#!/bin/bash
# job2.sh: the head tree at 964eb8c (main 2ebfe68a + its diff) built as main was, then the A/B (measure.sh), 7 rounds.
set -u
cd ~/buster-fast-bench/1360-claude || exit 2
./build-head.sh 964eb8c1 head-964eb8c.patch || exit 1
ROUNDS=7 OUT=ab-964eb8c ./measure.sh > ab-964eb8c.log 2>&1
./summarize.sh ab-964eb8c/results.tsv > ab-964eb8c/summary.md
echo done > job2.done
