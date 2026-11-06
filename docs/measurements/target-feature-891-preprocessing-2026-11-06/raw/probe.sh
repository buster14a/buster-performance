#!/usr/bin/env bash
set -eu
workdir="$HOME/buster-fast-bench/891-codex-20261106-probe"
old="$HOME/buster-fast-bench/891-codex-20261105"
mkdir -p "$workdir"
cp "$HOME/buster-fast-bench/pr1310-ab-base-20261105/build/compiler" "$workdir/base"
cp "$old/head-original" "$workdir/head"
sha256sum "$workdir/base" "$workdir/head" > "$workdir/identities"
for count in 0 1000 10000; do
  awk -v n="$count" 'BEGIN {for (i=0; i<n; i++) printf "int probe_%d;\n", i}' > "$workdir/input-$count.c"
  sha256sum "$workdir/input-$count.c" >> "$workdir/identities"
  for revision in base head; do
    cp "$workdir/$revision" "$workdir/compiler"
    export EXCLUSIVE_OWNER=codex-891 EXCLUSIVE_TITLE="PR 1313 $revision preprocess $count" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1313
    "$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 perf stat -x, -e instructions:u -o "$workdir/$revision-$count.perf" -- "$workdir/compiler" -E "$workdir/input-$count.c" -o "$workdir/output" 2> "$workdir/$revision-$count.err"
    sha256sum "$workdir/output" >> "$workdir/outputs"
  done
done
