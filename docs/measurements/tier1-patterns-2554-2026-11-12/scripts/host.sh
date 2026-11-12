#!/bin/bash
# host.sh: the host, tools and binaries the record's numbers come from, into results/host.txt. No run, so no lock.
cd "$(dirname "$0")"
mkdir -p results
{
    uname -a
    grep -m1 'model name' /proc/cpuinfo
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null
    clang --version | head -1
    cc --version | head -1
    perf --version
    for n in main identity store dispatch head head2 main2 final main-kinds head-kinds; do
        [ -e "src-$n.commit" ] && echo "src-$n $(cat src-$n.commit)"
        [ -e "src-$n/build/compiler" ] && sha256sum "src-$n/build/compiler"
    done
    sha256sum inputs/speedtest1.c inputs/lua-5.4.8.tar.gz inputs/scripts/*.lua /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
} > results/host.txt 2>&1
