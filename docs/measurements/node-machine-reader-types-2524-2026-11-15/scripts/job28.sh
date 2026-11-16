#!/bin/bash
# job28.sh: is it the leaves' loop's code's place? m14 and u3 on sqlite3.c, a body a window, 160 passes: ops from the
# x86 decoder and from the op cache, op cache misses and instruction cache misses, by symbol and by the loop's
# instructions (facts-annotate.sh with its events given).
set -u
cd "$(dirname "$0")"
export EVENTS="de_src_op_disp.x:u:10007 de_src_op_disp.op_cache:u:100003 op_cache_hit_miss.op_cache_miss:u:1009 ic_tag_hit_miss.instruction_cache_miss:u:1009"
for label in m14 u3; do
    ./facts-annotate.sh $label front node_facts_leaves 160
done
for l in m14 u3; do echo "== $l"; for e in de_src_op_disp.x de_src_op_disp.op_cache op_cache_hit_miss.op_cache_miss ic_tag_hit_miss.instruction_cache_miss; do printf "%-44s " $e; awk '$2 == "node_facts_leaves" { leaves = $1 } $2 == "node_facts_window" { window = $1 } $2 ~ /^node_facts_/ { facts += $1 } { all += $1 } END { printf "leaves %.3f M  window %.3f M  node_facts_* %.3f M  process %.3f M\n", leaves, window, facts, all }' results/$l/fa-front-$e-symbols.txt; done; done > results/facts-annotate-front-m14-u3.txt
echo "job28 done $(date -u +%FT%TZ)" >> results/job28.log
