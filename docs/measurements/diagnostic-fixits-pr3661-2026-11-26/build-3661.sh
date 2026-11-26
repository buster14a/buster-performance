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
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3661
root=$PWD
out="$root/diagnostics-3661"
mkdir -p "$out"
{
    date -u -Is
    uname -n
    clang --version
    grep -m1 '^model name' /proc/cpuinfo
} > "$out/host.txt"
checkout_build() {
    local side=$1 sha=$2
    if [[ ! -d "$side/.git" ]]; then
        git init -q "$side"
        git -C "$side" remote add origin https://github.com/buster14a/buster.git
    fi
    if [[ "$(git -C "$side" rev-parse HEAD 2>/dev/null || true)" != "$sha" ]]; then
        git -C "$side" fetch -q --depth=1 origin "$sha"
        git -C "$side" checkout -q --detach FETCH_HEAD
    fi
    [[ "$(git -C "$side" rev-parse HEAD)" == "$sha" ]]
    export EXCLUSIVE_TITLE="PR 3661 $side Release build"
    if [[ ! -x "$side/build/compiler" ]]; then
        (cd "$side" && lock_run taskset -c 0-7 ./build.sh --config Release --jobs 8) > "$out/build-$side.log" 2>&1
    fi
    printf '%s=%s\n' "$side" "$sha" >> "$out/identity.txt"
    sha256sum "$side/build/compiler" >> "$out/identity.txt"
}
checkout_build base3661 8cfefb2dccc92c754092cd3ce9a0eafa62c6bdca
checkout_build pr3661 dd308d43064fcb349ed8fb2ac06996d474c6c1bc
touch "$out/build-done"
