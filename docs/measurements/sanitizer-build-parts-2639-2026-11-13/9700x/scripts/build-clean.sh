#!/bin/bash
# build-clean.sh TAG SANITIZER [ENV=VALUE...]: one clean sanitizer build of $TREE (default src) under the 9700X's
# lock: its ninja log, compile database, build.sh's log, bash's time and the host's busiest processes before and
# after into results/TAG. ENV=VALUE settings go to build.sh (BUSTER_PARALLEL_CODEGEN=0, BUSTER_DEBUG_INFO=0).
set -u
base=~/buster-fast-bench/2639-claude
tag=$1
sanitizer=$2
shift 2
out=$base/results/$tag
mkdir -p "$out"
cd "$base/${TREE:-src}"
export EXCLUSIVE_OWNER=claude-2639
export EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
export OUT="$out" SAN="$sanitizer"
~/buster-fast-bench/exclusive.sh timeout -k 10 1500 env "$@" bash -c '
    { date -Is; cat /var/lib/buster-9700x/owner; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/before.txt"
    { git log --oneline -1; pwd; env | grep "^BUSTER_" | sort; } > "$OUT/commit.txt"
    variant=native-$SAN-O3
    rm -rf build/cmake/$variant
    # The memory in use (MemTotal - MemAvailable, MiB) each second while the build runs, and its peak over the
    # build'"'"'s start: an upper bound of what the build needs at once, nothing else running under the lock.
    ( start=$(awk "/MemTotal/ {t=\$2} /MemAvailable/ {a=\$2} END {print int((t-a)/1024)}" /proc/meminfo); peak=$start
      while [ ! -e "$OUT/build.done" ]; do
          used=$(awk "/MemTotal/ {t=\$2} /MemAvailable/ {a=\$2} END {print int((t-a)/1024)}" /proc/meminfo)
          [ "$used" -gt "$peak" ] && peak=$used
          echo "$(date +%s) $used" >> "$OUT/memory.txt"
          sleep 1
      done
      echo "start $start MiB, peak $peak MiB, peak over start $((peak - start)) MiB" > "$OUT/memory-peak.txt" ) &
    TIMEFORMAT="wall %R user %U system %S"
    { time BUSTER_HOST_ARCH=native BUSTER_SANITIZER=$SAN BUSTER_SANITIZER_OPTIMIZATION=3 ./build.sh > "$OUT/build.log" 2>&1; } 2> "$OUT/time.txt"
    echo "status $?" >> "$OUT/build.log"
    touch "$OUT/build.done"; wait
    du -sb build/cmake/$variant > "$OUT/tree-size.txt"; du -sb build/cmake/$variant/Release/codegen >> "$OUT/tree-size.txt" 2>/dev/null
    ls -la build/cmake/$variant/Release/codegen/*/ >> "$OUT/tree-size.txt" 2>/dev/null
    cp build/cmake/$variant/.ninja_log "$OUT/ninja_log"
    cp build/cmake/$variant/Release/compile_commands.json "$OUT/compile_commands.json" 2>/dev/null
    sha256sum build/cmake/$variant/Release/compiler > "$OUT/compiler.sha256" 2>/dev/null
    { date -Is; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/after.txt"
' 2> "$out/exclusive.stderr"
echo "done $?" >> "$out/exclusive.stderr"
