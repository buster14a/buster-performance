#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
inputs=/home/david/buster-fast-bench/deferred-lanes-claude
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
printf 'base commit: 35f26f68d7caa9bf5f6248822100a51c06e2c878\nhead commit: 1d2b12c658807f466b989bcdfe2cdf548c1812d5\n'
sha256sum base450-cold.tar head450-cold.tar base450-cold/build/compiler head450-cold/build/compiler
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
