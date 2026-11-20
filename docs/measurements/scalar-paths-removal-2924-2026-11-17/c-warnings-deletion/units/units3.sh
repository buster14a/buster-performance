#!/bin/bash
# #2924 C12c-2: the warnings' twins (bit 12) on musl's units below 8,000 preprocessed bytes, a third time: the three
# names hard links to one fresh file (the knob reads its name), since units2.sh's fresh copies read the two no-bit
# files 11% to 29% apart there. Each unit: one fresh copy in /dev/shm, read once, linked under the three names, then one
# locked time-runs --runs 9 of no bit, bit 12 and no bit again, -c --lanes 1, CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
G=$D/../c12c
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the warnings' small units from one file, C12c-2" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs-l
: > logs-l/status.txt
: > logs-l/units.tsv
: > logs-l/runs.log
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
export LC_ALL=C
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
out=/dev/shm/claude-2924-c12w-units
exe=/dev/shm/claude-2924-c12w-exe
i=0
while IFS=$'\t' read -r rel bytes rest; do
    [ "$bytes" -lt 8000 ] || continue
    f=$musl/$rel
    rm -rf "$out" "$exe"; mkdir -p "$out" "$exe/n1" "$exe/b" "$exe/n2"
    cp "$G/compilers/compiler-areas0" "$exe/file"; cat "$exe/file" > /dev/null
    ln "$exe/file" "$exe/n1/compiler-areas0"
    ln "$exe/file" "$exe/b/compiler-areas4096"
    ln "$exe/file" "$exe/n2/compiler-areas0"
    BUILDS=(--build none "$exe/n1/compiler-areas0" --build bit12 "$exe/b/compiler-areas4096" --build none-again "$exe/n2/compiler-areas0")
    (cd "$out" && $L timeout -k 5 300 taskset -c 2 "$G/compilers/main" time-runs --runs 9 --directory "$out" "${BUILDS[@]}" --list -c --lanes 1 "${M[@]}" "$f" > "$D/logs-l/run.log" 2>&1)
    s=$?
    line=$(grep -E '^list 1 (none|bit12|none-again) \[' "$D/logs-l/run.log" | sed -E 's/^list 1 ([a-z0-9-]+) \[.*\]: .* ([0-9]+) user cycles, ([0-9]+) instructions$/\1 \2 \3/' | tr '\n' ' ')
    cat "$D/logs-l/run.log" >> "$D/logs-l/runs.log"
    printf '%s\t%s\t%s\t%s\n' "$rel" "$bytes" "$s" "$line" >> logs-l/units.tsv
    i=$((i+1))
done < logs-u/units.tsv
rm -rf "$out" "$exe"
echo "units: $i" >> logs-l/status.txt
echo done >> logs-l/status.txt
