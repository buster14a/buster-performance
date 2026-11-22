#!/bin/bash
# #2925's pushed head: the fix (fix4) merged with main, from a bundle; its Develop build and the tests (tests.sh), each
# under the 9700X's lock alone; then the DCO audit and AGENTS.md's size.
set -u
D=~/buster-fast-bench/1380-claude-2925
HEAD_SHA=${1:?usage: final.sh SHA}
export EXCLUSIVE_OWNER=claude-2925 EXCLUSIVE_TITLE='PR sweep: #2925 -E modes' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2925
[ -d $D/final ] || git clone -q --no-checkout $D/head $D/final
cd $D/final
git fetch -q $D/final.bundle "+refs/heads/*:refs/remotes/bundle/*" "+refs/remotes/origin/main:refs/remotes/bundle/main" 2>&1 | tail -2
git fetch -q $D/final.bundle HEAD 2>&1 | tail -2
git checkout -q --detach $HEAD_SHA && git log --oneline -1
echo "== develop final $(date -u +%FT%TZ)"
~/buster-fast-bench/exclusive.sh ./build.sh > $D/build-final-develop.log 2>&1
echo "develop final exit $? $(date -u +%FT%TZ)"
$D/tests.sh final
wc -c AGENTS.md CLAUDE.md
~/buster-fast-bench/exclusive.sh timeout -k 5 120 bash -c 'cc -std=c17 -O2 -o build/dco tools/dco/dco.c && build/dco audit --base bundle/main --head HEAD' > $D/dco-final.log 2>&1
echo "dco exit $?"
echo "final done"
