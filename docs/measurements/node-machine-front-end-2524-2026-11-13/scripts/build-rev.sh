#!/bin/bash
# build-rev.sh LABEL REVISION: a worktree of src at REVISION (trees/LABEL), no patch, built by its ./build.sh (Release) in one
# hold of the lock; its compiler kept as results/LABEL/compiler. The build directory is left for a removal by literal path.
set -u
cd "$(dirname "$0")"
label=$1
revision=$2
out=$PWD/results/$label
mkdir -p "$out"
git -C src fetch -q origin "$revision" 2>/dev/null || git -C src fetch -q origin claude/kind-ride-qzdmxi main
test -d "trees/$label" || git -C src worktree add -q --detach "../trees/$label" "$revision"
git -C "trees/$label" rev-parse HEAD > "$out/revision.txt"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd trees/$label && ./build.sh" > "$out/build.log" 2>&1
echo "status $?" >> "$out/build.log"
cp "trees/$label/build/compiler" "$out/compiler"
sha256sum "$out/compiler" > "$out/compiler.sha256"
date -u +%FT%TZ > "$out/.built"
