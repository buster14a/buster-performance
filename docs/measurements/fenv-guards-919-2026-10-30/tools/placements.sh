#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Exact same-code checker placements. ROOT contains pr919[-base] and pr919-evidence.
set -euo pipefail
root=${1:?ROOT}
label=${2:?base or head}
packet=$(cd "$(dirname "$0")/.." && pwd)
source=$root/pr919
if [ "$label" = base ]; then source=$root/pr919-base; else test "$label" = head; fi
objects=$root/pr919-evidence/objects-$label
variants=$root/pr919-evidence/placement-$label
proof=$packet/tools/proof-tools
receipts=$packet/placements
mkdir -p "$variants" "$receipts"
cd "$source"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 LC_ALL=C
mapfile -d '' -t flags < <(bash build.sh print-compile-flags)
printf '%s\0' "${flags[@]}" > "$receipts/$label-flags.nul"
cp "$objects/8.json" "$receipts/$label-compile-command.json"
clang -S src/buster/compiler/main_unit_checker.c "${flags[@]}" -o "$variants/checker8.s"
clang -std=c17 -O2 -Wall -Wextra -Werror "$packet/tools/normalize_x87_roundtrip.c" -o "$variants/normalize"
"$variants/normalize" "$variants/checker8.s" "$variants/checker8-normalized.s" > "$receipts/$label-normalize.json"
for shift in 0 64 256; do
    python3 "$proof/pad_hot_section.py" "$variants/checker8-normalized.s" "$variants/inside-$shift.s" --shift "$shift" --receipt "$receipts/$label-pad-$shift.json"
    clang -c -x assembler -march=znver5 "$variants/inside-$shift.s" -o "$variants/inside-$shift.o"
    python3 "$proof/elf_proof.py" object "$objects/8.o" "$variants/inside-$shift.o" --shift "$shift" > "$receipts/$label-object-$shift.json"
    linked=()
    for index in $(seq 0 40); do
        if [ "$index" -eq 8 ]; then linked+=("$variants/inside-$shift.o"); else linked+=("$objects/$index.o"); fi
    done
    clang -no-pie -fuse-ld=wild "${linked[@]}" -lm -ldl -o "$variants/compiler-$shift"
    python3 "$proof/check_linked.py" "$objects/8.o" "$variants/compiler-0" "$variants/compiler-$shift" --shift "$shift" --required check_graph_scalar_node --required check_action_fp_environment > "$receipts/$label-linked-$shift.json"
done
cmp "$objects/8.o" "$variants/inside-0.o"
cmp build/compiler "$variants/compiler-0"
sha256sum "$objects"/*.o > "$receipts/$label-objects.sha256"
sha256sum "$variants"/compiler-{0,64,256} "$variants"/checker8*.s > "$receipts/$label-images.sha256"
printf 'PASS label=%s entire_zero_object_and_image_identical=true all_translations_checked=true\n' "$label"
