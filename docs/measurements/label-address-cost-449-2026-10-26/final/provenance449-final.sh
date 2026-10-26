#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
printf 'base commit: 9de3d30ba437b381394095d7a77635a2e877435d\nhead commit: f7af14f10cfb38fcbc384dcb2584ed846fe33860\n'
sha256sum base.tar head449-final.tar base/build/compiler head449-final/build/compiler label-dispatch-128.c
sha256sum "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt"
find /home/david/buster-fast-bench/x87-136/lua -type f \( -name '*.c' -o -name '*.h' -o -name '*.hpp' \) -print0 | sort -z | xargs -0 sha256sum
printf 'online CPUs: '; cat /sys/devices/system/cpu/online
clang --version
for setting in scaling_driver scaling_governor scaling_min_freq scaling_max_freq; do
    printf '%s: ' "$setting"
    cat "/sys/devices/system/cpu/cpu2/cpufreq/$setting"
done
