#!/bin/bash
# off-at.sh SHA LABEL DIFF: src at SHA by its id (no local change left) with DIFF applied (the update codes refused), built
# as LABEL and timed (time.sh), each in a hold of the lock of its own. Stops where the checkout, the diff or the build
# fails.
set -u
cd "$(dirname "$0")"
(cd src && git checkout -q -- . && git clean -fdq && git checkout -q --detach "$1" && git apply "../$3") || exit 1
mkdir -p "results/$2"
{ git -C src log -1 --format='%H %s'; git -C src status --short; sha256sum "$3"; } > "results/$2/checkout.txt"
./build-tree.sh src "$2" || exit 1
./time.sh "$2"
date -u +%FT%TZ > "results/$2/.all"
