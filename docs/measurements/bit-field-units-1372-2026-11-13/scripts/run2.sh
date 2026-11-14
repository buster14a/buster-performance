#!/bin/bash
# #1372's measurements as four holds of the 9700X's lock (run.sh's objects and executables, made before): three rounds
# of the kernel's six variants (round.sh), then the compile-time comparison (compile.sh).
set -euo pipefail
cd ~/buster-fast-bench/1372-claude
echo $$ > run2.pid
export EXCLUSIVE_OWNER=claude-1372 EXCLUSIVE_TITLE="Bit-field access units (#1372)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1372
lock=~/buster-fast-bench/exclusive.sh
for round in 1 2 3; do
    $lock timeout 300 ./round.sh "$round"
done
$lock timeout 500 ./compile.sh
echo done
