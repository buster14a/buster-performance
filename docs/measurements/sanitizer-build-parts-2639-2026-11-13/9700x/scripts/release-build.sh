#!/bin/bash
# release-build.sh TAG TREE: one clean Release build of TREE without debug information (BUSTER_DEBUG_INFO=0, whose
# executable is byte for byte reproducible across checkouts) under the 9700X's lock, its log, time, ninja log and
# executable's SHA-256 into results/TAG.
set -u
base=~/buster-fast-bench/2639-claude
tag=$1
tree=$2
out=$base/results/$tag
mkdir -p "$out"
cd "$base/$tree"
export EXCLUSIVE_OWNER=claude-2639
export EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
export OUT="$out"
~/buster-fast-bench/exclusive.sh timeout -k 10 600 bash -c '
    { date -Is; cat /var/lib/buster-9700x/owner; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/before.txt"
    { git log --oneline -1; pwd; } > "$OUT/commit.txt"
    rm -rf build/cmake/native-g0
    TIMEFORMAT="wall %R user %U system %S"
    { time BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=0 ./build.sh > "$OUT/build.log" 2>&1; } 2> "$OUT/time.txt"
    echo "status $?" >> "$OUT/build.log"
    cp build/cmake/native-g0/.ninja_log "$OUT/ninja_log"
    sha256sum build/cmake/native-g0/Release/compiler > "$OUT/compiler.sha256"
    { date -Is; cat /proc/loadavg; } > "$OUT/after.txt"
' 2> "$out/exclusive.stderr"
echo "done $?" >> "$out/exclusive.stderr"
