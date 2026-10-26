#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
# This original fixture's main checks its independent expected sum of 128 * 34122.
head449-final/build/compiler label-dispatch-128.c -o label-dispatch-final
./label-dispatch-final
printf 'label-dispatch: native result matches expected 128 * 34122\n'
