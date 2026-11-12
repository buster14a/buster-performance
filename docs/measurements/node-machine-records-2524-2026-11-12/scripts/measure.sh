#!/bin/bash
# measure.sh LABEL PATCH: apply PATCH to a clean src at main, build (one hold), time (one hold), time with --repeat 2 (one
# hold) and profile (one hold), each into results/LABEL.
set -u
cd "$(dirname "$0")"
label=$1
patch=$2
(cd src && git checkout -q -- . && git clean -qfd && git apply "$patch" && git status --short)
./build.sh "$label" && ./time.sh "$label" && ./repeat.sh "$label" && ./annotate.sh "$label"
