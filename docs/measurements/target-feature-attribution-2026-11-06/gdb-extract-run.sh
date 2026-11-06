#!/usr/bin/env bash
set -euo pipefail
root="$HOME/buster-fast-bench/1313-extract-current-codex"
input="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
export EXCLUSIVE_OWNER=codex-1313-gdb EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1313
for role in base-compiler candidate; do
 export EXCLUSIVE_TITLE="PR 1313 extracted strlen slow-call count $role"
 "$HOME/buster-fast-bench/exclusive.sh" gdb --batch -x "$HOME/buster-fast-bench/1313-current-codex-scripts/strlen-count.gdb" --args "$root/$role/build/compiler" -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$input" "$input/sqlite3.c" > "$root/gdb-$role.log" 2>&1
done
