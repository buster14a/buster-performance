#!/bin/bash
# series.sh LABEL DIFF: src with DIFF applied, built as LABEL, then the comparison (corpora.sh) and the timing (time.sh) on
# it, each run in a hold of the lock of its own. Writes its PID to series.pid.
set -u
cd "$(dirname "$0")"
echo $$ > series.pid
(cd src && git checkout -q -- . && git apply "../$2")
./build-tree.sh src "$1"
./corpora.sh "$1"
./time.sh "$1"
date -u +%FT%TZ > "results/$1/.all"
