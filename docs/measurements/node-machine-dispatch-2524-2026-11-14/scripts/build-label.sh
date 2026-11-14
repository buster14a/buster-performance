#!/bin/bash
# build-label.sh LABEL REVISION [PATCH]: a worktree of src at REVISION (trees/LABEL), PATCH applied if given, built by its
# ./build.sh --config Release in one hold of the lock; its compiler kept as results/LABEL/compiler, its build directory
# removed. Exits 1 if the build fails (no stale compiler is copied).
set -u
cd "$(dirname "$0")"
label=$1
revision=$2
patch=${3:+$PWD/$3}
out=$PWD/results/$label
mkdir -p "$out"
git -C src fetch -q origin "$revision" 2>/dev/null || git -C src fetch -q origin main
if ! test -d "trees/$label"; then
    git -C src worktree add -q --detach "../trees/$label" "$revision" || exit 1
    if test -n "$patch"; then git -C "trees/$label" apply "$patch" || { echo "patch failed"; exit 1; }; fi
fi
{ git -C "trees/$label" rev-parse HEAD; test -n "$patch" && sha256sum "$patch"; } > "$out/revision.txt"
test -n "$patch" && cp "$patch" "$out/"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd trees/$label && ./build.sh --config Release" > "$out/build.log" 2>&1
status=$?
echo "status $status" >> "$out/build.log"
if [ $status != 0 ] || ! test -x "trees/$label/build/compiler"; then echo "build failed"; exit 1; fi
rm -f "$out/compiler"
cp "trees/$label/build/compiler" "$out/compiler"
sha256sum "$out/compiler" > "$out/compiler.sha256"
nm "$out/compiler" | grep -i ' node_machine_' | sort -k3 > "$out/nm-node-machine.txt"
rm -rf "trees/$label/build"
date -u +%FT%TZ > "$out/.built"
echo built
