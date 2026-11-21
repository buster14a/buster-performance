#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-switch-3217-integrated"
source ./corpora.sh
eval "args=($sqlite_arguments)"
mkdir -p lanes
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
./lock.sh taskset -c 2 sh -c 'nproc; grep Cpus_allowed_list /proc/self/status; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor; cat /sys/kernel/mm/transparent_hugepage/enabled; uname -r' > lanes/host
for n in 1 2 3 4; do
 for tag in auto fixed off aa worker; do
  k=0
  for v in before after after before; do
   k=$((k+1))
   src=$v; opts=(--time-stages); perfopts=()
   case $tag in
     fixed) opts+=(--lanes 1);;
     off) opts+=(--lanes 1 --attested=off);;
     aa) src=before;;
     worker) perfopts=(--no-inherit);;
   esac
   cp --reflink=never "results/$src/compiler" lanes/cc.tmp
   mv -f lanes/cc.tmp lanes/cc
   cat lanes/cc >/dev/null
   base="lanes/$n-$tag-$k-$v"
   ./lock.sh taskset -c 2 perf stat "${perfopts[@]}" -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,instructions:k,cpu-migrations,context-switches,minor-faults,major-faults -o "$base.stat" -- "$PWD/lanes/cc" "${opts[@]}" -c -o "$PWD/lanes/sqlite.o" "${args[@]}" > "$base.out" 2>"$base.err"
   sha256sum lanes/sqlite.o >> lanes/objects.sha256
  done
 done
done
date -u +%FT%TZ > lanes/done
