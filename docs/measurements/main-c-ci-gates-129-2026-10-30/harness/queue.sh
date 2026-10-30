#!/usr/bin/env bash
# solve-126: builds main and head, then times main.c's new CI commands and --symbols' comparisons before and after
# the reasons' index. Every build and timed run takes the 9700X's lock separately; timed runs are pinned to CPU 2.
set -uo pipefail
here=$(cd "$(dirname "$0")" && pwd)
cd "$here"
toolchain=/home/david/buster-fast-bench/codex-rescue-126/toolchain-stage/cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export PATH="$toolchain/bin:$PATH" LD_LIBRARY_PATH="$toolchain/lib"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE BUSTER_HOST_RUNTIME BUSTER_FUZZ_ENTRY BUSTER_SANITIZER BUSTER_FUZZ_AVAILABLE
export EXCLUSIVE_OWNER=claude-solve-126 EXCLUSIVE_TITLE='solve 126: main.c CI commands' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/126
lock=/home/david/buster-fast-bench/exclusive.sh
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
main=main-d12fd583
head=head-28a9c925
{
    date -u; uname -a; clang --version | head -1; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference 2>/dev/null; grep -m1 "model name" /proc/cpuinfo
} > receipts.txt
for tree in "$main" "$head"; do
    (cd "$tree" && "$lock" taskset -c 0-7 ./build.sh > ../build-"$tree".log 2>&1; echo "build $tree status=$?" >> ../status.log)
    sha256sum "$tree"/build/compiler >> receipts.txt
done
# One timed run: a name, the tree to run in and the binary, then the command's arguments.
timed()
{
    local name=$1 tree=$2 binary=$3
    shift 3
    local start end status
    start=$(date +%s%N)
    (cd "$tree" && "$lock" taskset -c 2 "$binary" "$@") > "run-$name.log" 2>&1
    status=$?
    end=$(date +%s%N)
    printf '%s status=%s ms=%s\n' "$name" "$status" "$(( (end - start) / 1000000 ))" >> status.log
}
mapfile -d '' -t flags < <(cd "$main" && env -u BUSTER_SANITIZER_OPTIMIZATION BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags)
printf '%s\n' "${flags[@]}" > flags.txt
musl="$corpus/libc/musl"
musl_arguments=(--symbols-minimum 354 --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe
  -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include"
  "$musl/src/math" "$musl/src/string" "$musl/src/stdlib" "$musl/src/fenv" "$musl/src/legacy" "$musl/src/process" "$musl/src/signal" "$musl/src/multibyte")
for round in 1 2 3; do
    if [ $((round % 2)) = 1 ]; then order=("$main" "$head"); else order=("$head" "$main"); fi
    for tree in "${order[@]}"; do
        side=${tree%%-*}
        # Both binaries read main's main.c, the same input; each finds its own headers, which are main's.
        timed "symbols-main.c-$side-$round" "$main" "$here/$tree/build/compiler" test-checker-corpus --clang clang --symbols-minimum 1 "${flags[@]}" src/buster/compiler/main.c
        timed "symbols-musl-$side-$round" "$main" "$here/$tree/build/compiler" test-checker-corpus --clang clang "${musl_arguments[@]}"
    done
done
# The head's new commands, as its list has them, each in one hold.
awk '/^== /{keep = ($0 ~ /^== Compare main.c|^== Compile main.c/)} keep' "$head/tools/ci/correctness.tests" > main-gates.tests
for round in 1 2; do
    (cd "$head" && "$lock" taskset -c 2 ./build/compiler parallel --jobs 1 --timeout 600 < ../main-gates.tests) > "run-gates-$round.log" 2>&1
    echo "gates $round status=$?" >> status.log
done
echo done >> status.log
