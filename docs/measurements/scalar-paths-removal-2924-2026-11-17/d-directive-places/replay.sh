#!/bin/bash
# Run on benchpress with the normal 9700X lock metadata in the environment.
set -euo pipefail
repo=${1:?Usage: replay.sh BUSTER_CHECKOUT OUTPUT_DIRECTORY}
out=${2:?Usage: replay.sh BUSTER_CHECKOUT OUTPUT_DIRECTORY}
record=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$out"
for side in base head; do
    case "$side" in
        base) rev=6ac6c1d5ac0019ab1f50c34a8f1a8d5a4d3a8e03 ;;
        head) rev=1cf8a0cb3cbc57a25ab1dc81ac21bf3ddd6acfc2 ;;
    esac
    {
        echo '#include <stdint.h>'
        echo '#include <immintrin.h>'
        echo '#define BUSTER_UNLIKELY(x) __builtin_expect(!!(x), 0)'
        git -C "$repo" show "$rev:src/buster/compiler/c_preprocessor.c" |
            awk -v side="$side" '/^static uint32_t pp_directive_places(_scalar)?\(/ { copy = 1 }
                /^\/\/ pp_directive_table for a file prepared/ { copy = 0 }
                copy { sub(/^static uint32_t pp_directive_places\(/, "uint32_t " side "("); print }'
    } > "$out/$side.c"
done
lock=$HOME/buster-fast-bench/exclusive.sh
clang=$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin/clang
"$lock" timeout 60 "$clang" -O3 -march=znver5 -fno-strict-aliasing -funsigned-char -fwrapv "$out/base.c" "$out/head.c" "$record/gate.c" -o "$out/gate"
"$lock" timeout 75 taskset -c 2 "$out/gate" > "$out/samples.tsv"
