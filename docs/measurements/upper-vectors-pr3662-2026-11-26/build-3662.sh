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
export EXCLUSIVE_TITLE='PR 3662 Release build on Ryzen 7 9700X'
root="$PWD"
out="$root/upper-vectors-3662"
mkdir -p "$out"
base=8cfefb2dccc92c754092cd3ce9a0eafa62c6bdca
head=2c3f33bbfbb777f9caf9e40ca137dd607879c509
[[ "$(git -C base3661 rev-parse HEAD)" == "$base" ]]
test -x base3661/build/compiler
git init -q pr3662
if ! git -C pr3662 remote get-url origin > /dev/null; then git -C pr3662 remote add origin https://github.com/buster14a/buster.git; fi
git -C pr3662 fetch -q --depth=1 origin "$head"
git -C pr3662 checkout -q --detach FETCH_HEAD
[[ "$(git -C pr3662 rev-parse HEAD)" == "$head" ]]
(cd pr3662 && lock_run taskset -c 0-7 ./build.sh --config Release --jobs 8) > "$out/build.log" 2>&1
{
    printf 'base=%s\nhead=%s\n' "$base" "$head"
    date -u -Is
    uname -n
    clang --version
    grep -m1 '^model name' /proc/cpuinfo
    sha256sum base3661/build/compiler pr3662/build/compiler
} > "$out/identity.txt"
touch "$out/build-done"
