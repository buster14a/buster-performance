#!/bin/bash
# usage: build-head.sh COMMIT OUT
# Builds Buster at exactly COMMIT (a full SHA-1, fetched by itself, not a branch) in its own worktree, in one hold of the
# 9700X's lock, and copies the executable to OUT with its SHA-256 beside it. Fails without copying anything if the
# worktree isn't at COMMIT, the build fails, or the build didn't publish a new executable.
set -u
cd ~/buster-fast-bench/672-claude
commit=$1; out=$2
if ! [[ "$commit" =~ ^[0-9a-f]{40}$ ]]; then
    echo "build-head.sh: $commit is not a full commit" >&2
    exit 2
fi
git fetch -q origin "$commit" || exit 1
tree=head-$commit
[ -d "$tree" ] || git worktree add -q --detach "$tree" "$commit" || exit 1
(cd "$tree" && git checkout -q --detach "$commit") || exit 1
if [ "$(git -C "$tree" rev-parse HEAD)" != "$commit" ] || [ -n "$(git -C "$tree" status --porcelain)" ]; then
    echo "build-head.sh: $tree is not clean at $commit" >&2
    exit 1
fi
rm -f "$tree/build/compiler"
./lock.sh bash -c "cd '$tree' && ./build.sh" > "build-$commit.log" 2>&1
status=$?
if [ "$status" != 0 ] || [ ! -s "$tree/build/compiler" ]; then
    echo "build-head.sh: the build failed ($status) or published no executable" >&2
    exit 1
fi
cp "$tree/build/compiler" "$out" && sha256sum "$out" > "$out.sha256" && echo "$commit" > "$out.commit"
