#!/usr/bin/env bash
# make-placements.sh NAME SHIFT... — links $WORK/objs-NAME into build/NAME/compiler-SHIFT.
set -euo pipefail
ROOT="$HOME/buster-fast-bench/devin-880"
name=$1; shift
for s in "$@"; do
    "$ROOT/link-variant.sh" "$name" "$ROOT/work/objs-$name" "$ROOT/work/build/$name/compiler-$s" "$s"
done
