#!/usr/bin/env bash
# receipts.sh TREE...: each tree's commit, the SHA-256 of its build/compiler and of its files without build/ and COMMIT
# (equal to the same hash of git archive of the commit), then the inputs and the tools.
. ~/buster-fast-bench/claude-141-reciprocal/common.sh
for tree in "$@"; do
    echo "$tree commit $(cat $tree/COMMIT) compiler $(sha256sum < $tree/build/compiler | cut -d" " -f1) files $(cd $tree && find . -path ./build -prune -o -type f ! -name COMMIT -print | LC_ALL=C sort | xargs sha256sum | sha256sum | cut -d" " -f1)"
done
sha256sum $Q/sqlite3.c $SRC/speedtest1.c $SRC/speedtest1-unity.c
clang --version | head -1
cc --version | head -1
uname -r
perf --version
grep -m1 "model name" /proc/cpuinfo
cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
