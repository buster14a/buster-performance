#!/usr/bin/env bash
set -euo pipefail
compiler=$(realpath "$1")
out=$(realpath -m "$2")
mkdir -p "$out"
root=$PWD
expected_passes=${3:?pass 0 for an uninstrumented build, 2 or 3 for traced builds}
run()
{
    local label=$1
    shift
    local status=0
    BUSTER_DEPENDENCY_TRACE=1 "$compiler" "$@" > "$out/$label.out" 2> "$out/$label.err" || status=$?
    printf '%s status=%d\n' "$label" "$status"
    cat "$out/$label.err"
    test "$status" -eq 0
    local dep="$out/$label.out"
    if [[ -f "$label.d" ]]; then dep="$label.d"; cp "$dep" "$out/$label.dep"; fi
    wc -c "$dep"
    sha256sum "$dep"
    awk -v expected="$expected_passes" '/^DEP_PASS / { passes++; split($3,a,"="); visited+=a[2]; split($4,b,"="); quoted+=b[2] } END { printf "TOTAL passes=%d visited=%d quoted=%d\n",passes,visited,quoted; exit (passes != expected) }' "$out/$label.err"
}
run real -M -MP tools/performance/main.c
run example -c -MD -MP -MF example.d examples/assembler/compiler-corpus.c -o example.o
cp example.o "$out/example.o"
scratch=$(mktemp -d)
cd "$scratch"
mkdir headers
for ((i=0;i<512;i++)); do
    printf -v h 'h%03d.h' "$i"
    printf '#define VALUE_%d %d\n' "$i" "$i" > "headers/$h"
    printf '#include "headers/%s"\n' "$h" >> all.c
done
printf 'int answer(void) { return VALUE_511; }\n' >> all.c
run stress -M -MP all.c
run stress_md -c -MMD -MP -MF stress_md.d all.c -o all.o
cp all.o "$out/stress.o"
{
    printf 'all.o: all.c'
    for ((i=0;i<512;i++)); do printf ' headers/h%03d.h' "$i"; done
    printf '\n'
    for ((i=0;i<512;i++)); do printf 'headers/h%03d.h:\n' "$i"; done
} > expected.d
cmp expected.d "$out/stress.out"
cmp expected.d "$out/stress_md.dep"
clang -M -MP all.c > clang.d
# These generated names contain no escapes. Remove only Clang's physical line continuations.
sed -z 's/[[:blank:]]*\\\n[[:blank:]]*/ /g' clang.d > clang-unwrapped.d
cmp expected.d clang-unwrapped.d
cd "$root"
