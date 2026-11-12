#!/bin/bash
# setup.sh: the three trees (no lock: no build, no run): a blobless clone of buster, main
# from GitHub, step 1 and head from buster.bundle (the branch's two commits on main); a worktree of each, with its COMMIT.
set -eu
cd "$(dirname "$0")"
declare -A commits=([main]=33f3f442a1115ef969256ffef77c34af0c3799b9 [step1]=b46a8b1089c6e1cc047b3d4de86cf2268db2d157 [head]=c4b597eaa5b126d54cb9f972f6bfcc5db81f4bb6)
if [ ! -d repo ]; then
    git clone -q --no-checkout --filter=blob:none https://github.com/buster14a/buster.git repo
fi
git -C repo fetch -q origin "${commits[main]}"
git -C repo fetch -q ../buster.bundle "refs/heads/claude/zen-shannon-ch4f8b:refs/heads/measured"
for t in main step1 head; do
    rm -rf "$t"
    git -C repo worktree prune
    git -C repo worktree add -q --detach "../$t" "${commits[$t]}"
    { git -C "$t" rev-parse HEAD; git -C "$t" status --porcelain | wc -l; } > "$t/COMMIT"
    echo "$t $(head -1 "$t/COMMIT")"
done
