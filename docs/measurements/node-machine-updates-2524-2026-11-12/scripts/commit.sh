#!/bin/bash
# commit.sh SHA: src checked out at the pushed commit SHA by its id (no local change left), built as its first 8
# characters, then the comparison (corpora.sh), the timing (time.sh) and the profile (profile.sh), each run in a hold
# of the lock of its own.
set -u
cd "$(dirname "$0")"
label=${1:0:8}
git -C src fetch -q origin claude/compassionate-brown-2p75f9
git -C src checkout -q -- . && git -C src clean -fdq && git -C src checkout -q --detach "$1"
mkdir -p "results/$label"
{ git -C src log -1 --format='%H %s'; git -C src status --short; echo "status printed above, if any"; } > "results/$label/checkout.txt"
./build-tree.sh src "$label" || exit 1
./corpora.sh "$label"
./time.sh "$label"
./profile.sh "$label"
date -u +%FT%TZ > "results/$label/.all"
