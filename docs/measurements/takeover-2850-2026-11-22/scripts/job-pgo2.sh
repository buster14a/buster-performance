#!/bin/bash
# The profile-guided build with its training fixed (168c45a88): main's sources, BUSTER_PGO=1 with the default training, against
# the ordinary Release build of the same sources, on the four workloads.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh 168c45a88
git -C src fetch -q origin
tree=trees/168c45a88-pgo
if [[ ! -d $tree ]]; then
    git -C src worktree add -q --detach "$PWD/$tree" 168c45a88
fi
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: build main with BUSTER_PGO=1" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
(cd $tree && BUSTER_PGO=1 "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --config Release --target compiler) > $tree-build.log 2>&1
echo "pgo build exit $?"
ls -la $tree/build/compiler | cut -c25-100
sleep 20
for w in sqlite main lua musl; do
    ./pair2.sh 168c45a88 168c45a88-pgo $w 7 && python3 reduce2.py results/pair2-$w-168c45a88-168c45a88-pgo > results/pair2-$w-168c45a88-168c45a88-pgo/summary.txt
done
echo job-complete
