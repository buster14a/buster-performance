#!/usr/bin/env bash
set -eu
workdir="$HOME/buster-fast-bench/891-codex-20261106-probe"
input="$HOME/buster-fast-bench/891-codex-20261105/sqlite.i"
sha256sum "$input" >> "$workdir/identities"
for revision in base head; do
  cp "$workdir/$revision" "$workdir/compiler"
  export EXCLUSIVE_OWNER=codex-891 EXCLUSIVE_TITLE="PR 1313 $revision preprocessed SQLite control" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1313
  "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 perf stat -x, -e instructions:u -o "$workdir/$revision-sqlitei.perf" -- "$workdir/compiler" -E -x c "$input" -o "$workdir/output" 2> "$workdir/$revision-sqlitei.err"
  sha256sum "$workdir/output" >> "$workdir/outputs"
done
