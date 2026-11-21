#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-switch-3217-integrated"
source ./corpora.sh
eval "args=($sqlite_arguments)"
mkdir -p busy
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
for n in 1 2 3 4; do
 if (( n % 2 )); then labels=(before after after before); else labels=(after before before after); fi
 for policy in 1 0; do
  k=0
  for v in "${labels[@]}"; do
   k=$((k+1)); tag=busy/$n-$policy-$k-$v
   cp --reflink=never "results/$v/compiler" busy/cc.tmp
   mv -f busy/cc.tmp busy/cc
   cat busy/cc >/dev/null
   ./lock.sh env BUSTER_TEST_HOST_BUSY="$policy" taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,instructions:k,minor-faults,major-faults,cpu-migrations -o "$tag.stat" -- "$PWD/busy/cc" --time-stages -c -o "$PWD/busy/sqlite.o" "${args[@]}" > "$tag.out" 2> "$tag.err"
   sha256sum busy/sqlite.o >> busy/objects.sha256
  done
 done
done
date -u +%FT%TZ > busy/done
