#!/bin/bash
# build.sh TREE LABEL: build TREE (one hold of the lock) and keep its compiler as results/LABEL/compiler.
set -u
cd "$(dirname "$0")"
tree=$1
label=$2
out=$PWD/results/$label
mkdir -p "$out" logs
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd '$tree' && git log --oneline -1 && ./build.sh" > "logs/build-$label.log" 2>&1
cp "$tree/build/compiler" "$out/compiler"
git -C "$tree" rev-parse HEAD > "$out/commit.txt"
sha256sum "$out/compiler" >> "$out/commit.txt"
