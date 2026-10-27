#!/usr/bin/env bash
set -eu
root="$HOME/buster-fast-bench/codex-602-20261027"
cd "$root"
clang -std=c17 -O2 -Wall -Wextra -Werror evidence/generate.c -o generate
clang -std=c17 -O2 -Wall -Wextra -Werror evidence/measure.c -o measure
mkdir -p inputs
for kind in pointer record; do
    for form in expression constant; do
        for count in 256 512 1024 2048 4096 8192 10000; do
            path="inputs/"$kind"_"$form"_"$count".c"
            ./generate "$kind" "$count" "$form" > "$path"
            clang -std=gnu17 -fsyntax-only "$path"
        done
    done
done
sha256sum inputs/*.c > evidence/inputs.sha256
{
    date -u
    uname -a
    lscpu
    clang --version
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
    sha256sum base/build/compiler head/build/compiler
    sha256sum /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
} > evidence/host.txt
