#!/usr/bin/env bash
# Original #613 reproduction glue. Run from a directory containing base/ and final/ source archives.
set -euo pipefail
root=$(pwd)
evidence=${1:?path to this evidence directory}
mkdir -p inputs logs objects
export EXCLUSIVE_OWNER=codex-613
export EXCLUSIVE_TITLE='Issue 613 ABI scheduling qualification'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/613
lock="$HOME/buster-fast-bench/exclusive.sh"
if [[ ${BUSTER_613_PREPARED_INPUTS-0} != 1 ]]; then
    if [[ ! -x generate ]]; then
        "$lock" clang -O2 -Wall -Wextra -Werror "$evidence/generate.c" -o generate
    fi
    for shape in chain reverse wide large-chain; do
        for body in empty body; do
            for count in 2000 4000 8000 16000; do
                ./generate "$shape" "$count" "$body" > "inputs/$shape-$body-$count.c"
            done
        done
    done
fi
sha256sum inputs/*.c > logs/input-sha256.txt
{
    date -u
    uname -a
    lscpu
    clang --version
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    cat /sys/devices/system/cpu/cpu10/online
    sha256sum base/build/compiler final/build/compiler
} > logs/identity.txt
lists=()
for shape in chain reverse wide large-chain; do
    for body in empty body; do
        for count in 2000 4000 8000 16000; do
            lists+=(--list --lanes 1 -c "$root/inputs/$shape-$body-$count.c" -o "$root/objects/timed.o")
        done
    done
done
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
sha256sum "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" > logs/sqlite-input-sha256.txt
lists+=(--list --lanes 1 -c "${source[@]}" -o "$root/objects/sqlite-timed.o")
"$lock" taskset -c 2 ./final/build/compiler time-runs --runs 5 --warmups 1 --copies 3 --directory "$root" \
    --build base "$root/base/build/compiler" --build head "$root/final/build/compiler" "${lists[@]}" > logs/scaling.txt 2>&1
if [[ ! -x verify ]]; then
    "$lock" clang -O2 -Wall -Wextra -Werror "$evidence/verify.c" -o verify
fi
"$lock" taskset -c 2 ./verify "$root/base/build/compiler" "$root/final/build/compiler" "$root" > logs/object-comparison.txt 2>&1
if [[ ${BUSTER_613_KERNELS_SEPARATE-0} != 1 ]]; then
    ./final/build/compiler ab --rounds 3 --cpu 2 --lock "$lock" "$root/base" "$root/final" -- \
        benchmark-calling-convention --only classification --path vector > logs/kernel-sustained.txt 2>&1
    ./final/build/compiler ab --rounds 3 --cpu 2 --lock "$lock" "$root/base" "$root/final" -- \
        benchmark-calling-convention --only classification --path vector --after-scalar 100 > logs/kernel-after-scalar.txt 2>&1
fi
