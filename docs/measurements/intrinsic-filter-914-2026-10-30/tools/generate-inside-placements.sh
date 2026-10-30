#!/usr/bin/env bash
set -euo pipefail
root=/home/david/Documents/Codex/2026-10-30/tak-3/work
receipt_dir=$root/performance914/docs/measurements/intrinsic-filter-914-2026-10-30/placements
proof_dir=$root/performance914/docs/measurements/intrinsic-filter-914-2026-10-30/tools/proof-tools
for label in base fixed; do
    variant_dir=$root/pr914-evidence/placement-$label
    object_dir=$root/pr914-evidence/objects-$label
    required=(--required check_input_intrinsic_initialize)
    if [ "$label" = fixed ]; then
        required+=(--required check_input_intrinsic_lookup)
    fi
    for amount in 0 64 256; do
        if [ ! -f "$variant_dir/inside-$amount.s" ]; then
            python3 "$proof_dir/pad_hot_section.py" "$variant_dir/checker8-normalized.s" "$variant_dir/inside-$amount.s" --shift "$amount" --receipt "$receipt_dir/$label-pad-$amount-v3.json"
        fi
        clang -c -x assembler -march=znver5 "$variant_dir/inside-$amount.s" -o "$variant_dir/inside-$amount.o"
        python3 "$proof_dir/elf_proof.py" object "$object_dir/8.o" "$variant_dir/inside-$amount.o" --shift "$amount" > "$receipt_dir/$label-object-$amount-v3.json"
        objects=()
        for index in $(seq 0 40); do
            if [ "$index" -eq 8 ]; then
                objects+=("$variant_dir/inside-$amount.o")
            else
                objects+=("$object_dir/$index.o")
            fi
        done
        clang -no-pie -fuse-ld=wild "${objects[@]}" -lm -ldl -o "$variant_dir/compiler-$amount"
        python3 "$proof_dir/check_linked.py" "$object_dir/8.o" "$variant_dir/compiler-0" "$variant_dir/compiler-$amount" --shift "$amount" "${required[@]}" > "$receipt_dir/$label-linked-$amount-v3.json"
    done
    cmp "$object_dir/8.o" "$variant_dir/inside-0.o"
    source_dir=$root/pr914
    if [ "$label" = base ]; then source_dir=$root/pr914-base; fi
    cmp "$source_dir/build/compiler" "$variant_dir/compiler-0"
done
sha256sum "$root"/pr914-evidence/placement-{base,fixed}/compiler-{0,64,256} > "$receipt_dir/binary-sha256.txt"
