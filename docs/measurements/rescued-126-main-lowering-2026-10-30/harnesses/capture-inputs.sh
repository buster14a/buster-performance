#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See Buster's LICENSE and LICENSING.md.
# Run under one host lock from the frozen checkout, before timing.
set -euo pipefail
[[ $# == 1 ]]
evidence=$(realpath "$1")
sha256sum --check --status "$evidence/source.sha256"
./build.sh print-compile-flags > "$evidence/compile-flags.argv0"
./build.sh print-sources > "$evidence/build-sources.argv0"
mapfile -d '' -t flags < "$evidence/compile-flags.argv0"
printf '%q ' "${flags[@]}" > "$evidence/compile-flags.shell"
printf '\n' >> "$evidence/compile-flags.shell"
{
    uname -a
    lscpu
    for path in /sys/devices/system/cpu/online /sys/devices/system/cpu/cpu2/topology/thread_siblings_list /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/microcode/version; do
        printf '%s: ' "$path"
        cat "$path"
    done
    clang --version
    sha256sum "$(command -v clang)"
    ld.lld --version
    if command -v wild >/dev/null; then wild --version; sha256sum "$(command -v wild)"; fi
    printf 'host=znver5 debug=0 sanitizer=none fuzz=0 linker=auto source_date_epoch=%s\n' "$SOURCE_DATE_EPOCH"
} > "$evidence/host-toolchain.txt"
clang -E -CC -MD -MF "$evidence/main.d" "${flags[@]}" src/buster/compiler/main.c > "$evidence/main.preprocessed.c"
sha256sum "$evidence/main.preprocessed.c" > "$evidence/main.preprocessed.sha256"
gzip -n -9 "$evidence/main.preprocessed.c"
# All paths in this frozen checkout, staged toolchain and /usr include tree contain no spaces. Keep the original
# Make dependency file as the authoritative inventory; record a sorted copy for file-digest reproduction.
sed -e ':join' -e '/\\$/ {N; s/\\\n/ /; b join; }' -e 's/^[^:]*: //' "$evidence/main.d" |
    tr ' ' '\n' | sed '/^$/d' | LC_ALL=C sort -u > "$evidence/main-inputs.txt"
while IFS= read -r path; do sha256sum -- "$path"; done < "$evidence/main-inputs.txt" > "$evidence/main-inputs.sha256"
sha256sum build/compiler > "$evidence/compiler.sha256"
sha256sum --check --status "$evidence/source.sha256"
