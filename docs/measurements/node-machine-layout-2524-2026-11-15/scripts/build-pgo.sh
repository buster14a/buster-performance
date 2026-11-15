#!/bin/bash
# build-pgo.sh LABEL REVISION TRAIN: as build-label.sh, built with BUSTER_PGO=1 and BUSTER_PGO_TRAIN=TRAIN (a Release build
# whose profile is TRAIN's run of its instrumented compiler) in one hold of the lock.
set -u
cd "$(dirname "$0")"
label=$1
revision=$2
train=$PWD/$3
out=$PWD/results/$label
mkdir -p "$out"
git -C src fetch -q origin "$revision" 2>/dev/null || git -C src fetch -q origin main
test -d "trees/$label" || git -C src worktree add -q --detach "$PWD/trees/$label" "$revision" || exit 1
{ git -C "trees/$label" rev-parse HEAD; sha256sum "$train"; } > "$out/revision.txt"
cp "$train" "$out/"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd trees/$label && BUSTER_PGO=1 BUSTER_PGO_TRAIN=$train ./build.sh" > "$out/build.log" 2>&1
status=$?
echo "status $status" >> "$out/build.log"
if [ $status != 0 ] || ! test -x "trees/$label/build/compiler"; then echo "build failed"; exit 1; fi
cp "trees/$label/build/compiler" "$out/compiler"
sha256sum "$out/compiler" > "$out/compiler.sha256"
nm -S "$out/compiler" | grep -i ' node_machine_' | sort -k1 > "$out/nm-node-machine.txt"
rm -rf "trees/$label/build"
date -u +%FT%TZ > "$out/.built"
