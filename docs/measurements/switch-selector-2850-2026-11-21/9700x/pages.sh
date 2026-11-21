#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-switch-3217-integrated"
source ./corpora.sh
eval "args=($sqlite_arguments)"
mkdir -p pages
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
for n in 1 2 3 4 5 6 7; do
 if (( n % 2 )); then labels=(before after after before); else labels=(after before before after); fi
 for policy in 1 0; do
  k=0
  for v in "${labels[@]}"; do
   k=$((k+1)); tag=pages/$n-$policy-$k-$v
   cp --reflink=never "results/$v/compiler" pages/cc.tmp
   mv -f pages/cc.tmp pages/cc
   cat pages/cc >/dev/null
   ./lock.sh env BUSTER_HUGE_PAGES="$policy" taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,instructions:k,minor-faults,major-faults,cpu-migrations -o "$tag.stat" -- "$PWD/pages/cc" --time-stages -c -o "$PWD/pages/sqlite.o" "${args[@]}" > "$tag.out" 2> "$tag.err"
   sha256sum pages/sqlite.o >> pages/objects.sha256
  done
 done
done
date -u +%FT%TZ > pages/done
