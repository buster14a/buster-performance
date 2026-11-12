#!/bin/bash
# build.sh LABEL REVISION: a worktree of src at REVISION (trees/LABEL), built by its ./build.sh in one hold of the lock,
# its compiler kept as results/LABEL/compiler.
set -u
cd "$(dirname "$0")"
label=$1
revision=$2
out=$PWD/results/$label
mkdir -p "$out"
git -C src fetch -q origin "$revision" 2>/dev/null || true
test -d "trees/$label" || git -C src worktree add -q --detach "../trees/$label" "$revision"
git -C "trees/$label" rev-parse HEAD > "$out/revision.txt"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd trees/$label && ./build.sh" > "$out/build.log" 2>&1
echo "status $?" >> "$out/build.log"
cp "trees/$label/build/compiler" "$out/compiler"
sha256sum "$out/compiler" > "$out/compiler.sha256"
date -u +%FT%TZ > "$out/.built"
