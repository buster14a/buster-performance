#!/usr/bin/env bash
d=~/buster-fast-bench/2624-claude
until grep -q "^done" "$d/results2.tsv" 2>/dev/null; do sleep 30; done
SIDES=k5d300 ROUNDS=11 "$d/run3.sh"
