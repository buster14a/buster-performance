#!/bin/bash
# timing-only.sh LABEL DIFF: src at main 0af27a30 with DIFF applied (apply.sh), built as LABEL and timed (time.sh), each
# in a hold of the lock of its own; no comparison runs. Stops where the diff doesn't apply or the build fails.
set -u
cd "$(dirname "$0")"
./apply.sh "$2" || exit 1
mkdir -p "results/$1"
sha256sum "$2" > "results/$1/diff.txt"
./build-tree.sh src "$1" || exit 1
./time.sh "$1"
date -u +%FT%TZ > "results/$1/.all"
