#!/bin/bash
# Per-process ASan costs without transparent huge pages (as on a host whose THP setting is madvise): small -c compiles
# by the PIE and the fixed-address baked executables, with and without the leak check, and the synthetic .bss programs.
set -u
export LC_ALL=C
cd "$(dirname "$0")" || exit 2
N=./tools/nothp
$N ./percallc.sh nothp-pie ./compiler-asan 40
$N ./percallc.sh nothp-pie-noleaks ./compiler-asan 40 detect_leaks=0
$N ./percallc.sh nothp-nopie-baked ./compiler-asan-nopie-baked 40
$N ./percallc.sh nothp-nopie-baked-noleaks ./compiler-asan-nopie-baked 40 detect_leaks=0
cd bss || exit 2
TIMEFORMAT='%R'
for mb in 16 256; do
    for leaks in 1 0; do
        t=$( { time for ((i = 0; i < 50; i++)); do ASAN_OPTIONS=detect_leaks=$leaks ../tools/nothp "./b$mb"; done; } 2>&1 )
        echo "nothp bss=${mb}MB leaks=$leaks per-run-ms=$(echo "$t" | awk '{printf "%.2f", $1 * 1000 / 50}')"
    done
done
