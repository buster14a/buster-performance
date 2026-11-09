#!/bin/bash
set -eu
cd "$HOME/buster-fast-bench/1383-struct-codex"
{
    date -u +%FT%TZ
    uname -srvm
    clang --version
    lscpu | grep -E 'Architecture:|Model name:|CPU family:|Model:|Stepping:|Socket|Core|Thread'
    head -1 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    printf 'base-source: '
    git -C base rev-parse HEAD
    printf 'candidate-source: '
    git -C final rev-parse HEAD
    printf 'base-worktree-status:\n'
    git -C base status --short
    printf 'candidate-worktree-status:\n'
    git -C final status --short
    printf 'initial-validation-source: '
    git -C pr rev-parse HEAD
    sha256sum base/build/compiler final/build/compiler bin/base bin/head measure_struct_tables measure_struct_tables.c measure.sh validate.sh
} > receipt.txt
