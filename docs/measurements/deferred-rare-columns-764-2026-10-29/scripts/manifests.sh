#!/bin/bash
# The record's identities (no lock: reads only): each tree's source manifest (as record #769's), each binary's SHA-256,
# the inputs' SHA-256, and the host's: kernel, CPU, governors, transparent huge pages, clang, perf.
D=~/buster-fast-bench/claude-764
mkdir -p "$D/record"
for tree in main-bc11fddb pr791-561e5f1c cols-2954544c multicols-865271ef pop-98023033 head-3b87d0c9 head-95fc3668; do
    (cd "$D/trees/$tree" && nice -n 19 sha256sum build.sh && find src -type f | LC_ALL=C sort | xargs nice -n 19 sha256sum) > "$D/record/source-$tree.sha256"
    echo "$tree $(cat "$D/trees/$tree/COMMIT") $(sha256sum < "$D/record/source-$tree.sha256" | cut -d' ' -f1) $(find "$D/trees/$tree/src" -type f | wc -l)" >> "$D/record/trees.txt.new"
done
mv "$D/record/trees.txt.new" "$D/record/trees.txt"
(cd "$D/trees" && sha256sum */build/compiler) > "$D/record/binaries.sha256"
(cd "$D/inputs" && sha256sum synthetic/*.c c-testsuite/*.c gen2.c && sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c) > "$D/record/inputs.sha256"
{
    uname -a
    grep -m1 "model name" /proc/cpuinfo
    for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference 2>/dev/null)"; done
    echo "thp enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled) defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag) use_zero_page: $(cat /sys/kernel/mm/transparent_hugepage/use_zero_page)"
    clang --version | head -1
    perf --version
} > "$D/record/host.txt"
cat "$D/record/trees.txt"
