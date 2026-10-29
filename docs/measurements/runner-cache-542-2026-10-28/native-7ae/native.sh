#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "$0")" && pwd)
CAMPAIGN=/home/david/buster-fast-bench/unclaimed-perf-20261028
TOOL="$CAMPAIGN/toolchain-clang2314/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378"
BASE="$CAMPAIGN/integrated-e7-672-clang2314/compiler-native"
INPUT="$CAMPAIGN/integrated-e7-672-clang2314/source"
export PATH="$TOOL/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"
export LD_LIBRARY_PATH="$TOOL/lib"
export LC_ALL=C TZ=UTC0 SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH

action=${1:?action}
shift
if [[ "$action" == execute ]]; then
    binary=$1
    group=$2
    cd "$INPUT"
    if [[ "$group" == builtins ]]; then
        for command in test-check-builtins-x86 test-check-builtins-vector test-check-builtins \
            test-check-builtins-misc test-check-builtins-query test-check-builtins-bit-cast \
            test-check-builtins-float test-check-builtins-math test-check-builtins-atomic \
            test-check-builtins-atomic-rmw test-check-builtins-typed-overflow test-check-builtins-rounds; do
            printf '\n== %s\n' "$command"
            "$binary" "$command"
        done
    elif [[ "$group" == assembler ]]; then
        "$binary" test-assembler --cross-check
    elif [[ "$group" == cache ]]; then
        "$binary" test-oracle-cache
    else
        printf 'unknown group: %s\n' "$group" >&2
        exit 2
    fi
elif [[ "$action" == build ]]; then
    cd "$ROOT/candidate"
    date -u +%Y-%m-%dT%H:%M:%SZ
    clang --version
    printf 'BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=1\n'
    env BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=1 ./build.sh > "$ROOT/build.log" 2>&1
    tail -n 8 "$ROOT/build.log"
    sha256sum build/compiler "$BASE"
    date -u +%Y-%m-%dT%H:%M:%SZ
elif [[ "$action" == helper ]]; then
    cd "$ROOT"
    clang -std=gnu17 -O2 -Wall -Wextra -Werror native_time.c -o native-time
    sha256sum native_time.c native-time native.sh
    ./native-time helper-smoke.time.json /bin/sh -c 'exit 7' && exit 1 || test "$?" -eq 7
    cat helper-smoke.time.json
elif [[ "$action" == identity ]]; then
    cd "$ROOT"
    date -u +%Y-%m-%dT%H:%M:%SZ
    cat SOURCE.txt
    sha256sum payload.tar "$BASE" "$TOOL/bin/clang-23"
    test ! -e candidate/build/compiler || sha256sum candidate/build/compiler
    clang --version
    gcc --version | head -n 1
    as --version | head -n 1
    ld --version | head -n 1
    uname -a
    lscpu
    printf 'Input cwd: %s\nSOURCE_DATE_EPOCH=%s\nPATH=%s\nLD_LIBRARY_PATH=%s\n' "$INPUT" "$SOURCE_DATE_EPOCH" "$PATH" "$LD_LIBRARY_PATH"
    ldd "$BASE"
    test -d "$INPUT/examples"
elif [[ "$action" == functional || "$action" == trace || "$action" == timing ]]; then
    variant=${1:?variant}
    group=${2:?group}
    mode=${3:?mode}
    label=${4:?label}
    reset=${5:-keep}
    [[ "$variant" == base || "$variant" == candidate ]]
    [[ "$mode" == off || "$mode" == use || "$mode" == check ]]
    [[ "$label" =~ ^[a-zA-Z0-9_-]+$ ]]
    mkdir -p "$ROOT/logs"
    prefix="$ROOT/logs/$label"
    test ! -e "$prefix.log"
    binary="$BASE"
    [[ "$variant" == base ]] || binary="$ROOT/candidate/build/compiler"
    export XDG_CACHE_HOME="$ROOT/cache/$variant-$group"
    if [[ "$reset" == reset ]]; then
        rm -rf -- "$XDG_CACHE_HOME"
    fi
    export BUSTER_ORACLE_CACHE="$mode"
    {
        date -u +%Y-%m-%dT%H:%M:%SZ
        printf 'variant=%s group=%s mode=%s reset=%s\n' "$variant" "$group" "$mode" "$reset"
        printf 'binary=%s\ncwd=%s\ncache=%s\nSOURCE_DATE_EPOCH=%s\n' "$binary" "$INPUT" "$XDG_CACHE_HOME" "$SOURCE_DATE_EPOCH"
        sha256sum "$binary"
    } > "$prefix.method"
    command=(taskset -c 2 timeout --signal=TERM --kill-after=5s 110s bash "$ROOT/native.sh" execute "$binary" "$group")
    if [[ "$action" == trace ]]; then
        command=(strace -f -qq -e trace=execve -s 1000 -o "$prefix.exec" "${command[@]}")
    fi
    status=0
    "$ROOT/native-time" "$prefix.time.json" "${command[@]}" > "$prefix.log" 2>&1 || status=$?
    printf '%s\n' "$status" > "$prefix.status"
    date -u +%Y-%m-%dT%H:%M:%SZ >> "$prefix.method"
    cat "$prefix.method" "$prefix.time.json"
    tail -n 8 "$prefix.log"
    exit "$status"
else
    printf 'unknown action: %s\n' "$action" >&2
    exit 2
fi
