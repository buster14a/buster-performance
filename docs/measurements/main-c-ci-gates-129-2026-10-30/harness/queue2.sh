#!/usr/bin/env bash
# solve-126: two more interleaved rounds of main.c's --symbols comparison, main's binary against head's, on main's
# main.c, each run under its own hold of the 9700X's lock, pinned to CPU 2.
set -uo pipefail
here=$(cd "$(dirname "$0")" && pwd)
cd "$here"
toolchain=/home/david/buster-fast-bench/codex-rescue-126/toolchain-stage/cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export PATH="$toolchain/bin:$PATH" LD_LIBRARY_PATH="$toolchain/lib"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE BUSTER_HOST_RUNTIME BUSTER_FUZZ_ENTRY BUSTER_SANITIZER BUSTER_FUZZ_AVAILABLE
export EXCLUSIVE_OWNER=claude-solve-126 EXCLUSIVE_TITLE='solve 126: main.c CI commands' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/126
lock=/home/david/buster-fast-bench/exclusive.sh
main=main-d12fd583
head=head-28a9c925
timed()
{
    local name=$1 tree=$2 binary=$3
    shift 3
    local start end status
    start=$(date +%s%N)
    (cd "$tree" && "$lock" taskset -c 2 "$binary" "$@") > "run-$name.log" 2>&1
    status=$?
    end=$(date +%s%N)
    printf '%s status=%s ms=%s\n' "$name" "$status" "$(( (end - start) / 1000000 ))" >> status2.log
}
mapfile -t flags < flags.txt
for round in 4 5; do
    if [ $((round % 2)) = 1 ]; then order=("$main" "$head"); else order=("$head" "$main"); fi
    for tree in "${order[@]}"; do
        timed "symbols-main.c-${tree%%-*}-$round" "$main" "$here/$tree/build/compiler" test-checker-corpus --clang clang --symbols-minimum 1 "${flags[@]}" src/buster/compiler/main.c
    done
done
echo done >> status2.log
