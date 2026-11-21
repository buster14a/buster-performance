#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/$1"
source ./corpora.sh
eval "args=($sqlite_arguments)"
mkdir -p control
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
for v in before after; do
  cp --reflink=never "results/$v/compiler" control/cc.tmp
  mv -f control/cc.tmp control/cc
  ./lock.sh taskset -c 2 perf record -q -o "control/$v.data" -e cycles:u -c 50000 -- "$PWD/control/cc" -c -o "$PWD/control/sqlite.o" "${args[@]}" > "control/profile-$v.out" 2>"control/profile-$v.err"
  perf report -i "control/$v.data" --stdio --no-children --sort dso,symbol --percent-limit 0.1 > "control/$v.report"
done
date -u +%FT%TZ > control/done
