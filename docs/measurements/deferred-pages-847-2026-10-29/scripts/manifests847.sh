#!/bin/bash
# #847's record identities (no lock: reads only), as manifests.sh: each tree's source manifest, each binary's SHA-256,
# the inputs' SHA-256, and the host's: kernel, CPU, governors, transparent huge pages, clang, perf.
D=~/buster-fast-bench/claude-764
R="$D/record847"
mkdir -p "$R"
: > "$R/trees.txt.new"
for tree in main-bc11fddb main-d11a91d2 pr791-d312b0a8 head-95fc3668 headhuge-95fc3668 new-7a454554 new-b2e2169e new-f3ac8f15 new-b179fad3 diag847; do
    if [ ! -d "$D/trees/$tree" ]; then
        continue
    fi
    (cd "$D/trees/$tree" && nice -n 19 sha256sum build.sh && find src -type f | LC_ALL=C sort | xargs nice -n 19 sha256sum) > "$R/source-$tree.sha256"
    echo "$tree $(cat "$D/trees/$tree/COMMIT" 2>/dev/null || echo uncommitted) $(sha256sum < "$R/source-$tree.sha256" | cut -d' ' -f1) $(find "$D/trees/$tree/src" -type f | wc -l)" >> "$R/trees.txt.new"
done
mv "$R/trees.txt.new" "$R/trees.txt"
(cd "$D/trees" && for t in main-bc11fddb main-d11a91d2 pr791-d312b0a8 head-95fc3668 headhuge-95fc3668 new-b2e2169e new-f3ac8f15 new-b179fad3 diag847; do [ -x "$t/build/compiler" ] && sha256sum "$t/build/compiler"; done) > "$R/binaries.sha256"
(cd "$D/inputs" && sha256sum synthetic/*.c c-testsuite/*.c gen2.c && sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c) > "$R/inputs.sha256"
{
    uname -a
    grep -m1 "model name" /proc/cpuinfo
    for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference 2>/dev/null)"; done
    echo "thp enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled) defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag) use_zero_page: $(cat /sys/kernel/mm/transparent_hugepage/use_zero_page)"
    clang --version | head -1
    perf --version
    cc --version | head -1
} > "$R/host.txt"
cat "$R/trees.txt"
