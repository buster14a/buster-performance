#!/bin/bash
# The host's receipts: kernel, CPU, governor and EPP of CPU 2, toolchain versions, the trees' commits and manifests,
# and the binaries' hashes after the builds.
. "$(dirname "$0")/env.sh"
{
    echo "== $(date -Is)"
    uname -a
    grep -m1 "model name" /proc/cpuinfo
    echo "cpu2 governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null)"
    clang --version | head -n 1
    perf --version
    as --version | head -n 1
    for t in $MAIN $HEAD; do
        echo "tree $t commit $(cat $T/$t/COMMIT)"
        (cd $T/$t && find . -path ./build -prune -o -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum | sed "s|-|$t manifest|")
        if [ -f $T/$t/build/compiler ]; then sha256sum $T/$t/build/compiler; fi
    done
} >> $M/receipt.txt 2>&1
