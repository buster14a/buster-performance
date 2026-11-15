#!/bin/bash
# build-clean2.sh TAG SANITIZER [ENV=VALUE...]: one clean Release sanitizer build (CI's: --config Release) of $TREE
# (default src) under the 9700X's lock: ninja log, compile database, build log, bash's time, the busiest processes
# before and after, and the checker's split report into results/TAG. ENV=VALUE settings go to build.sh.
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
export OUT="$out" SAN="$sanitizer" ARCH="${ARCH:-native}"
~/buster-fast-bench/exclusive.sh timeout -k 10 1500 env "$@" bash -c '
    { date -Is; cat /var/lib/buster-9700x/owner; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/before.txt"
    { git log --oneline -1; git status --short | head -20; pwd; env | grep "^BUSTER_" | sort; } > "$OUT/commit.txt"
    variant=$ARCH-$SAN-O3
    rm -rf build/cmake/$variant
    TIMEFORMAT="wall %R user %U system %S"
    { time BUSTER_HOST_ARCH=$ARCH BUSTER_SANITIZER=$SAN BUSTER_SANITIZER_OPTIMIZATION=3 ./build.sh --config Release ${JOBS:+--jobs $JOBS} > "$OUT/build.log" 2>&1; } 2> "$OUT/time.txt"
    echo "status $?" >> "$OUT/build.log"
    cp build/cmake/$variant/.ninja_log "$OUT/ninja_log"
    cp build/cmake/$variant/Release/compile_commands.json "$OUT/compile_commands.json" 2>/dev/null
    sha256sum build/cmake/$variant/Release/compiler > "$OUT/compiler.sha256" 2>/dev/null
    { date -Is; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/after.txt"
' 2> "$out/exclusive.stderr"
echo "done $?" >> "$out/exclusive.stderr"
