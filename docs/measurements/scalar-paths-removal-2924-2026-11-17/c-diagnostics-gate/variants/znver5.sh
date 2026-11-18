#!/bin/bash
# #2959: variants.c and layout.c built with -march=znver5 (the first builds took the build host's -march=native, which
# isn't Zen 5); three processes of variants and one of layout under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: diagnostics' small path, znver5 (#2959)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2959
L=~/buster-fast-bench/exclusive.sh
for run in 1 2 3; do
    $L timeout -k 5 300 taskset -c 2 ./variants-znver5 > znver5-variants-$run.log 2>&1
    echo "variants $run: $?" >> znver5-status.txt
done
$L timeout -k 5 600 taskset -c 2 ./layout-znver5 > znver5-layout-1.log 2>&1
echo "layout 1: $?" >> znver5-status.txt
date -u +%FT%TZ > znver5.done
