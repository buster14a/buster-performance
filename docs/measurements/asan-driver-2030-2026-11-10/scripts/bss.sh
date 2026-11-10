#!/bin/bash
# LeakSanitizer's exit scan per MB of .bss: a program with an untouched static array of MB megabytes, built with CI's
# address row's flags at a fixed address, run 50 times with the leak check on and off.
set -u
export LC_ALL=C
cd "$(dirname "$0")" || exit 2
for mb in 16 64 128 256; do
    {
        echo '#include <stdio.h>'
        echo "static char big[(size_t)$mb * 1048576];"
        echo 'int main(int argc, char** argv) { (void)argv; big[argc] = 1; return big[argc + 1]; }'
    } > "b$mb.c"
    clang -O3 -fsanitize=address,undefined,bounds -fsanitize-address-use-after-scope \
        -fsanitize-address-use-after-return=always -fno-sanitize-recover=all -no-pie "b$mb.c" -o "b$mb" || exit 1
done
TIMEFORMAT='%R'
for mb in 16 64 128 256; do
    for leaks in 1 0; do
        t=$( { time for ((i = 0; i < 50; i++)); do ASAN_OPTIONS=detect_leaks=$leaks "./b$mb"; done; } 2>&1 )
        echo "bss=${mb}MB leaks=$leaks per-run-ms=$(echo "$t" | awk '{printf "%.2f", $1 * 1000 / 50}')"
    done
done
