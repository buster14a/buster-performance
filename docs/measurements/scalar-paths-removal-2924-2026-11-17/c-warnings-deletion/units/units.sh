#!/bin/bash
# #2924 C12c-2: the warnings' twins (bit 12) by unit size. Each of musl's units, -c --lanes 1, as a command of its own:
# time-runs --runs 3 of no bit, bit 12 and no bit again (the gate's knob executables), one locked run a unit, CPU 2;
# each unit's preprocessed bytes (-E) for the bins.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
G=$D/../c12c
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the warnings by unit size, C12c-2" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
until grep -qx done logs-w/status.txt 2>/dev/null; do sleep 30; done
mkdir -p logs-u
: > logs-u/status.txt
: > logs-u/units.tsv
: > logs-u/runs.log
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
out=/dev/shm/claude-2924-c12w-units
BUILDS=(--build none "$G/compilers/compiler-areas0" --build bit12 "$G/compilers/compiler-areas4096" --build none-again "$G/compilers/again/compiler-areas0")
i=0
for f in "${files[@]}"; do
    rm -rf "$out"; mkdir -p "$out"
    bytes=$($L timeout -k 5 60 taskset -c 2 "$G/compilers/compiler-areas0" -E "${M[@]}" "$f" 2>/dev/null | wc -c)
    (cd "$out" && $L timeout -k 5 300 taskset -c 2 "$G/compilers/main" time-runs --runs 3 --directory "$out" "${BUILDS[@]}" --list -c --lanes 1 "${M[@]}" "$f" > "$D/logs-u/run.log" 2>&1)
    s=$?
    # each build's median user cycles and instructions from time-runs' summary lines
    line=$(grep -E '^list 1 (none|bit12|none-again) \[' "$D/logs-u/run.log" | sed -E 's/^list 1 ([a-z0-9-]+) \[.*\]: .* ([0-9]+) user cycles, ([0-9]+) instructions$/\1 \2 \3/' | tr '\n' ' ')
    cat "$D/logs-u/run.log" >> "$D/logs-u/runs.log"
    printf '%s\t%s\t%s\t%s\n' "${f#$musl/}" "$bytes" "$s" "$line" >> logs-u/units.tsv
    i=$((i+1))
done
rm -rf "$out"
echo "units: $i" >> logs-u/status.txt
echo done >> logs-u/status.txt
