#!/usr/bin/env bash
# #1118: base is main at 2ebfe68 (the branch's merge-base), head is claude/keen-hypatia-afeao9; each built by its own
# build.sh --config Release with BUSTER_HOST_ARCH=znver5, one hold of the lock each.
set -u
W=$HOME/buster-fast-bench/1118-claude
export EXCLUSIVE_OWNER=claude-1118 EXCLUSIVE_TITLE="Arenas grow in place under a finite RLIMIT_AS (#1118)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1118
L=$HOME/buster-fast-bench/exclusive.sh
log() { echo "$(date -u +%FT%TZ) $*" >> $W/log.txt; }
cd $W || exit 1
REF=$HOME/buster-fast-bench/2767-claude/head
for t in base head; do
    if [ ! -d $t ]; then
        if [ -d $REF/.git ]; then git clone -q --reference $REF https://github.com/buster14a/buster.git $t; else git clone -q https://github.com/buster14a/buster.git $t; fi
    fi
done
git -C base fetch -q origin main && git -C base checkout -q 2ebfe68
git -C head fetch -q origin claude/keen-hypatia-afeao9 && git -C head checkout -q FETCH_HEAD
for t in base head; do
    log "$t at $(git -C $W/$t rev-parse HEAD), status lines $(git -C $W/$t status --short | wc -l)"
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-$t.log 2>&1"
    log "$t build exit $? sha256 $(sha256sum $W/$t/build/compiler | cut -d' ' -f1)"
    cp $W/$t/build/compiler $W/compiler-$t
done
log "built"
