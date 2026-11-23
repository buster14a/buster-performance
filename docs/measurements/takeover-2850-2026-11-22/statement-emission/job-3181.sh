#!/bin/bash
# job-3181.sh: buster14a/buster#3181's merge (2e4eb0036) against its first parent (44a308708) on the 9700X: sqlite3.c seven
# rounds, the compiler's own source and musl five. The default path's trees are removed first; these two at the end.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
for old in 0db36d75e 96fac43e0; do [[ -d trees/$old ]] && git -C src worktree remove --force "$dir/trees/$old" && mv trees/$old.built trees/$old.built.stale; done
for rev in 44a308708 2e4eb0036; do
    ./setup.sh "$rev" || { echo "setup failed $rev"; exit 1; }
    [[ -x trees/$rev/build/compiler ]] || { echo "no compiler $rev"; exit 1; }
done
until awk '{exit !($1 < 2.0)}' /proc/loadavg; do sleep 10; done
pair()
{
    ./pair2.sh "$1" "$2" "$3" "$4" && python3 reduce2.py "results/pair2-$3-$1-$2" > "results/pair2-$3-$1-$2/summary.txt"
    echo "pair $3 $1 $2 done $(date -u +%H:%M:%S)"; sed -n 1,8p "results/pair2-$3-$1-$2/summary.txt"
}
pair 44a308708 2e4eb0036 sqlite 7
pair 44a308708 2e4eb0036 main 5
pair 44a308708 2e4eb0036 musl 5
echo job-complete
