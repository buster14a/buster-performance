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
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3652
sha=$1
root="$PWD"
side=pr3652-merge2
out="$root/qualify-3652-v3"
mkdir -p "$out"
git init -q "$side"
if ! git -C "$side" remote get-url origin > /dev/null; then git -C "$side" remote add origin https://github.com/buster14a/buster.git; fi
git -C "$side" fetch -q --depth=1 origin "$sha"
git -C "$side" checkout -q --detach FETCH_HEAD
[[ "$(git -C "$side" rev-parse HEAD)" == "$sha" ]]
export EXCLUSIVE_TITLE='PR 3652 integrated assembly Release build'
cd "$side"
lock_run taskset -c 0-7 ./build.sh --config Release --jobs 8 > "$out/build.log" 2>&1
for workload in assembly-output tier1-asm program-asm; do
    export EXCLUSIVE_TITLE="PR 3652 $workload correctness"
    status=0
    case "$workload" in
        assembly-output)
            wrapper=$(mktemp -d "$out/as-wrapper.XXXXXX")
            install -m 755 "$root/assembler-3648-no-compression.sh" "$wrapper/as"
            PATH="$wrapper:$PATH" lock_run taskset -c 2 ./build/compiler test-assembly-output --cross-check --c-testsuite "$root/c-testsuite" --subset tests/c-testsuite/subset.txt > "$out/$workload.log" 2>&1 || status=$?
            rm -rf "$wrapper"
            ;;
        tier1-asm)
            lock_run taskset -c 2 ./build/compiler test-checker-driver --executable "$PWD/build/compiler" --tier1-asm-only --in-process > "$out/$workload.log" 2>&1 || status=$?
            ;;
        program-asm)
            lock_run taskset -c 2 ./build/compiler test-checker --program-asm > "$out/$workload.log" 2>&1 || status=$?
            ;;
    esac
    printf '%s %s\n' "$workload" "$status" >> "$out/status.tsv"
done
touch "$out/finished"
