#!/bin/bash
# build2.sh TREE...: each tree's Release build, under the 9700X's lock alone (#3261).
set -u
D=~/buster-fast-bench/3044-claude
export EXCLUSIVE_OWNER=claude-3261 EXCLUSIVE_TITLE='PR sweep: #3261 foreign strings cost' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3261
for t in "$@"; do
    echo "== build $t $(date -u +%FT%TZ)"
    (cd $D/$t && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > $D/build-$t.log 2>&1)
    echo "build $t exit $? $(date -u +%FT%TZ)"
done
echo "builds done"
