#!/bin/bash
# measure2.sh LABEL BRANCH COMMIT PATCH [annotate]: src at COMMIT (fetched from BRANCH) with PATCH applied (none: "-"),
# built (one hold), timed (one hold) and timed with --repeat 2 (one hold), and profiled (one hold) with "annotate".
set -u
cd "$(dirname "$0")"
label=$1
branch=$2
commit=$3
patch=$4
(cd src && git fetch -q origin "$branch" && git checkout -q -- . && git clean -qfd && git checkout -q "$commit" && { [ "$patch" = "-" ] || git apply "$patch"; } && git log --oneline -1 && git status --short)
./build.sh "$label" && ./time.sh "$label" && ./repeat.sh "$label"
if [ "${5:-}" = annotate ]; then ./annotate.sh "$label"; fi
