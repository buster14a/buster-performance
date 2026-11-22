#!/usr/bin/env bash
# setup.sh: the clone, the PR head and its main (the main the head last merged), one worktree each.
set -euo pipefail
. "$HOME/buster-fast-bench/3022-claude/env.sh"
cd "$W"
if [ ! -d repo ]; then
    git clone -q --reference-if-able "$HOME/buster-fast-bench/3067-claude/repo" --dissociate https://github.com/buster14a/buster.git repo
fi
git -C repo fetch -q origin main codex/3022-folded-constant-storage
echo "origin/main $(git -C repo rev-parse origin/main)"
echo "origin/codex/3022-folded-constant-storage $(git -C repo rev-parse origin/codex/3022-folded-constant-storage)"
git -C repo cat-file -e "$HEAD^{commit}"
git -C repo cat-file -e "$BASE^{commit}"
echo "merge-base HEAD BASE: $(git -C repo merge-base "$HEAD" "$BASE")"
echo "merge-base HEAD origin/main: $(git -C repo merge-base "$HEAD" origin/main)"
echo "the head's merges on its first-parent line, newest first:"
git -C repo log --first-parent --merges -4 --format='  %H parents %P  %s' "$HEAD"
test "$(git -C repo merge-base "$HEAD" "$BASE")" = "$BASE"
for t in base head; do
    rev=$HEAD
    if [ "$t" = base ]; then rev=$BASE; fi
    if [ ! -d "$t" ]; then
        git -C repo worktree add -q --detach "../$t" "$rev"
    fi
    test "$(git -C "$t" rev-parse HEAD)" = "$rev"
    echo "$t $(git -C "$t" rev-parse HEAD)"
done
echo "$SQLITE_SHA256  $SQLITE/sqlite3.c" | sha256sum -c
git -C repo diff --stat "$BASE" "$HEAD" -- src
touch setup.done
