#!/bin/bash
# build-pgo.sh LABEL REVISION PATCH TRAIN: build-patch.sh's worktree, built with BUSTER_PGO=1 and BUSTER_PGO_TRAIN=TRAIN in one
# hold of the lock; its compiler kept as results/LABEL/compiler and the build directory removed.
set -u
cd "$(dirname "$0")"
label=$1
revision=$2
patch=$PWD/$3
train=$PWD/$4
out=$PWD/results/$label
mkdir -p "$out"
test -d "trees/$label" || { git -C src worktree add -q --detach "../trees/$label" "$revision" && git -C "trees/$label" apply "$patch"; }
{ git -C "trees/$label" rev-parse HEAD; sha256sum "$patch" "$train"; } > "$out/revision.txt"
cp "$patch" "$train" "$out/"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd trees/$label && BUSTER_PGO=1 BUSTER_PGO_TRAIN=$train ./build.sh" > "$out/build.log" 2>&1
echo "status $?" >> "$out/build.log"
cp "trees/$label/build/compiler" "$out/compiler"
sha256sum "$out/compiler" > "$out/compiler.sha256"
rm -rf "trees/$label/build"
date -u +%FT%TZ > "$out/.built"
