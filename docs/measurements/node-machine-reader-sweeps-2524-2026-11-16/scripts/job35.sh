#!/bin/bash
# job35.sh: the lean leaves' loop on Lua with a body a window, where job30 reads w2's lean kernel 8.9% over u3's with
# the same instructions: its events by u3 and by w2, 160 passes, twice each in turn.
set -u
cd "$(dirname "$0")"
for round in 1 2; do
    for label in u3 w2; do
        ./facts-annotate-lua.sh $label lean$round node_facts_leaves_lean 160 --facts-lean
    done
done
for l in u3 w2; do for r in 1 2; do echo "== $l round $r"; for e in cycles ic_tag_hit_miss.instruction_cache_miss op_cache_hit_miss.op_cache_miss ex_ret_brn_misp ls_bad_status2.stli_other; do printf "%-44s " $e; awk '$2 == "node_facts_leaves_lean" { leaves = $1 } $2 == "node_facts_window" { window = $1 } $2 ~ /^node_facts_/ { facts += $1 } { all += $1 } END { printf "leaves_lean %.3f M  window %.3f M  node_facts_* %.3f M  process %.3f M\n", leaves, window, facts, all }' results/$l/fl-lean$r-$e-symbols.txt; done; done; done > results/facts-annotate-lua-lean-u3-w2.txt
echo "job35 done $(date -u +%FT%TZ)" >> results/job35.log
