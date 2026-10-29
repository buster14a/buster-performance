#!/bin/bash
# Campaign B8 (#847): the final tree (TREE, one pair of lane constants) by its rule on up to 8 lanes, beside the claim
# tree with two pairs (PREVIOUS), main as #791's branch has it (MAIN) and #791's head (HEAD), on A2's twelve units of
# 48,640 tokens or more, whose lanes the pair changes, and four smaller ones, whose lanes it doesn't; five rounds, 8 jobs
# a lock hold, 30 s apart, into logs/B8.txt. Arguments: TREE PREVIOUS MAIN HEAD.
. ~/buster-fast-bench/claude-764/scripts/env.sh
tree="$1"
previous="$2"
main="$3"
head="$4"
: > "$D/scripts/b8.jobs"
for unit in 00204 h16x10 l16x19f192 d2x1f384s288 l16x38f192 d16x19f384s192 d16x19f384s288 l16x38f384 h2x480 x16x38 b16x77 h16x77 l16x77f384 x16x77 h16x154 sqlite; do
    passes=24
    if [ "$unit" = sqlite ]; then
        passes=12
    fi
    echo "$unit $passes $tree:8 $previous:8 $main:8 $head:8" >> "$D/scripts/b8.jobs"
done
"$D/scripts/queue847.sh" scripts/b8.jobs logs/B8.txt 1 0 5 8 30
echo "b8 done $(date -Is)" >> "$D/logs/chain.txt"
