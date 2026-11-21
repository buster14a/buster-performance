#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/$1"
source ./corpora.sh
eval "args=($sqlite_arguments)"
mkdir -p control
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
for n in 1 2 3 4 5 6 7; do
  k=0
  if (( n % 2 )); then labels=(before after after before); else labels=(after before before after); fi
  for v in "${labels[@]}"; do
    k=$((k+1))
    cp --reflink=never "results/$v/compiler" control/cc.tmp
    mv -f control/cc.tmp control/cc
    cat control/cc >/dev/null
    ./lock.sh taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,instructions:k,minor-faults,major-faults -o "control/$n-compile-$k-$v.stat" -- "$PWD/control/cc" -c -o "$PWD/control/sqlite.o" "${args[@]}" > "control/$n-$k.out" 2>"control/$n-$k.err"
    sha256sum control/sqlite.o >> control/objects.sha256
  done
done
for v in before after; do
  cp --reflink=never "results/$v/compiler" control/cc.tmp
  mv -f control/cc.tmp control/cc
  ./lock.sh taskset -c 2 perf record -q -o "control/$v.data" -e cycles:u -c 50000 -- "$PWD/control/cc" -c -o "$PWD/control/sqlite.o" "${args[@]}" > "control/profile-$v.out" 2>"control/profile-$v.err"
  perf report -i "control/$v.data" --stdio --no-children --sort dso,symbol --percent-limit 0.1 > "control/$v.report"
done
date -u +%FT%TZ > control/done
