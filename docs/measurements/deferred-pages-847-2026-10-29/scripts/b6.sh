#!/bin/bash
# Campaign B6 (#847): A2's 43 units, five rounds, 11 jobs a lock hold, 30 s apart, into logs/B6.txt. Each job runs the
# tree (TREE, the first argument) by its rule on up to 8 lanes as it is, with no unit large (`huge`: the rare columns huge
# pages, faulted in before more than one lane) and with every unit large (`base`: base pages where more than one lane
# reads); main (MAIN) by its rule; and the tree on 8 lanes with every lane, huge and base, for the walks' spread.
# Arguments: TREE MAIN.
. ~/buster-fast-bench/claude-764/scripts/env.sh
tree="$1"
main="$2"
"$D/scripts/make-jobs.sh" "$D/scripts/b6.jobs" "$tree:8" "$tree:8:huge" "$tree:8:base" "$main:8" "$tree:8:every:huge" "$tree:8:every:base"
"$D/scripts/queue847.sh" scripts/b6.jobs logs/B6.txt 1 0 5 11 30
echo "b6 done $(date -Is)" >> "$D/logs/chain.txt"
