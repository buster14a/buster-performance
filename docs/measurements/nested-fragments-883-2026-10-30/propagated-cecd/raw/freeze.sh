#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
set -euo pipefail
qual_root=/home/david/Documents/Codex/2026-10-30/tak/work/pr883-propagated-qualification
qual_worktree=/home/david/Documents/Codex/2026-10-30/tak/work/pr883-shared-handoff
qual_commit=${1:?actual committed integration SHA required}
[[ "$qual_commit" =~ ^[0-9a-f]{40}$ ]]
qual_tree=4558f8ae3a7260670a186df0871088b250df1a3f
qual_parents='b68c62de6f3a15eb70056835925979bc3079a433 ce1bea1eeb8ece6db744726875b136fba023d317'
test "$(git -C "$qual_worktree" rev-parse HEAD)" = "$qual_commit"
test "$(git -C "$qual_worktree" rev-parse "$qual_commit^{tree}")" = "$qual_tree"
test "$(git -C "$qual_worktree" show -s --format=%P "$qual_commit")" = "$qual_parents"
test -z "$(git -C "$qual_worktree" status --porcelain)"
test ! -e "$qual_root/commit.txt"
qual_roles=(ordinary-native ordinary-baseline address-native address-baseline thread-native)
for qual_role in "${qual_roles[@]}"; do
    test ! -e "$qual_root/snapshot-$qual_role"
    test ! -e "$qual_root/$qual_role"
done
printf '%s\n' "$qual_commit" > "$qual_root/commit.txt"
printf 'commit=%s\ntree=%s\nparents=%s\n' "$qual_commit" "$qual_tree" "$qual_parents" > "$qual_root/source.txt"
git -C "$qual_worktree" ls-tree -r --full-tree "$qual_commit" > "$qual_root/source-tree-manifest.txt"
for qual_role in "${qual_roles[@]}"; do
    mkdir "$qual_root/snapshot-$qual_role" "$qual_root/$qual_role"
    git -C "$qual_worktree" archive "$qual_commit" | tar -x -C "$qual_root/snapshot-$qual_role"
    (
        cd "$qual_root/snapshot-$qual_role"
        find . -type f -print0 | sort -z | xargs -0 sha256sum
    ) > "$qual_root/$qual_role/source.sha256"
    wc -l < "$qual_root/$qual_role/source.sha256" > "$qual_root/$qual_role/source-count.txt"
done
sha256sum "$qual_root/source.txt" "$qual_root/source-tree-manifest.txt" "$qual_root/freeze.sh" "$qual_root/run-one.sh" "$qual_root/with-cores.sh" > "$qual_root/frozen-controller.sha256"
