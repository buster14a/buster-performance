#!/bin/bash
# Campaign B7 (#847): A2's 43 units, five rounds, 7 jobs a lock hold, 30 s apart, into logs/B7.txt. Each job runs the
# tree (TREE, the claims) by its rule on up to 8 lanes as it is, with no unit large (`huge`: the rare columns huge pages,
# each region claimed at the lanes' first write into it) and with every unit large (`base`: base pages where more than
# one lane reads); the fault-in tree (FAULT), main as the tree has it (MAIN) and #791's head (HEAD) by their rules; and
# the tree on 8 lanes with every lane, huge and base, for the walks' spread. Arguments: TREE FAULT MAIN HEAD.
. ~/buster-fast-bench/claude-764/scripts/env.sh
tree="$1"
fault="$2"
main="$3"
head="$4"
"$D/scripts/make-jobs.sh" "$D/scripts/b7.jobs" "$tree:8" "$tree:8:huge" "$tree:8:base" "$fault:8" "$main:8" "$head:8" "$tree:8:every:huge" "$tree:8:every:base"
"$D/scripts/queue847.sh" scripts/b7.jobs logs/B7.txt 1 0 5 7 30
echo "b7 done $(date -Is)" >> "$D/logs/chain.txt"
