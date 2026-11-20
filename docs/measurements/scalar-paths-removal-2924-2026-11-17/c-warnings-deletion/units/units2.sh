#!/bin/bash
# #2924 C12c-2: the warnings' twins (bit 12) on musl's units below 16,000 preprocessed bytes, again, each build from a
# fresh copy a unit: units.sh's first reading had its two no-bit files (the same bytes) 9.6% apart at the smallest
# units. Each unit: the three executables copied fresh to /dev/shm under their knob names and read once, then one
# locked time-runs --runs 5 of no bit, bit 12 and no bit again, -c --lanes 1, CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
G=$D/../c12c
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the warnings' small units from fresh copies, C12c-2" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs-v
: > logs-v/status.txt
: > logs-v/units.tsv
: > logs-v/runs.log
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
out=/dev/shm/claude-2924-c12w-units
exe=/dev/shm/claude-2924-c12w-exe
i=0
while IFS=$'\t' read -r rel bytes rest; do
    [ "$bytes" -lt 16000 ] || continue
    f=$musl/$rel
    rm -rf "$out" "$exe"; mkdir -p "$out" "$exe/n1" "$exe/b" "$exe/n2"
    cp "$G/compilers/compiler-areas0" "$exe/n1/compiler-areas0"
    cp "$G/compilers/compiler-areas4096" "$exe/b/compiler-areas4096"
    cp "$G/compilers/compiler-areas0" "$exe/n2/compiler-areas0"
    cat "$exe"/*/compiler-areas* > /dev/null
    BUILDS=(--build none "$exe/n1/compiler-areas0" --build bit12 "$exe/b/compiler-areas4096" --build none-again "$exe/n2/compiler-areas0")
    (cd "$out" && $L timeout -k 5 300 taskset -c 2 "$G/compilers/main" time-runs --runs 5 --directory "$out" "${BUILDS[@]}" --list -c --lanes 1 "${M[@]}" "$f" > "$D/logs-v/run.log" 2>&1)
    s=$?
    line=$(grep -E '^list 1 (none|bit12|none-again) \[' "$D/logs-v/run.log" | sed -E 's/^list 1 ([a-z0-9-]+) \[.*\]: .* ([0-9]+) user cycles, ([0-9]+) instructions$/\1 \2 \3/' | tr '\n' ' ')
    cat "$D/logs-v/run.log" >> "$D/logs-v/runs.log"
    printf '%s\t%s\t%s\t%s\n' "$rel" "$bytes" "$s" "$line" >> logs-v/units.tsv
    i=$((i+1))
done < logs-u/units.tsv
rm -rf "$out" "$exe"
echo "units: $i" >> logs-v/status.txt
echo done >> logs-v/status.txt
