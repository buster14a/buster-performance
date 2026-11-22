#!/bin/bash
# #2925's fixed head: a tree of the branch's head with PATCH applied (NAME), its Develop build for the tests, then its
# Release build linked at the six placements, each build under the 9700X's lock alone.
set -u
D=~/buster-fast-bench/1380-claude-2925
NAME=${1:?usage: fix-builds.sh NAME PATCH}
PATCH=${2:?usage: fix-builds.sh NAME PATCH}
export EXCLUSIVE_OWNER=claude-2925 EXCLUSIVE_TITLE='PR sweep: #2925 -E modes' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2925
shifts=${SHIFTS:-"0 704 1408 2112 2816 3520"}
if [ ! -d $D/$NAME ]; then
    git clone -q --no-checkout $D/head $D/$NAME && git -C $D/$NAME checkout -q --detach 570138a079c3bdf428581d1a89742d08a7d49706 || exit 1
fi
git -C $D/$NAME checkout -q -- . && git -C $D/$NAME apply $PATCH || { echo "patch failed"; exit 1; }
git -C $D/$NAME diff --stat | tail -1
cd $D/$NAME
echo "== develop $NAME $(date -u +%FT%TZ)"
~/buster-fast-bench/exclusive.sh ./build.sh > $D/build-$NAME-develop.log 2>&1
echo "develop $NAME exit $? $(date -u +%FT%TZ)"
mkdir -p $D/shifts/$NAME
echo "== shifts $NAME $(date -u +%FT%TZ)"
~/buster-fast-bench/exclusive.sh ./build.sh shifts $D/shifts/$NAME main_unit_frontend.c $shifts > $D/shifts-$NAME.log 2>&1
echo "shifts $NAME exit $? $(date -u +%FT%TZ)"
echo "fix-builds done"
