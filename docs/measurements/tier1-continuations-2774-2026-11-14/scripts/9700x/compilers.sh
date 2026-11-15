#!/usr/bin/env bash
# 2774 runtime, step 1: the compilers, each built by its own build.sh --config Release with BUSTER_HOST_ARCH=znver5,
# each build one hold of the lock; then copied to compilers/ and the build trees removed (disk).
set -u
W=$HOME/buster-fast-bench/2774-claude
export EXCLUSIVE_OWNER=claude-2774 EXCLUSIVE_TITLE="Tier 1 allocation: evict a value that continues in its slot first (#2774)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2774
L=$HOME/buster-fast-bench/exclusive.sh
log() { echo "$(date -u +%FT%TZ) $*" >> $W/build.log; }
mkdir -p $W/compilers
for t in base head; do
    log "$t compiler at $(git -C $W/$t rev-parse HEAD), status lines $(git -C $W/$t status --short | wc -l)"
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-$t-compiler.log 2>&1"
    log "$t compiler exit $? sha256 $(sha256sum $W/$t/build/compiler | cut -d' ' -f1)"
    cp $W/$t/build/compiler $W/compilers/$t
done
test -x $W/compilers/base && test -x $W/compilers/head && rm -rf $W/base/build $W/head/build
