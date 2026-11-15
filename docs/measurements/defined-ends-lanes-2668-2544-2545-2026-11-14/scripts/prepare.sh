#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# prepare.sh: after both trees are built (base: buster14a/buster at $base; head: the same with head.patch, the PR's
# diff), the tools, the unit list (the whole-build record's selection: the first source of each base name, 1,336
# units), the output directories, and the shell's two objects by base's compiler, which every link line links. Run it
# under the lock (lock.sh ./prepare.sh).
set -eu
cd "$(dirname "$0")"
. ./common.sh
for tree in $trees; do
    (cd "$root/$tree" && git rev-parse HEAD > COMMIT && git diff > TREE.diff && sha256sum TREE.diff)
done
for tool in procbench medians spin; do
    clang -O2 -Wall -Wextra -Werror -o "tools/$tool" "tools/$tool.c"
done
rm -rf $t
mkdir -p $t/lists $t/cache $t/o $t/x
for tree in $trees; do mkdir -p $t/m/$tree $t/x/$tree; done
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
printf '%s\n' "${files[@]}" > $t/lists/units1336.txt
wc -l < $t/lists/units1336.txt
c=$root/base/build/compiler
(cd $t/x && taskset -c 2 $c -c $sh $sqlite/shell.c -o shell.o && taskset -c 2 $c -c $sh $sqlite/sqlite3.c -o sq.o)
ls -l $t/x/shell.o $t/x/sq.o
