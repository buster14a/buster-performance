#!/usr/bin/env bash
# 2553 runtime (from #1216's record), step 1: the compilers. base is main at afcb185e, h7 the branch's 09c20559 and h11 h7
# with h11.patch; each built by its own build.sh with BUSTER_HOST_ARCH=znver5, each build one hold of the lock.
set -u
W=$HOME/buster-fast-bench/2553-claude
export EXCLUSIVE_OWNER=claude-2553 EXCLUSIVE_TITLE="Tier 1: values keep their registers along dominators (#2553)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2553
L=$HOME/buster-fast-bench/exclusive.sh
REVS=${REVS:-base h7 h11}
log() { echo "$(date -u +%FT%TZ) $*" >> $W/build.log; }
for t in $REVS; do
    log "$t compiler at $(git -C $W/$t rev-parse HEAD), status lines $(git -C $W/$t status --short | wc -l)"
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh > $W/build-$t-compiler.log 2>&1"
    log "$t compiler exit $? sha256 $(sha256sum $W/$t/build/compiler | cut -d' ' -f1)"
done
log "compilers done"
