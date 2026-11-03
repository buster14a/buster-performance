#!/bin/bash
# identity-remote.sh (on benchpress, inside the lock): the host, toolchain, binaries, trees and inputs of #649's close-out.
d=~/buster-fast-bench/649-claude
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
echo "## host"; uname -a; grep -m1 "model name" /proc/cpuinfo
for c in 2 10; do echo "cpu$c online: $(cat /sys/devices/system/cpu/cpu$c/online 2>/dev/null || echo n/a)"; done
echo "cpu2 governor: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp: $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
echo "## toolchain"; clang --version | head -1
echo "## binaries"; cd $d && sha256sum issue/build/compiler now/build/compiler
echo "## tree manifests (every file but build/)"
for t in issue now; do echo "$t: $(cd $d/$t && find . -path ./build -prune -o -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum | cut -c1-64) $(cd $d/$t && find . -path ./build -prune -o -type f -print | wc -l) files"; done
echo "base/src: $(cd $d/base && find src -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum | cut -c1-64) $(cd $d/base && find src -type f | wc -l) files"
echo "## inputs"; sha256sum $corpus/sqlite/sqlite3.c $corpus/provenance/gnu17-pinned-predefines.txt $d/base/src/buster/compiler/main.c
