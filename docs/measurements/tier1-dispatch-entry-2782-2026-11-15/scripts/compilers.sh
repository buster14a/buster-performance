#!/usr/bin/env bash
# 2782 runtime, step 1: the compilers. base is main at ca1ede6a, head is base with head.patch (the pull request's code);
# each built by its own build.sh --config Release with BUSTER_HOST_ARCH=znver5, each build one hold of the lock.
set -u
W=$HOME/buster-fast-bench/2782-claude
export EXCLUSIVE_OWNER=claude-2782 EXCLUSIVE_TITLE="Tier 1: a goto-entered handler takes the dispatch registers (#2782, #2592)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2782
L=$HOME/buster-fast-bench/exclusive.sh
REVS=${REVS:-base head}
log() { echo "$(date -u +%FT%TZ) $*" >> $W/build.log; }
for t in $REVS; do
    log "$t compiler at $(git -C $W/$t rev-parse HEAD), status lines $(git -C $W/$t status --short | wc -l)"
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-$t-compiler.log 2>&1"
    log "$t compiler exit $? sha256 $(sha256sum $W/$t/build/compiler | cut -d' ' -f1)"
done
log "compilers done"
