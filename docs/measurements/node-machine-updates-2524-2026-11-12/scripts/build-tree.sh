#!/bin/bash
# build-tree.sh TREE LABEL: build TREE (src or main) in one hold of the lock and keep its compiler and commit in
# results/LABEL. A failed build stops the caller (exit 1) and keeps no compiler.
set -u
cd "$(dirname "$0")"
tree=$1
out=$PWD/results/$2
mkdir -p "$out"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd '$tree' && ./build.sh" > "$out/build.log" 2>&1
status=$?
echo "status $status" >> "$out/build.log"
if [ "$status" -ne 0 ]; then
    exit 1
fi
cp "$tree/build/compiler" "$out/compiler"
git -C "$tree" log -1 --format='%H %s' > "$out/commit.txt"
sha256sum "$out/compiler" >> "$out/commit.txt"
date -u +%FT%TZ > "$out/.built"
