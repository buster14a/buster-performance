#!/bin/bash
# #872: the record's manifests: each tree's source manifest, the binaries, the inputs and the host.
set -e
D=/home/david/buster-fast-bench/872-qual-20261101
R="$D/record"
mkdir -p "$R/tables" "$R/analysis" "$R/scripts" "$R/logs"
cp "$D/scripts/env.sh" "$D/scripts/build.sh" "$D/scripts/runs.sh" "$D/scripts/perf.sh" "$R/scripts/"
cp "$D/logs/builds.txt" "$D/logs/runs.txt" "$D/logs/perf.txt" "$D/logs/perf-post.txt" "$R/logs/"
: > "$R/trees.txt"
for tree in "$D"/trees/*; do
    name=$(basename "$tree")
    ( cd "$tree" && { sha256sum build.sh; find src -type f -print0 | sort -z | xargs -0 sha256sum; } > "$R/source-$name.sha256" )
    manifest=$(sha256sum "$R/source-$name.sha256" | cut -d' ' -f1)
    files=$(find "$tree/src" -type f | wc -l)
    printf '%s %s %s %s\n' "$name" "$(cat "$tree/COMMIT")" "$manifest" "$files" >> "$R/trees.txt"
done
( cd "$D/trees" && sha256sum */build/compiler ) > "$R/binaries.sha256"
( cd "$D/inputs" && sha256sum c-testsuite/*.c synthetic/*.c ) > "$R/inputs.sha256"
sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c >> "$R/inputs.sha256"
{
    echo "host: $(uname -a)"
    echo "cpu: $(lscpu | sed -n 's/^Model name: *//p')"
    echo "clang: $(clang --version | head -1)"
    echo "gcc: $(gcc --version | head -1)"
    echo "perf: $(perf --version | head -1)"
    echo "thp: $(cat /sys/kernel/mm/transparent_hugepage/enabled) / $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
    echo "governor 2: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null)"
    echo "governors: $(for c in 0 1 2 3 4 5 6 7; do printf '%s=%s ' "$c" "$(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor 2>/dev/null)"; done)"
    echo "corpus: /var/lib/buster-9700x/corpora/preprocessor-391e729af658"
} > "$R/host.txt"
echo done
