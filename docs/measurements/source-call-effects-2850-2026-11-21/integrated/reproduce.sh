#!/usr/bin/env bash
set -euo pipefail
h=$(cd "$(dirname "$0")" && pwd)
repo=$(realpath "$1")
out=$(realpath -m "$2")
mkdir -p "$out"
git -C "$repo" worktree add --detach "$out/source" 6e9c51b9d238734468dccc03ab1b6c715449804e
tree="$out/source"
for phase in 01-physical-calls 02-debug-observer; do
    gzip -cd "$h/$phase.patch.gz" | git -C "$tree" apply -
done
(cd "$tree" && ./build.sh)
gzip -cd "$h/../predefines.h.gz" > "$tree/build/predefines.h"
cc="$tree/build/compiler"
python3 "$h/../matrix.py" "$cc" "$out/fixed" --raw
python3 "$h/../matrix.py" "$cc" "$out/debug" --force --raw
python3 "$h/../debug-shapes.py" "$cc" "$out/debug-shapes"
python3 "$h/caller-abi.py" "$cc" "$out/caller-abi"
mkdir -p "$out/witness-source"
cp "$h"/witness-source/*.c "$out/witness-source/"
gzip -cd "$h/witness-source/generated.c.gz" > "$out/witness-source/generated.c"
python3 "$h/decl-witness.py" "$cc" "$out/witness-source" "$out/witness"
