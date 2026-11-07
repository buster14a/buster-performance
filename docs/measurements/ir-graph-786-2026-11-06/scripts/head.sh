#!/bin/bash
# 786-claude: the head tree, main plus head.patch, built at the campaign's placements under the 9700X's lock.
#   ./head.sh NAME BASE-REVISION < patch
set -euo pipefail
cd ~/buster-fast-bench/786-claude
export EXCLUSIVE_OWNER=claude-786 EXCLUSIVE_TITLE="Solve 786 (IR verifier/CFG/optimizer placements)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/786
name=$1 rev=$2
cat > "$name.patch"
if [ ! -d "$name" ]; then
    git -C repo.git worktree add -q --detach "../$name" "$rev"
fi
git -C "$name" checkout -q --detach -f "$rev"
git -C "$name" apply "../$name.patch"
git -C "$name" diff --stat | tail -1
(cd "$name" && ~/buster-fast-bench/exclusive.sh ./build.sh shifts "../shifts-$name" main_unit_backend.c ${SHIFTS:-0 640 1344 2048 2752 3456}) > "build-$name.log" 2>&1 || { echo "build $name failed"; tail -30 "build-$name.log"; exit 1; }
echo "head-done $name"
