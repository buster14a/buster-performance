#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
inputs=/home/david/buster-fast-bench/deferred-lanes-claude
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
printf 'base commit: 31c4ced26abcf0393e8c8f4f138e42dfe1952ee4\nhead commit: d4db297d122fc4be18c4cf245dd1462439d884d0\n'
sha256sum base450-final.tar head450-phase.tar base450-final/build/compiler head450-phase/build/compiler
printf 'online CPUs: '; cat /sys/devices/system/cpu/online
grep Cpus_allowed_list /proc/self/status
clang --version
for setting in scaling_driver scaling_governor scaling_min_freq scaling_max_freq; do
    printf '%s: ' "$setting"
    cat "/sys/devices/system/cpu/cpu2/cpufreq/$setting"
done
sha256sum "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt"
find "$inputs/c-testsuite/tests/single-exec" -type f -name '*.c' -print0 | sort -z | xargs -0 sha256sum
for unit in 00001.c 00169.c 00213.c 00200.c 00182.c 00204.c; do
    cmp "$inputs/inputs/$unit" "$inputs/c-testsuite/tests/single-exec/$unit"
done
