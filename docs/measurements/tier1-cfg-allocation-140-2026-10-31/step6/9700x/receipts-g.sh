#!/usr/bin/env bash
# receipts-g.sh TREE...: each tree: its commit, the SHA-256 of its build/compiler, and of its files without build/ and
# COMMIT (find . -path ./build -prune -o -type f ! -name COMMIT -print | LC_ALL=C sort | xargs sha256sum | sha256sum),
# which equals the same hash of git archive of the commit. Then the inputs and the tools.
set -u
export LC_ALL=C
cd ~/buster-fast-bench/claude-140-cfg || exit 1
for tree in "$@"; do
    echo "$tree commit $(cat $tree/COMMIT) compiler $(sha256sum < $tree/build/compiler | cut -d" " -f1) files $(cd $tree && find . -path ./build -prune -o -type f ! -name COMMIT -print | LC_ALL=C sort | xargs sha256sum | sha256sum | cut -d" " -f1)"
done
sha256sum $HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c $HOME/buster-fast-bench/speedtest1-136-claude/src/speedtest1.c $HOME/buster-fast-bench/speedtest1-136-claude/src/speedtest1-unity.c
clang --version | head -1
cc --version | head -1
uname -r
perf --version
grep -m1 "model name" /proc/cpuinfo
cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
