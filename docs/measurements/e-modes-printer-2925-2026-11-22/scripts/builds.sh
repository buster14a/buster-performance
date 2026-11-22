#!/bin/bash
# Release builds of the two trees, each under the 9700X's lock alone (#2925's A/B).
set -u
D=~/buster-fast-bench/1380-claude-2925
export EXCLUSIVE_OWNER=claude-2925 EXCLUSIVE_TITLE='PR sweep: #2925 -E modes' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2925
for t in base head; do
    echo "== build $t $(git -C $D/$t rev-parse HEAD) $(date -u +%FT%TZ)"
    (cd $D/$t && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > $D/build-$t.log 2>&1)
    echo "build $t exit $? $(date -u +%FT%TZ)"
done
echo "builds done"
