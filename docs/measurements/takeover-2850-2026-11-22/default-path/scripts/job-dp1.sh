#!/bin/bash
# job-dp1.sh: the default path's three cuts, each against its parent, on the 9700X. Four Release trees (main 96fac43e0,
# R1 0e446262f, R2 c24e2a52d, R3 e61c039fc); sqlite3.c seven rounds a step; then main against R3 on Lua, musl and the
# compiler's own source, and on sqlite3.c with -Wall -Wextra. The size cut's trees are removed first.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
for old in b0ee1afaa 0f7795acd; do [[ -d trees/$old ]] && git -C src worktree remove --force "$dir/trees/$old" && mv trees/$old.built trees/$old.built.stale; done
revs="96fac43e0 0e446262f c24e2a52d e61c039fc"
for rev in $revs; do
    ./setup.sh "$rev" || { echo "setup failed $rev"; exit 1; }
    [[ -x trees/$rev/build/compiler ]] || { echo "no compiler $rev"; exit 1; }
    echo "tree $rev ready $(date -u +%H:%M:%S), free: $(df -h /home | tail -1 | awk '{print $4}')"
done
until awk '{exit !($1 < 2.0)}' /proc/loadavg; do sleep 10; done
pair()
{
    ./pair2.sh "$1" "$2" "$3" "$4" && python3 reduce2.py "results/pair2-$3-$1-$2" > "results/pair2-$3-$1-$2/summary.txt"
    echo "pair $3 $1 $2 done $(date -u +%H:%M:%S)"; sed -n 2,6p "results/pair2-$3-$1-$2/summary.txt"
}
pair 96fac43e0 0e446262f sqlite 7
pair 0e446262f c24e2a52d sqlite 7
pair c24e2a52d e61c039fc sqlite 7
pair 96fac43e0 e61c039fc sqlite 7
pair 96fac43e0 e61c039fc lua 5
pair 96fac43e0 e61c039fc musl 5
pair 96fac43e0 e61c039fc main 5
pair 96fac43e0 e61c039fc sqlitewall 5
echo "free: $(df -h /home | tail -1 | awk '{print $4}')"
echo job-complete
