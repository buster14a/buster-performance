#!/usr/bin/env bash
# 2553 (current slots) runtime, step 1: the compilers, each built by its own build.sh --config Release with BUSTER_HOST_ARCH=znver5,
# each build one hold of the lock.
set -u
W=$HOME/buster-fast-bench/2553-claude-slots
export EXCLUSIVE_OWNER=claude-2553-slots EXCLUSIVE_TITLE="Tier 1 allocation: slots already current across blocks (#2553)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2553
L=$HOME/buster-fast-bench/exclusive.sh
log() { echo "$(date -u +%FT%TZ) $*" >> $W/build.log; }
for t in base head; do
    log "$t compiler at $(git -C $W/$t rev-parse HEAD), status lines $(git -C $W/$t status --short | wc -l)"
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-$t-compiler.log 2>&1"
    log "$t compiler exit $? sha256 $(sha256sum $W/$t/build/compiler | cut -d' ' -f1)"
done
test -x $W/base/build/compiler && test -x $W/head/build/compiler
