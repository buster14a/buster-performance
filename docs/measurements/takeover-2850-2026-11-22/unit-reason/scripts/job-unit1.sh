#!/bin/bash
# job-unit1.sh: the cut of a unit's fixed cost (b0ee1afaa) against #3367's head (4fcadeb45). The option against without on
# the compiler's own source (which takes no body) and on sqlite3.c with -Wall -Wextra (which takes none either), at both
# heads; then the option on the three workloads that take bodies; then the option off, head against head. Release,
# CPU 2, each run under the lock. A build that leaves no compiler stops the job.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
git -C src fetch -q origin
for old in 06681bbdb 89362fd0f; do [[ -d trees/$old ]] && git -C src worktree remove --force "$dir/trees/$old"; done
for rev in b0ee1afaa 4fcadeb45; do
    ./setup.sh $rev || { echo "setup failed: $rev"; exit 1; }
    [[ -x trees/$rev/build/compiler ]] || { echo "no compiler: $rev"; tail -3 trees/$rev-build.log; exit 1; }
done
df -h /home | tail -1
run() { ./pair2.sh "$@" && python3 reduce2.py "results/pair2-$3-$1-$2${5:+-$(printf '%s' "$5" | tr -c 'a-zA-Z0-9' '_')}" > "results/pair2-$3-$1-$2${5:+-$(printf '%s' "$5" | tr -c 'a-zA-Z0-9' '_')}/summary.txt"; }
run b0ee1afaa b0ee1afaa main 5 "--node-bodies"
run 4fcadeb45 4fcadeb45 sqlitewall 5 "--node-bodies"
run b0ee1afaa b0ee1afaa sqlitewall 5 "--node-bodies"
echo reasoned-complete
run b0ee1afaa b0ee1afaa sqlite 7 "--node-bodies"
run b0ee1afaa b0ee1afaa lua 5 "--node-bodies"
run b0ee1afaa b0ee1afaa musl 5 "--node-bodies"
echo option-complete
run 4fcadeb45 b0ee1afaa sqlite 7
run 4fcadeb45 b0ee1afaa main 5
run 4fcadeb45 b0ee1afaa lua 5
run 4fcadeb45 b0ee1afaa musl 5
echo job-complete
