#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../head"
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
export LC_ALL=C SOURCE_DATE_EPOCH=1792454400
taskset -c 0-7 ./build/compiler parallel --jobs 8 --timeout 180 ../evidence/tests.list > ../evidence/qualification-9700x.log 2>&1
cat ../evidence/qualification-9700x.log
