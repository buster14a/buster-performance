#!/bin/bash
# A profile fitted to the benchmark: BUSTER_PGO=1 with BUSTER_PGO_TRAIN compiling sqlite3.c as the timed compile does, against
# the ordinary Release build of the same sources (168c45a88) and against the default training, on the four workloads.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
tree=trees/168c45a88-pgosqlite
if [[ ! -d $tree ]]; then
    git -C src worktree add -q --detach "$PWD/$tree" 168c45a88
fi
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: build main with BUSTER_PGO=1 trained on sqlite3.c" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
(cd $tree && BUSTER_PGO=1 BUSTER_PGO_TRAIN="$HOME/buster-fast-bench/2850-claude-5a14/train-sqlite.sh" "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --config Release --target compiler) > $tree-build.log 2>&1
echo "pgo build exit $?"
ls -la $tree/build/compiler | cut -c25-100
sleep 20
for w in sqlite main lua musl; do
    ./pair2.sh 168c45a88 168c45a88-pgosqlite $w 7 && python3 reduce2.py results/pair2-$w-168c45a88-168c45a88-pgosqlite > results/pair2-$w-168c45a88-168c45a88-pgosqlite/summary.txt
done
./pair2.sh 168c45a88-pgo 168c45a88-pgosqlite sqlite 7 && python3 reduce2.py results/pair2-sqlite-168c45a88-pgo-168c45a88-pgosqlite > results/pair2-sqlite-168c45a88-pgo-168c45a88-pgosqlite/summary.txt
echo job-complete
