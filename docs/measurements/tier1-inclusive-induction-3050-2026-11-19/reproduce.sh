#!/usr/bin/env bash
# Run in a Buster checkout containing the pinned base commit, with the hosted Clang on PATH.
set -euo pipefail
if [ "$#" -ne 2 ]; then
    echo 'usage: reproduce.sh BASE_COMPILER HEAD_COMPILER' >&2
    exit 2
fi
record=$(cd -- "$(dirname -- "$0")" && pwd)
base_compiler=$(realpath "$1")
head_compiler=$(realpath "$2")
probe=$(mktemp -d)
trap 'rm -rf -- "$probe"' EXIT
git show b847801169f2b73aed6496c8fa23e9a5499c94e7:src/buster/compiler/tier1_select_ranges.c > "$probe/input.c"
clang -std=c17 -O2 "$record/kernel.c" "$record/oracle.c" -o "$probe/clang"
"$probe/clang" "$probe/input.c" | tee "$probe/clang.run"
for revision in base head; do
    compiler=$base_compiler
    if [ "$revision" = head ]; then
        compiler=$head_compiler
    fi
    printf '\n%s\n' "$revision"
    "$compiler" test-tier1-emit
    "$compiler" --tier1 -c "$record/kernel.c" -o "$probe/plain.o"
    nm -S --size-sort "$probe/plain.o"
    objdump -d "$probe/plain.o"
    "$compiler" --tier1 --tier1-strict --verify --tier1-report -c "$record/kernel.c" -o "$probe/verified.o" 2>&1 | tee "$probe/verified.report"
    grep -qE 'code_certified=7([[:space:]]|$)' "$probe/verified.report"
    grep -qE 'code_uncertified=0([[:space:]]|$)' "$probe/verified.report"
    for product in plain verified; do
        objcopy -O binary --only-section=.text "$probe/$product.o" "$probe/$product.text"
        clang -std=c17 -O2 -no-pie "$record/oracle.c" "$probe/$product.o" -o "$probe/$product.exe"
        "$probe/$product.exe" "$probe/input.c" | tee "$probe/$product.run"
        cmp "$probe/clang.run" "$probe/$product.run"
    done
    cmp "$probe/plain.text" "$probe/verified.text"
done
