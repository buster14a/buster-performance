#!/usr/bin/env bash
# Link the same compiler objects with a bounded inside-.text.buster_checker
# shift. The checker object's hot section gains N leading bytes and keeps its
# 4096-byte alignment, so every hot function moves by exactly N while the
# section still starts on a page. The code bytes are otherwise unchanged.
set -euo pipefail
tree=$1
out=$2
cd "$tree"
index=$3
shift 3
shifts=("$@")
clang=${CLANG:-clang}
linker=${LINKER:-/usr/bin/wild}
mapfile -d '' sources < <("$tree/build.sh" print-sources)
[ "${sources[$index]}" = "src/buster/compiler/main_unit_checker.c" ] || { echo "place-hot: index is not main_unit_checker.c" >&2; exit 1; }
normal="$out/compiler-0"
[ -x "$normal" ] || { echo "place-hot: missing $normal" >&2; exit 1; }
normal_hot=$(nm -n "$normal" | awk '$3 == "check_lower_drain" { if (!found) { print $1; found = 1 } }')
[ -n "$normal_hot" ] || { echo "place-hot: no check_lower_drain" >&2; exit 1; }
for shift in "${shifts[@]}"; do
    [ "$shift" = 0 ] && continue
    checker="$out/checker-$shift.o"
    cp "$out/objects/$index.o" "$checker"
    objcopy --set-section-alignment .text.buster_checker=1 "$checker"
    printf '.section .text.buster_checker,"ax",@progbits\n.skip %d\n' "$shift" | "$clang" -c -x assembler - -o "$out/pad-$shift.o"
    ld -r -o "$out/combined-$shift.o" "$out/pad-$shift.o" "$checker"
    objcopy --set-section-alignment .text.buster_checker=4096 "$out/combined-$shift.o"
    linked=()
    for i in "${!sources[@]}"; do
        if [ "$i" -eq "$index" ]; then
            linked+=("$out/combined-$shift.o")
        else
            linked+=("$out/objects/$i.o")
        fi
    done
    "$clang" -no-pie --ld-path="$linker" "${linked[@]}" -lm -ldl -o "$out/compiler-$shift"
    got=$(nm -n "$out/compiler-$shift" | awk '$3 == "check_lower_drain" { if (!found) { print $1; found = 1 } }')
    [ -n "$got" ] || { echo "place-hot: shift $shift has no check_lower_drain" >&2; exit 1; }
    [ $((16#$got)) -eq $((16#$normal_hot + shift)) ] || { echo "place-hot: shift $shift moved check_lower_drain to $got, wanted $((16#$normal_hot + shift))" >&2; exit 1; }
done
{
    printf 'hot=%s\n' "$normal_hot"
    for symbol in check_lower_drain check_lower_batch_classify check_lower_fragment check_program_emit; do
        printf '%s' "$symbol"
        for shift in "${shifts[@]}"; do
            file="$out/compiler-$shift"
            value=$(nm -n "$file" | awk -v s="$symbol" '$3 == s { if (!found) { print $1; found = 1 } }')
            printf '\t%s=%s' "$shift" "${value:-missing}"
        done
        printf '\n'
    done
} > "$out/addresses.tsv"
cat "$out/addresses.tsv"
