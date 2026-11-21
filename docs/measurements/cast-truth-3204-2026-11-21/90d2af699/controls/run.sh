#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
exec 8>our-timing.lock; flock -x 8
mkdir -p results/{aa90left,aa90right,ba90base,ba90new}
for label in aa90left aa90right ba90base; do cp --reflink=auto results/xh4/compiler "results/$label/compiler"; done
cp --reflink=auto results/cast90d/compiler results/ba90new/compiler
flags="--shadow --passes 0 --window-rows"
./turns.sh -aa90 7 musl "aa90left before1 $flags" "aa90right after1 $flags" "aa90right after2 $flags" "aa90left before2 $flags"
./turns.sh -ba90 7 musl "ba90new after1 $flags" "ba90base before1 $flags" "ba90base before2 $flags" "ba90new after2 $flags"
echo COMPLETE
