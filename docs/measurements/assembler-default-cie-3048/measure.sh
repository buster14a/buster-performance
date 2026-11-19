#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Run in a checked-out Buster tree with the pinned toolchain on PATH.
set -euo pipefail
export LC_ALL=C BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none
out=${RUNNER_TEMP:-/tmp}/cie-results
mkdir -p "$out"
out=$(cd "$out" && pwd)
base=6427879e1143026a12fb0388a20bdea1fe4b2bc5
head=${1:-72c0872fa40d398c573b6419546531d226fb8697}
script_dir=$(cd -- "$(dirname -- "$0")" && pwd)
git diff --quiet && git diff --cached --quiet || { echo "Use a clean, disposable Buster checkout." >&2; exit 1; }
: > "$out/counts.tsv"
: > "$out/objects.sha256"
: > "$out/compilers.sha256"
git checkout --quiet --detach "$base"
{
    clang --version
    gcc --version
    as --version
    cmake --version
    ninja --version
    ./build.sh print-host-flags --config Release | tr '\0' ' '
    echo
    ./build.sh print-compile-flags --config Release | tr '\0' ' '
    echo
    lscpu | grep -E 'Model name|^CPU\(s\)'
} > "$out/settings.txt"
cat "$out/settings.txt"
for n in 1 100 1000; do
    awk -v n="$n" 'BEGIN { print ".text"; for (i=0;i<n;i++) printf "fn%d:\n.cfi_startproc\nret\n.cfi_endproc\n",i }' > "$out/short-$n.s"
done
for tool in gcc clang; do
    flags=()
    if [[ $tool == clang ]]; then flags+=(-fno-integrated-as); fi
    "$tool" -O2 -march=x86-64 -fcf-protection=none -fasynchronous-unwind-tables -fno-ident "${flags[@]}" -S tools/ci/rerun.c -o "$out/$tool-rerun.s"
done
cat > "$out/mixed.s" <<'ASM'
.cfi_sections .eh_frame, .debug_frame
.text
.cfi_startproc simple
.cfi_def_cfa 7,8
.cfi_offset 16,-8
ret
.cfi_endproc
.cfi_startproc
ret
.cfi_endproc
.cfi_startproc simple
ret
.cfi_endproc
.cfi_startproc
.cfi_signal_frame
ret
.cfi_endproc
.cfi_startproc
.cfi_return_column 31
ret
.cfi_endproc
.cfi_startproc simple
.cfi_signal_frame
.cfi_return_column 31
ret
.cfi_endproc
.cfi_startproc
.cfi_def_cfa_offset 32
ret
.cfi_endproc
.cfi_startproc
pushq %rbp
.cfi_def_cfa_offset 16
ret
.cfi_endproc
.cfi_startproc simple
.cfi_signal_frame
.cfi_return_column 31
ret
.cfi_endproc
.cfi_startproc simple
.cfi_def_cfa 7,8
.cfi_offset 16,-8
ret
.cfi_endproc
ASM
awk 'BEGIN {
    print ".cfi_sections .eh_frame, .debug_frame\n.text"
    for (pass=0; pass<2; pass++) for (i=0; i<1024; i++) {
        key=pass ? 1023-i : i
        print ".cfi_startproc" (key%2 ? " simple" : "")
        if (int(key/2)%2) print ".cfi_signal_frame"
        print ".cfi_return_column " int(key/4) "\nret\n.cfi_endproc"
    }
}' > "$out/all-keys.s"
inputs=(short-1 short-100 short-1000 gcc-rerun clang-rerun mixed all-keys)
frames()
{
    local object=$1 prefix=$2 section
    readelf -wf "$object" > "$prefix.frames"
    readelf -rW "$object" | awk '/^Relocation section/ {frame=($3 ~ /\.rela\.(eh_frame|debug_frame)/); if(frame) print $3; next} frame && $1 ~ /^[0-9a-f]+$/ {print $1, $3, $5, $6, $7}' > "$prefix.relocs"
    for section in .eh_frame .debug_frame; do
        if readelf -SW "$object" | grep -F " $section " > /dev/null; then
            objcopy --dump-section "$section=$prefix$section" "$object" /dev/null
        fi
    done
}
for input in "${inputs[@]}"; do
    if [[ $input == all-keys ]]; then continue; fi
    as --64 -o "$out/$input.gas.o" "$out/$input.s"
    frames "$out/$input.gas.o" "$out/$input.gas"
