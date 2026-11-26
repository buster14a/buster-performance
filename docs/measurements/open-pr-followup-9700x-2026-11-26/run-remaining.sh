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
root="$PWD"
out="$root/followup-9700x"
mkdir -p "$out"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster
export EXCLUSIVE_TITLE="Baseline compiler for remaining PRs"
for side in base base3652 base3597; do test -x "$side/build/compiler"; done
while read -r number sha baseline; do
    side="pr$number"
    export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/$number"
    export EXCLUSIVE_TITLE="Paired 9700X compile for Buster PR $number"
    mkdir -p "$out/$number"
    if (checkout "$side" "$sha"; build "$side"); then
        if lock_run bash ./measure-remaining.sh "$number" "$side" "$baseline" > "$out/$number/run.log" 2>&1; then
            touch "$out/$number/done"
        else
            touch "$out/$number/failed"
        fi
    else
        touch "$out/$number/build-failed"
    fi
    cp "build-$side.txt" "$out/$number/build.log" || true
done < remaining-pairs.txt
touch "$out/finished"
