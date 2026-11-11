#!/bin/bash
# One time-runs per PR (its merge against its first parent), each under its own lock hold, pinned to CPU 2.
# Workloads: SQLite's amalgamation and main.c of the 2280 merge's tree (fixed input for every pair).
D=~/buster-fast-bench/1447-claude-d3
cd $D
export EXCLUSIVE_OWNER=claude-1447-d3
export EXCLUSIVE_TITLE="#1447 D3: C6b checker PRs, base vs head"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndQMcsMYmMXdjncrCg
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
S=$D/2280-head/src
sha256sum $sqlite $S/buster/compiler/main.c > inputs.sha256
clang --version | head -1 > host.txt; uname -a >> host.txt; lscpu | grep -E 'Model name|MHz' >> host.txt
while read pr merge; do
  ~/buster-fast-bench/exclusive.sh taskset -c 2 $D/$pr-head/build/compiler time-runs --runs 15 --warmups 2 \
    --build base $D/$pr-base/build/compiler --build head $D/$pr-head/build/compiler \
    --list -fsyntax-only $sqlite \
    --list -fsyntax-only -march=native -I$S -fwrapv -funsigned-char -fno-strict-aliasing -Wall $S/buster/compiler/main.c \
    > times-$pr.txt 2>&1
  echo "$pr exit $?"
done < prs.txt
echo RUN-DONE
