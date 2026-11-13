#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# prepare.sh: the three trees at main (buster14a/buster 26f0bb0e): main itself; head, main with this change
# (head.patch, the PR's diff); nocheck, main without -Wreserved-macro-identifier's two calls (nocheck.patch): what the
# directives cost before #2530 added them. Then the tools, the unit list (the whole-build record's selection: the
# first source of each base name, 1,336 units) and the output directories. Run it under the lock (lock.sh ./prepare.sh).
set -eu
cd "$(dirname "$0")"
. ./common.sh
(cd "$root/repo" && git fetch -q origin main && git cat-file -e "$base^{commit}")
for tree in $trees; do
    if [[ ! -d $root/$tree ]]; then (cd "$root/repo" && git worktree add -q --detach "$root/$tree" "$base"); fi
done
(cd "$root/head" && git apply "$here/head.patch")
(cd "$root/nocheck" && git apply "$here/nocheck.patch")
for tree in $trees; do
    (cd "$root/$tree" && git rev-parse HEAD > COMMIT && git diff > TREE.diff && sha256sum TREE.diff)
done
for tool in procbench medians; do
    clang -O2 -Wall -Wextra -Werror -o "tools/$tool" "tools/$tool.c"
done
rm -rf $t
mkdir -p $t/lists $t/cache $t/o
for tree in $trees; do mkdir -p $t/m/$tree; done
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
printf '%s\n' "${files[@]}" > $t/lists/units1336.txt
wc -l < $t/lists/units1336.txt
