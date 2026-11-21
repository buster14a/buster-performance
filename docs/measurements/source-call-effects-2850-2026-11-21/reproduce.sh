#!/usr/bin/env bash
# Run under a reserved Buster build/test CPU allocation.
set -euo pipefail
h=$(cd "$(dirname "$0")" && pwd)
repo=$(realpath "$1")
out=$(realpath -m "$2")
mkdir -p "$out"
git -C "$repo" worktree add --detach "$out/source" 6e9c51b9d238734468dccc03ab1b6c715449804e
tree="$out/source"
gzip -cd "$h/01-physical-calls.patch.gz" | git -C "$tree" apply -
gzip -cd "$h/01b-unfixed-graph-observer.patch.gz" | git -C "$tree" apply -
(cd "$tree" && ./build.sh)
gzip -cd "$h/predefines.h.gz" > "$tree/build/predefines.h"
cp "$tree/build/compiler" "$out/unfixed"
python3 "$h/matrix.py" "$out/unfixed" "$out/raw" --raw
gzip -cd "$h/01b-unfixed-graph-observer.patch.gz" | git -C "$tree" apply -R -
for n in 02-caller-flatten 03-debug-observer; do gzip -cd "$h/$n.patch.gz" | git -C "$tree" apply -; done
(cd "$tree" && ./build.sh)
cc="$tree/build/compiler"
python3 "$h/matrix.py" "$cc" "$out/fixed" --raw
python3 "$h/matrix.py" "$cc" "$out/debug" --force --raw
for n in origin reference typedef; do python3 "$h/matrix.py" "$cc" "$out/$n" --force --raw --fault "$n"; done
python3 "$h/debug-shapes.py" "$cc" "$out/debug-shapes"
