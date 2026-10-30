#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
source "$(dirname "$0")/environment.sh"
cd "$Q"
mkdir -p evidence/objects evidence/diagnostics
uname -a
sed -n '1,28p' /proc/cpuinfo
cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/kernel/mm/transparent_hugepage/enabled
clang --version
/usr/bin/wild --version
perf --version
sha256sum "$CORPUS/MANIFESTS.sha256" "$CORPUS/manifests/sqlite.sha256" "$CORPUS/provenance/gnu17-pinned-predefines.txt"
(cd "$CORPUS/headers" && sha256sum --check --status "$CORPUS/manifests/headers-bundle.sha256")
(cd "$CORPUS/sqlite" && sha256sum --check --status "$CORPUS/manifests/sqlite.sha256")
for variant in base candidate; do
    for placement in normal 0 64 512; do
        root="$Q/hot-$variant-$placement"
        if [ "$placement" = normal ]; then root="$Q/$variant"; fi
        executable="$root/build/compiler"
        sha256sum "$executable"
        for mode in vector scalar; do
            args=()
            if [ "$mode" = scalar ]; then args=(--scalar); fi
            output="evidence/objects/$variant-$placement-$mode.o"
            errors="evidence/diagnostics/$variant-$placement-$mode.accepted.txt"
            taskset -c 2 "$executable" "${args[@]}" -c "${sqlite[@]}" -o "$output" > /dev/null 2> "$errors"
            cmp evidence/objects/base-normal-vector.o "$output"
            cmp evidence/diagnostics/base-normal-vector.accepted.txt "$errors"
            status=0
            taskset -c 2 "$executable" "${args[@]}" -fsyntax-only "${common[@]}" "$Q/scripts/diagnostic.c" > /dev/null 2> "evidence/diagnostics/$variant-$placement-$mode.rejected.txt" || status=$?
            test "$status" = 1
            cmp evidence/diagnostics/base-normal-vector.rejected.txt "evidence/diagnostics/$variant-$placement-$mode.rejected.txt"
            echo "parity PASS $variant $placement $mode"
        done
    done
done
sha256sum evidence/objects/*.o evidence/diagnostics/*
