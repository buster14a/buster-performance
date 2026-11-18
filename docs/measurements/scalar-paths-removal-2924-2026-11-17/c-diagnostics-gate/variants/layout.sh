#!/bin/bash
# #2959: layout.c's sweep of the radix sort's array placement, built as variants.c is; two processes under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' radix by array placement (#2959)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2959
L=~/buster-fast-bench/exclusive.sh
for run in 1 2; do
    $L timeout -k 5 600 taskset -c 2 ./layout > layout-$run.log 2>&1
    echo "layout $run: $?" >> layout-status.txt
done
date -u +%FT%TZ > layout.done
