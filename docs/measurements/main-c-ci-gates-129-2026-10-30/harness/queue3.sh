#!/usr/bin/env bash
# solve-126: --symbols' comparisons of main.c and of musl's eight CI directories, main's binary against head's, on
# main's tree, three interleaved rounds. Each run takes its own hold of the 9700X's lock and is timed inside it,
# pinned to CPU 2; its log's TIMING line has its status and milliseconds.
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
timed()
{
    local name=$1 binary=$2
    shift 2
    (cd "$main" && "$lock" bash -c 'name=$1; shift; start=$(date +%s%N); taskset -c 2 "$@"; status=$?; end=$(date +%s%N)
        printf "TIMING %s status=%s ms=%s\n" "$name" "$status" "$(( (end - start) / 1000000 ))"; exit "$status"' timed "$name" "$binary" "$@") > "run3-$name.log" 2>&1
    grep -h "^TIMING" "run3-$name.log" >> status3.log
}
mapfile -t flags < flags.txt
musl="$corpus/libc/musl"
musl_arguments=(--symbols-minimum 354 --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe
  -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include"
  "$musl/src/math" "$musl/src/string" "$musl/src/stdlib" "$musl/src/fenv" "$musl/src/legacy" "$musl/src/process" "$musl/src/signal" "$musl/src/multibyte")
for round in 6 7 8; do
    if [ $((round % 2)) = 1 ]; then order=("$main" "$head"); else order=("$head" "$main"); fi
    for tree in "${order[@]}"; do
        timed "symbols-main.c-${tree%%-*}-$round" "$here/$tree/build/compiler" test-checker-corpus --clang clang --symbols-minimum 1 "${flags[@]}" src/buster/compiler/main.c
        timed "symbols-musl-${tree%%-*}-$round" "$here/$tree/build/compiler" test-checker-corpus --clang clang "${musl_arguments[@]}"
    done
done
echo done >> status3.log
