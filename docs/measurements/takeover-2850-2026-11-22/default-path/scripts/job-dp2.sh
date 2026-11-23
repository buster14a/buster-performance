#!/bin/bash
# job-dp2.sh: the default path's one cut at its head (0db36d75e) against main (96fac43e0) on the 9700X: sqlite3.c seven
# rounds, then Lua, musl, the compiler's own source and sqlite3.c with -Wall -Wextra, five each. The reverted cuts' trees
# are removed first.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
for old in c24e2a52d e61c039fc 0e446262f; do [[ -d trees/$old ]] && git -C src worktree remove --force "$dir/trees/$old" && mv trees/$old.built trees/$old.built.stale; done
rev=0db36d75e
./setup.sh "$rev" || { echo "setup failed $rev"; exit 1; }
[[ -x trees/$rev/build/compiler && -x trees/96fac43e0/build/compiler ]] || { echo "no compiler"; exit 1; }
until awk '{exit !($1 < 2.0)}' /proc/loadavg; do sleep 10; done
pair()
{
    ./pair2.sh "$1" "$2" "$3" "$4" && python3 reduce2.py "results/pair2-$3-$1-$2" > "results/pair2-$3-$1-$2/summary.txt"
    echo "pair $3 $1 $2 done $(date -u +%H:%M:%S)"; sed -n 2,7p "results/pair2-$3-$1-$2/summary.txt"
}
pair 96fac43e0 "$rev" sqlite 7
pair 96fac43e0 "$rev" lua 5
pair 96fac43e0 "$rev" musl 5
pair 96fac43e0 "$rev" main 5
pair 96fac43e0 "$rev" sqlitewall 5
echo job-complete
