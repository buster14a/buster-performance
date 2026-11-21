#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-declaration-starts"
root=$PWD
export BUSTER_HOST_ARCH=znver5
rev=0efe6db191c5314674011b2369c0ce98f405bd84
./build-label.sh before "$rev"
./build-label.sh after "$rev" upstream-boundaries.patch
source ./corpora.sh
eval "sql=($sqlite_arguments)"
mkdir -p readings
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
for round in 1 2 3 4 5 6 7; do
 for huge in 1 0; do
  slot=0
  for tag in before after after before; do
   slot=$((slot+1)); prefix="readings/$round-$huge-$slot-$tag"
   ./lock.sh env BUSTER_HUGE_PAGES=$huge taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,instructions:u,instructions:k,minor-faults,major-faults,context-switches,cpu-migrations,duration_time -o "$prefix.stat" -- "results/$tag/compiler" --time-stages -c -o "$root/readings/sqlite.o" "${sql[@]}" > "$prefix.out" 2> "$prefix.err"
   sha256sum readings/sqlite.o >>readings/objects.sha256
   echo "$round $huge $slot $tag" >>readings/status
  done
 done
done
for tag in before after; do
 (
    cd trees/$tag
    "$root/lock.sh" taskset -c 2 "$root/results/$tag/compiler" test-checker --part 1/8 --seed 133 > "$root/readings/$tag-checker1" 2>&1
 )
done
date -u +%FT%TZ > readings/done
