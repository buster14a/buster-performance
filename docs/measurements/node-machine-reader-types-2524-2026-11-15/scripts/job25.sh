#!/bin/bash
# job25.sh: where in the leaves' loop do u3's cycles go on sqlite3.c with a body a window (job23: node_facts_leaves 200
# against 232 M cycles over 160 passes, the same code at the same place in its line)? m14 and u3, facts-annotate.sh.
set -u
cd "$(dirname "$0")"
for label in m14 u3; do
    ./facts-annotate.sh $label body node_facts_leaves 160
done
for l in m14 u3; do echo "== $l"; for e in cycles ls_bad_status2.stli_other ls_dmnd_fills_from_sys.all ls_misal_loads.ma64 ex_ret_brn_misp; do printf "%-32s " $e; awk '$2 == "node_facts_leaves" { leaves = $1 } $2 ~ /^node_facts_/ { facts += $1 } { all += $1 } END { printf "leaves %.3f M  node_facts_* %.3f M  process %.3f M\n", leaves, facts, all }' results/$l/fa-body-$e-symbols.txt; done; done > results/facts-annotate-body-m14-u3.txt
echo "job25 done $(date -u +%FT%TZ)" >> results/job25.log
