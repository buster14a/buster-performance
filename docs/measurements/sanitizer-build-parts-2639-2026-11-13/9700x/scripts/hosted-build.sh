#!/bin/bash
# hosted-build.sh TAG TREE ARCH SANITIZER: one clean sanitizer build of TREE shaped as a hosted runner's (an AMD EPYC
# 9V45, Zen 5, 4 vCPUs as 2 cores of 2 threads, so build.sh runs 2 jobs): pinned to the 9700X's cores 4 and 5, both
# threads (CPUs 4,12,5,13), under the 9700X's lock. Its log, time, ninja log, memory and the host's busiest processes
# before and after go into results/TAG. JOBS, when set, is build.sh's --jobs (its default there is 2, a job a core).
set -u
base=~/buster-fast-bench/2639-claude
tag=$1
tree=$2
arch=$3
sanitizer=$4
out=$base/results/$tag
mkdir -p "$out"
cd "$base/$tree"
export EXCLUSIVE_OWNER=claude-2639
export EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
# CPUS, when set, replaces the CPU list (4,12,5,13): 4,5,6,7 is four cores of one thread each.
export OUT="$out" SAN="$sanitizer" ARCH="$arch" JOBS_OPTION="${JOBS:+--jobs $JOBS}" CPUS="${CPUS:-4,12,5,13}"
~/buster-fast-bench/exclusive.sh timeout -k 10 580 bash -c '
    { date -Is; cat /var/lib/buster-9700x/owner; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/before.txt"
    { git log --oneline -1; pwd; echo "taskset -c $CPUS BUSTER_HOST_ARCH=$ARCH BUSTER_SANITIZER=$SAN ./build.sh $JOBS_OPTION"; } > "$OUT/commit.txt"
    variant=$ARCH-$SAN-O3
    rm -rf build/cmake/$variant
    ( start=$(awk "/MemTotal/ {t=\$2} /MemAvailable/ {a=\$2} END {print int((t-a)/1024)}" /proc/meminfo); peak=$start
      while [ ! -e "$OUT/build.done" ]; do
          used=$(awk "/MemTotal/ {t=\$2} /MemAvailable/ {a=\$2} END {print int((t-a)/1024)}" /proc/meminfo)
          [ "$used" -gt "$peak" ] && peak=$used
          echo "$(date +%s) $used" >> "$OUT/memory.txt"
          sleep 1
      done
      echo "start $start MiB, peak $peak MiB, peak over start $((peak - start)) MiB" > "$OUT/memory-peak.txt" ) &
    TIMEFORMAT="wall %R user %U system %S"
    { time taskset -c $CPUS env BUSTER_HOST_ARCH=$ARCH BUSTER_SANITIZER=$SAN BUSTER_SANITIZER_OPTIMIZATION=3 ./build.sh $JOBS_OPTION > "$OUT/build.log" 2>&1; } 2> "$OUT/time.txt"
    echo "status $?" >> "$OUT/build.log"
    touch "$OUT/build.done"; wait
    cp build/cmake/$variant/.ninja_log "$OUT/ninja_log"
    { date -Is; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/after.txt"
' 2> "$out/exclusive.stderr"
echo "done $?" >> "$out/exclusive.stderr"
