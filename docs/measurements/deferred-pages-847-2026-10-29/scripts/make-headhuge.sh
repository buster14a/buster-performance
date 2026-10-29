#!/bin/bash
# #847: a tree of head-95fc3668's source that gives the rare columns' arena huge pages at every reading (main's policy
# on #791's code), to measure what base pages cost a multi-lane reading. Builds it under the lock.
. ~/buster-fast-bench/claude-764/scripts/env.sh
src="$D/trees/head-95fc3668"
dst="$D/trees/headhuge-95fc3668"
rm -rf "$dst" && mkdir -p "$dst"
(cd "$src" && tar -cf - --exclude=./build .) | tar -C "$dst" -xf -
f="$dst/src/buster/compiler/c_check_input.c"
grep -c 'check_input_sparse_arena(sparse_bytes, sparse_small, input->rare_columns_shared)' "$f"
sed -i 's/check_input_sparse_arena(sparse_bytes, sparse_small, input->rare_columns_shared)/check_input_sparse_arena(sparse_bytes, sparse_small, false)/' "$f"
grep -c 'check_input_sparse_arena(sparse_bytes, sparse_small, false)' "$f"
echo "headhuge from head-95fc3668: the arena's huge pages at every reading" > "$dst/COMMIT.note"
cat "$src/COMMIT" > "$dst/COMMIT"
"$D/scripts/build.sh" headhuge-95fc3668
