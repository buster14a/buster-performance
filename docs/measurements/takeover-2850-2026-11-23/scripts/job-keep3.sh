#!/bin/bash
# Kept pages with only the zero sites cleared (experiment-keep3.patch on f5d89b84, not for merge): one executable,
# BUSTER_EXPERIMENT_KEEP_PAGES 0 against 2 (and 0 against 1 on two workloads), the list of the 26 sites in both arms.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
git -C src fetch -q origin
BUSTER_BAKE=0 ./exp.sh keep3 f5d89b84 "$PWD/experiment-keep3.patch" Release
cp /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c inputs/sqlite3b.c
for w in twice musl lua mixed sqlite; do
    ./pair-env2.sh keep3 $w 5 BUSTER_EXPERIMENT_KEEP_PAGES 0 2
    cat results/pairenv2-$w-keep3-BUSTER_EXPERIMENT_KEEP_PAGES-0-2/summary.txt
done
for w in twice musl; do
    ./pair-env2.sh keep3 $w 5 BUSTER_EXPERIMENT_KEEP_PAGES 0 1
    cat results/pairenv2-$w-keep3-BUSTER_EXPERIMENT_KEEP_PAGES-0-1/summary.txt
done
echo job-complete
