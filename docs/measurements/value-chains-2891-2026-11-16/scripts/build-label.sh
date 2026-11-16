#!/bin/bash
# build-label.sh LABEL REVISION [PATCH...]: a worktree of src at REVISION (trees/LABEL), each PATCH applied in turn, built
# by its ./build.sh --config Release in one hold of the lock; its compiler kept as results/LABEL/compiler, its build
# directory removed. Exits 1 if the build fails (no stale compiler is copied).
set -u
cd "$(dirname "$0")"
label=$1
revision=$2
shift 2
out=$PWD/results/$label
mkdir -p "$out" trees
git -C src fetch -q origin "$revision" 2>/dev/null || git -C src fetch -q origin main
rm -rf "trees/$label"
git -C src worktree prune
git -C src worktree add -q --detach "$PWD/trees/$label" "$revision" || exit 1
git -C "trees/$label" rev-parse HEAD > "$out/revision.txt"
for patch in "$@"; do
    git -C "trees/$label" apply "$PWD/$patch" || { echo "patch $patch failed"; exit 1; }
    sha256sum "$patch" >> "$out/revision.txt"
    cp "$patch" "$out/"
done
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd trees/$label && ./build.sh --config Release" > "$out/build.log" 2>&1
status=$?
echo "status $status" >> "$out/build.log"
if [ $status != 0 ] || ! test -x "trees/$label/build/compiler"; then echo "build failed"; tail -5 "$out/build.log"; exit 1; fi
rm -f "$out/compiler"
cp "trees/$label/build/compiler" "$out/compiler"
sha256sum "$out/compiler" > "$out/compiler.sha256"
rm -rf "trees/$label/build"
date -u +%FT%TZ > "$out/.built"
echo built
