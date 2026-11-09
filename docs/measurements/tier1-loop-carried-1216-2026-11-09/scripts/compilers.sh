#!/usr/bin/env bash
# 1216 runtime, step 1: the compilers. base is the branch's merge base with main (6a021550e), head the branch
# (540ace7ef); each built by its own build.sh with BUSTER_HOST_ARCH=znver5, each build one hold of the lock.
set -u
W=$HOME/buster-fast-bench/1216-droid
export EXCLUSIVE_OWNER=droid-1216 EXCLUSIVE_TITLE='Tier 1 dispatch loops keep loop-carried values in registers (#1216)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1216
L=$HOME/buster-fast-bench/exclusive.sh
log() { echo "$(date -u +%FT%TZ) $*" >> $W/build.log; }
for t in base head; do
    log "$t compiler at $(git -C $W/$t rev-parse HEAD), status lines $(git -C $W/$t status --short | wc -l)"
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh > $W/build-$t-compiler.log 2>&1"
    log "$t compiler exit $? sha256 $(sha256sum $W/$t/build/compiler | cut -d' ' -f1)"
done
log "compilers done"
