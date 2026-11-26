#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/pr-numbers-codex-6b0809fc"
bench="$HOME/buster-fast-bench"
clang_root="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378"
tools_root="$HOME/.cache/buster/build-tools/cmake-4.4.3-ninja-1.13.2"
export PATH="$clang_root/bin:$tools_root/bin:$PATH"
export LD_LIBRARY_PATH="$clang_root/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export BUSTER_CLANG_RESOURCE_DIR="$clang_root/lib/clang/23"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
export EXCLUSIVE_OWNER=codex-6b0809fc
export LC_ALL=C
clang --version
grep -Em1 '^model name[[:space:]]*:[[:space:]]*AMD Ryzen 7 9700X([[:space:]]|$)' /proc/cpuinfo
lock_run() {
    "$bench/exclusive.sh" timeout -k 5 420 "$@"
}
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3662
out="$PWD/upper-vectors-3662"
for attempt in $(seq 1 600); do
    if [[ -e "$out/build-done" ]]; then break; fi
    if systemctl --user is-failed --quiet codex-3662-build-6b0809fc.service; then exit 1; fi
    sleep 2
done
test -e "$out/build-done"
for mode in default tier1 lexer programs-build programs-0 programs-16 programs-32 programs-48; do
    export EXCLUSIVE_TITLE="PR 3662 $mode benchmark"
    if lock_run bash ./measure-3662.sh "$mode" > "$out/$mode-run.log" 2>&1; then
        touch "$out/$mode-done"
    else
        touch "$out/$mode-failed"
    fi
done
touch "$out/finished"
