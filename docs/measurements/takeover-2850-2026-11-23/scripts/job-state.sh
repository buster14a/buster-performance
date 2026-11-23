#!/bin/bash
# job-state.sh REV NAME: main's state at REV: the ordinary Release build's stages and profile by symbol (prof2.sh), and the
# profile-guided build (BUSTER_PGO=1, its default training) paired against the ordinary one on the four workloads.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
rev=$1
name=$2
./setup.sh "$rev"
full=$(git -C src rev-parse "$rev")
short=${full:0:9}
tree=trees/$short-pgo
if [[ ! -d $tree ]]; then
    git -C src worktree add -q --detach "$PWD/$tree" "$full"
fi
export EXCLUSIVE_OWNER=claude-2850-01Egbx EXCLUSIVE_TITLE="#2850: build main $short with BUSTER_PGO=1" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
if [[ ! -x $tree/build/compiler ]]; then
    (cd $tree && BUSTER_PGO=1 "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --config Release --target compiler) > $tree-build.log 2>&1
    echo "pgo build exit $?"
fi
ls -la $tree/build/compiler | cut -c25-100
./prof2.sh "$name" "$short"
for w in sqlite main lua musl; do
    rounds=5
    [[ $w == sqlite ]] && rounds=7
    ./pair2.sh "$short" "$short-pgo" $w $rounds && python3 reduce2.py "results/pair2-$w-$short-$short-pgo" > "results/pair2-$w-$short-$short-pgo/summary.txt"
    cat "results/pair2-$w-$short-$short-pgo/summary.txt"
done
echo job-complete
