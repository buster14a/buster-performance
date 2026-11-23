#!/bin/bash
# job-regress1.sh: where main's sqlite3.c reading rose between e9cbc3d72 and 89362fd0f. Six Release trees along the first
# parents, five pairs (7 rounds each, pair2.sh): #3296's merge against its parent, #3324's against its parent, and the
# three stretches between. The trees are removed at the end.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
revs="0367a836e c8234d2e8 0a08c8dd5 8e25d3b8d e9cbc3d72 89362fd0f"
for rev in $revs; do
    [[ -d trees/$rev ]] || { [[ -e trees/$rev.built ]] && mv trees/$rev.built trees/$rev.built.stale.$$; }
    ./setup.sh "$rev" || { echo "setup failed $rev"; exit 1; }
    [[ -x trees/$rev/build/compiler ]] || { echo "no compiler $rev"; exit 1; }
    echo "tree $rev ready $(date -u +%H:%M:%S), free: $(df -h /home | tail -1 | awk '{print $4}')"
done
until awk '{exit !($1 < 2.0)}' /proc/loadavg; do sleep 10; done
pair()
{
    ./pair2.sh "$1" "$2" sqlite 7 && python3 reduce2.py "results/pair2-sqlite-$1-$2" > "results/pair2-sqlite-$1-$2/summary.txt"
    echo "pair $1 $2 done $(date -u +%H:%M:%S)"; head -4 "results/pair2-sqlite-$1-$2/summary.txt"
}
pair 0367a836e c8234d2e8
pair 0a08c8dd5 8e25d3b8d
pair e9cbc3d72 0367a836e
pair c8234d2e8 0a08c8dd5
pair 8e25d3b8d 89362fd0f
for rev in $revs; do
    git -C src worktree remove --force "$dir/trees/$rev" && mv "trees/$rev.built" "trees/$rev.built.stale"
done
echo "free: $(df -h /home | tail -1 | awk '{print $4}')"
echo job-complete
