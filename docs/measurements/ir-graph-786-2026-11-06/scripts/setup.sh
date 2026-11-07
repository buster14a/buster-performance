#!/bin/bash
# 786-claude: trees for #786's placements campaign. Clones old (9bb5060e) and main, builds each at six placements of
# main_unit_backend.c's code, each build under the 9700X's lock.
set -euo pipefail
cd ~/buster-fast-bench/786-claude
export EXCLUSIVE_OWNER=claude-786 EXCLUSIVE_TITLE="Solve 786 (IR verifier/CFG/optimizer placements)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/786
SHIFTS="0 640 1344 2048 2752 3456"
if [ ! -d repo.git ]; then
    git clone --bare -q https://github.com/buster14a/buster repo.git
fi
git -C repo.git fetch -q origin '+refs/heads/main:refs/heads/main'
for spec in "old 9bb5060e" "main $1"; do
    set -- $spec
    name=$1 rev=$2
    if [ ! -d "$name" ]; then
        git -C repo.git worktree add -q --detach "../$name" "$rev"
    fi
    git -C "$name" checkout -q --detach "$rev"
    echo "== $name $(git -C "$name" rev-parse HEAD)"
    (cd "$name" && ~/buster-fast-bench/exclusive.sh ./build.sh shifts "../shifts-$name" main_unit_backend.c $SHIFTS) > "build-$name.log" 2>&1 || { echo "build $name failed"; tail -30 "build-$name.log"; exit 1; }
done
echo setup-done
