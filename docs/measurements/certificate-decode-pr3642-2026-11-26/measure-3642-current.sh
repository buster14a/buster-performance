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
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3642
root=$PWD
out="$root/measure-3642-current"
mkdir -p "$out"
declare -A commits=(
    [base]=44cf35e195eb73e7306f13882ef15b2d9b301c4d
)
commits[head]=$1
for side in base head; do
    worktree="pr3642-exact-$side"
    git init -q "$worktree"
    if ! git -C "$worktree" remote get-url origin >/dev/null; then
        git -C "$worktree" remote add origin https://github.com/buster14a/buster.git
    fi
    git -C "$worktree" fetch -q --depth=1 origin "${commits[$side]}"
    git -C "$worktree" checkout -q --detach FETCH_HEAD
    [[ $(git -C "$worktree" rev-parse HEAD) == "${commits[$side]}" ]]
    export EXCLUSIVE_TITLE="PR 3642 current $side Release build"
    (cd "$worktree" && lock_run taskset -c 0-7 ./build.sh --config Release --jobs 8) > "$out/build-$side.log" 2>&1
    printf '%s %s\n' "$side" "${commits[$side]}" >> "$out/identity.txt"
    sha256sum "$worktree/build/compiler" >> "$out/identity.txt"
done
uname -srnm >> "$out/identity.txt"
grep -m1 '^model name' /proc/cpuinfo >> "$out/identity.txt"
clang --version >> "$out/identity.txt"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$corpus/sqlite/sqlite3.c" | sha256sum --check >> "$out/identity.txt"
args=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for round in {1..5}; do
    order=(base head)
    if (( round % 2 == 0 )); then order=(head base); fi
    for side in "${order[@]}"; do
        export EXCLUSIVE_TITLE="PR 3642 SQLite certificate pair $round $side"
        lock_run taskset -c 2 "$root/pr3642-exact-$side/build/compiler" benchmark-tier1-code-certificate "${args[@]}" > "$out/$round-$side.txt" 2>&1
    done
done
touch "$out/finished"