done
(cd "$out" && sha256sum short-{1,100,1000}.s gcc-rerun.s clang-rerun.s mixed.s all-keys.s) | tee "$out/inputs.sha256"
file=src/buster/compiler/assembler_cfi.c
measure()
{
    local label=$1 rev=$2 input
    git checkout -q --detach "$rev"
    git rev-parse HEAD > "$out/$label.commit"
    ./build.sh --config Release > "$out/$label.build" 2>&1 || { tail -60 "$out/$label.build"; return 1; }
    sha256sum build/compiler | awk -v id="$label.clean" '{print $1, id}' | tee -a "$out/compilers.sha256"
    for input in "${inputs[@]}"; do
        ./build/compiler assemble -o "$out/$input.$label.o" "$out/$input.s"
        frames "$out/$input.$label.o" "$out/$input.$label"
    done
    # The candidate length is backpatched; candidate.size includes that field once and includes padding.
    test "$(grep -Fc 'asm_cfi_length(&candidate, 0);' "$file")" = 1
    sed -i '/asm_cfi_length(\&candidate, 0);/a\            fprintf(stderr, "CIE-built %u\\n", candidate.size);' "$file"
    ./build.sh --config Release > "$out/$label.count-build" 2>&1 || { tail -60 "$out/$label.count-build"; return 1; }
    sha256sum build/compiler | awk -v id="$label.counted" '{print $1, id}' | tee -a "$out/compilers.sha256"
    for input in "${inputs[@]}"; do
        ./build/compiler assemble -o "$out/count.o" "$out/$input.s" 2> "$out/$input.$label.trace"
        cmp "$out/count.o" "$out/$input.$label.o"
        awk -v label="$label" -v input="$input" '$1=="CIE-built"{n++;bytes+=$2}END{printf "%s\t%s\t%d\t%d\n",label,input,n,bytes; if(!n)exit 1}' "$out/$input.$label.trace" | tee -a "$out/counts.tsv"
    done
    git restore -- "$file"
}
measure base "$base"
git fetch --no-tags origin "$head"
measure head "$head"
for input in "${inputs[@]}"; do
    cmp "$out/$input.base.o" "$out/$input.head.o"
    sha256sum "$out/$input.head.o" | sed "s|$out/||" | tee -a "$out/objects.sha256"
done
echo 'All complete base and head objects match.'
oracle_fail=0
for input in "${inputs[@]}"; do
    if [[ $input == mixed ]]; then
        # GAS may use a shorter CIE and put the remaining initial instructions in the FDE.
        for label in gas base head; do
            awk -v buster="$([[ $label == gas ]] && echo 0 || echo 1)" -f "$script_dir/mixed.awk" "$out/mixed.$label.frames" | sort > "$out/mixed.$label.rows"
        done
        cmp "$out/mixed.gas.rows" "$out/mixed.base.rows"
        cmp "$out/mixed.base.rows" "$out/mixed.head.rows"
        echo 'Mixed frames: all 22 effective rows match GNU as; all 20 Buster FDEs reference the expected first CIE.'
        continue
    fi
    if [[ $input == all-keys ]]; then
        cc -std=c11 -O2 -Wall -Wextra -Werror "$script_dir/keys.c" -o "$out/check-keys"
        for label in base head; do
            prefix="$out/all-keys.$label"
            for section in eh_frame debug_frame; do
                awk -v header="'.rela.$section'" '/^\047/ {take=($0==header); next} take' "$prefix.relocs" > "$prefix.$section.relocations"
                "$out/check-keys" "$section" "$prefix.$section" "$prefix.$section.relocations"
                echo "$label .$section: verified all 1,024 CIE identities and 2,048 FDEs with their relocations."
            done
        done
        continue
    fi
    for part in frames relocs eh_frame debug_frame; do
        if [[ -f "$out/$input.gas.$part" ]]; then
            if ! cmp "$out/$input.gas.$part" "$out/$input.base.$part"; then
                echo "GNU frame difference: $input $part"
                oracle_fail=1
            fi
        fi
    done
done
printf '%s\n' 'Mixed CIE and FDE offsets (readelf -wf):'
grep -E 'Contents of| CIE$| FDE cie=' "$out/mixed.base.frames"
cat "$out/mixed.base.relocs"
./build.sh --config Release > "$out/clean.build" 2>&1 || { tail -60 "$out/clean.build"; exit 1; }
./build/compiler test-assembler --cross-check > "$out/cross-check.log" 2>&1 || { tail -80 "$out/cross-check.log"; exit 1; }
tail -8 "$out/cross-check.log"
grep -E 'assembler: [0-9]+ checks, 0 failures' "$out/cross-check.log"
test "$oracle_fail" = 0
