#!/bin/bash
# buster#2381: main (its merge base) vs the PR's head, -fsyntax-only of sqlite3.c and main.c; one build per lock hold.
D=~/buster-fast-bench/1447-claude-d3
cd $D
export EXCLUSIVE_OWNER=claude-1447-d3
export EXCLUSIVE_TITLE="#1447 D3: #2381 enable_if overloads, base vs head"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2381
git -C repo fetch -q origin claude/overload-enable-if main
for t in pr-base:e43dfc1027368452a3e6b6c3f32e54faffae587a pr-head:935cfd18f79c9a373724e236d48f9ecd3f6e85a0; do
  n=${t%%:*}; r=${t#*:}
  [ -d $n ] || git -C repo worktree add -q --detach $D/$n $r
  [ -x $n/build/compiler ] || (cd $n && ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-$n.log 2>&1) || { echo "build $n failed"; exit 1; }
  echo "$n $(git -C $n rev-parse HEAD)"
done
sha256sum pr-*/build/compiler > pr-compilers.sha256
S=$D/pr-head/src
~/buster-fast-bench/exclusive.sh taskset -c 2 $D/pr-head/build/compiler time-runs --runs 15 --warmups 2 \
  --build base $D/pr-base/build/compiler --build head $D/pr-head/build/compiler \
  --list -fsyntax-only /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c \
  --list -fsyntax-only -march=native -I$S -fwrapv -funsigned-char -fno-strict-aliasing -Wall $S/buster/compiler/main.c > times-pr.txt 2>&1
echo "pr exit $?"
echo PR-DONE
