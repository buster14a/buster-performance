#!/usr/bin/env bash
set -euo pipefail

# Use a single Clang driver object for both compilers and both Clang references.
# CPU 2 must already be reserved by the 9700X job hook or benchpress's exclusive lock.
base=$(realpath "${1:?baseline compiler}")
candidate=$(realpath "${2:?candidate compiler}")
here=$(cd "$(dirname "$0")" && pwd)
out=$(realpath -m "${3:?output directory}")
mkdir -p "$out"
cd "$out"
clang -O2 -ffp-contract=off -c "$here/driver.c" -o driver.o
for variant in base0 base1 candidate0 candidate1 clang0 clang2; do
    case "$variant" in
        base0)      "$base" --verify -c "$here/kernels.c" -o "$variant.o" ;;
        base1)      "$base" --verify --tier1 -c "$here/kernels.c" -o "$variant.o" ;;
        candidate0) "$candidate" --verify -c "$here/kernels.c" -o "$variant.o" ;;
        candidate1) "$candidate" --verify --tier1 -c "$here/kernels.c" -o "$variant.o" ;;
        clang0)     clang -O0 -ffp-contract=off -c "$here/kernels.c" -o "$variant.o" ;;
        clang2)     clang -O2 -ffp-contract=off -fno-vectorize -fno-slp-vectorize -c "$here/kernels.c" -o "$variant.o" ;;
    esac
    clang driver.o "$variant.o" -o "$variant"
    objdump -dr "$variant.o" > "$variant.asm"
done
sha256sum "$base" "$candidate" driver.o {base,candidate,clang}*.o
variants=(base0 candidate0 base1 candidate1 clang0 clang2)
for pass in 0 1 2 3 4; do
    for k in 0 1 2; do
        for ((i=0; i<6; ++i)); do
            v=${variants[(i + pass + k) % 6]}
            printf 'sample %s %s %s ' "$v" "$k" "$pass"
            taskset -c 2 "./$v" "$k"
        done
    done
done
if command -v perf >/dev/null && taskset -c 2 perf stat -e cycles:u,ls_bad_status2.stli_other:u -- true; then
    for v in "${variants[@]}"; do
        taskset -c 2 perf stat -x, -o "$v-affine-perf.csv" -e cycles:u,ls_bad_status2.stli_other:u -- "./$v" 0
        cat "$v-affine-perf.csv"
    done
fi
