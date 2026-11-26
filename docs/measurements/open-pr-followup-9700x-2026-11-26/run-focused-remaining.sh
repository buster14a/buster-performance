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
checkout() {
    local side=$1 sha=$2
    if [[ ! -d "$side/.git" ]]; then
        git init -q "$side"
        git -C "$side" remote add origin https://github.com/buster14a/buster.git
        git -C "$side" fetch -q --depth=1 origin "$sha"
        git -C "$side" checkout -q --detach FETCH_HEAD
    fi
    [[ "$(git -C "$side" rev-parse HEAD)" == "$sha" ]]
}
build() {
    local side=$1
    if [[ ! -x "$side/build/compiler" ]]; then
        (cd "$side" && lock_run taskset -c 0-7 ./build.sh --config Release --jobs 8) > "build-$side.txt" 2>&1
    fi
    sha256sum "$side/build/compiler"
}
side="pr$1"
out="$PWD/followup-9700x/$1"
for i in $(seq 1 300); do
    if [[ -x "$side/build/compiler" ]]; then break; fi
    if [[ -e "$out/build-failed" ]]; then exit 1; fi
    sleep 4
done
test -x "$side/build/compiler"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/$1"
export EXCLUSIVE_TITLE="Focused 9700X workload for Buster PR $1"
if lock_run bash "./focused-$1.sh" > "$out/focused.log" 2>&1; then
    touch "$out/focused-done"
else
    touch "$out/focused-failed"
fi
