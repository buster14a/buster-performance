#!/bin/bash
# build-inc.sh LABEL BASE [PATCH]: trees/work reset to BASE, PATCH applied, built incrementally by ./build.sh --config Release
# in one hold of the lock (its build directory kept for the next variant); the compiler kept as results/LABEL/compiler,
# with the tree's diff and nm of the node machine's symbols. Exits 1 if the patch or the build fails.
set -u
cd "$(dirname "$0")"
label=$1
base=$2
patch=${3:+$PWD/$3}
out=$PWD/results/$label
mkdir -p "$out"
git -C src fetch -q origin "$base" 2>/dev/null || git -C src fetch -q origin main
test -d trees/work || git -C src worktree add -q --detach ../trees/work "$base" || exit 1
git -C trees/work checkout -q --detach "$base" -- 2>/dev/null; git -C trees/work checkout -q --detach "$base" || exit 1
git -C trees/work checkout -q -- . && git -C trees/work clean -qfd src || exit 1
if test -n "$patch"; then git -C trees/work apply "$patch" || { echo "patch failed"; exit 1; }; cp "$patch" "$out/"; fi
{ git -C trees/work rev-parse HEAD; test -n "$patch" && sha256sum "$patch"; } > "$out/revision.txt"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd trees/work && ./build.sh --config Release" > "$out/build.log" 2>&1
status=$?
echo "status $status" >> "$out/build.log"
if [ $status != 0 ]; then echo "build failed"; exit 1; fi
rm -f "$out/compiler"
cp trees/work/build/compiler "$out/compiler"
sha256sum "$out/compiler" > "$out/compiler.sha256"
nm -S "$out/compiler" | grep -i ' node_machine_' | sort -k4 > "$out/nm-node-machine.txt"
date -u +%FT%TZ > "$out/.built"
echo built
