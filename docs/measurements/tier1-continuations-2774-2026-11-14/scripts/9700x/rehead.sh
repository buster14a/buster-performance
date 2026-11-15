#!/usr/bin/env bash
# 2774: head moved to the branch's second commit; its compiler rebuilt (one hold of the lock), base's kept.
set -u
W=$HOME/buster-fast-bench/2774-claude
export EXCLUSIVE_OWNER=claude-2774 EXCLUSIVE_TITLE="Tier 1 allocation: evict a value that continues in its slot first (#2774)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2774
L=$HOME/buster-fast-bench/exclusive.sh
HEAD=${HEAD_SHA:?}
log() { echo "$(date -u +%FT%TZ) $*" >> $W/build.log; }
cd $W || exit 1
git -C head fetch -q https://github.com/buster14a/buster.git claude/sleepy-albattani-6yj7xf && git -C head checkout -q $HEAD || exit 1
echo "base $(git -C base rev-parse HEAD) head $(git -C head rev-parse HEAD)" > revisions.txt
log "head compiler at $(git -C head rev-parse HEAD), status lines $(git -C head status --short | wc -l)"
$L bash -c "cd $W/head && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-head-compiler.log 2>&1"
log "head compiler exit $? sha256 $(sha256sum $W/head/build/compiler | cut -d' ' -f1)"
cp $W/head/build/compiler $W/compilers/head && rm -rf $W/head/build
