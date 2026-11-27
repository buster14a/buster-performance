#!/bin/bash
# Run under the repository's 9700X lock, with EXCLUSIVE_OWNER, EXCLUSIVE_TITLE and EXCLUSIVE_LINK set.
set -euo pipefail
repo=${1:?Usage: replay.sh BUSTER_CHECKOUT OUTPUT_DIRECTORY}
out=${2:?Usage: replay.sh BUSTER_CHECKOUT OUTPUT_DIRECTORY}
record=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$out"
for side in baseline final; do
    case "$side" in
        baseline) rev=6ac6c1d5ac0019ab1f50c34a8f1a8d5a4d3a8e03 ;;
        final) rev=0be90947185f3a07791d90e91543aa10937ccdc1 ;;
    esac
    {
        echo '#include <stdint.h>'
        echo '#include <immintrin.h>'
        echo '#define BUSTER_LIKELY(x) __builtin_expect(!!(x), 1)'
        echo '#define BUSTER_REFINE_WINDOW_BYTES 128'
        git -C "$repo" show "$rev:src/buster/compiler/c_refine.c" |
            awk -v side="$side" '/^BUSTER_INLINE uint32_t refine_newlines_before\(/ { copy=1 }
                copy { sub(/^BUSTER_INLINE uint32_t refine_newlines_before\(/, "uint32_t " side "("); print }
                /^\}/ { copy=0 }'
    } > "$out/$side.c"
done
lock=$HOME/buster-fast-bench/exclusive.sh
clang=$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin/clang
"$lock" timeout 45 "$clang" -march=znver5 -O3 -fno-strict-aliasing -fwrapv -funsigned-char "$record/gate.c" "$out/baseline.c" "$out/final.c" -o "$out/gate"
"$lock" timeout 90 taskset -c 2 "$out/gate" > "$out/samples.tsv"
