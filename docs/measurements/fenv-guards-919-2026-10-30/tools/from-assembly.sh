#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Short resource-scheduled derivation from frozen assembly; no C code generation.
set -euo pipefail
root=${1:?ROOT}
label=${2:?base or head}
shift 2
test "$#" -gt 0
packet=$(cd "$(dirname "$0")/.." && pwd)
clang=$root/toolchain919/bin/clang
source=$root/pr919
if [ "$label" = base ]; then source=$root/pr919-base; else test "$label" = head; fi
objects=$root/pr919-evidence/objects-$label
variants=$root/pr919-evidence/placement-$label
receipts=$packet/placements
proof=$packet/tools/proof-tools
mkdir -p "$variants" "$receipts"
sha256sum "$clang" /usr/bin/wild "$0" "$proof"/*.py "$packet/tools/normalize_x87_roundtrip.c" "$variants/checker8.s" "$objects"/*.o > "$receipts/$label-from-assembly-before.sha256"
if [ ! -f "$variants/checker8-normalized.s" ]; then
    "$clang" -std=c17 -O2 -Wall -Wextra -Werror "$packet/tools/normalize_x87_roundtrip.c" -o "$variants/normalize"
    "$variants/normalize" "$variants/checker8.s" "$variants/checker8-normalized.s" > "$receipts/$label-normalize.json"
fi
original=()
for index in $(seq 0 40); do original+=("$objects/$index.o"); done
# Use the unchanged production linker arguments under the cores grant.
"$clang" -no-pie -fuse-ld=wild "${original[@]}" -lm -ldl -o "$variants/compiler-control-zero"
cmp "$source/build/compiler" "$variants/compiler-control-zero"
for amount in "$@"; do
    python3 "$proof/pad_hot_section.py" "$variants/checker8-normalized.s" "$variants/inside-$amount.s" --shift "$amount" --receipt "$receipts/$label-pad-$amount.json"
    "$clang" -c -x assembler -march=znver5 "$variants/inside-$amount.s" -o "$variants/inside-$amount.o"
    python3 "$proof/elf_proof.py" object "$objects/8.o" "$variants/inside-$amount.o" --shift "$amount" > "$receipts/$label-object-$amount.json"
    linked=()
    for index in $(seq 0 40); do
        if [ "$index" -eq 8 ]; then linked+=("$variants/inside-$amount.o"); else linked+=("$objects/$index.o"); fi
    done
    "$clang" -no-pie -fuse-ld=wild "${linked[@]}" -lm -ldl -o "$variants/compiler-$amount"
    python3 "$proof/check_linked.py" "$objects/8.o" "$variants/compiler-0" "$variants/compiler-$amount" --shift "$amount" --required check_graph_scalar_node --required check_action_fp_environment > "$receipts/$label-linked-$amount.json"
done
cmp "$objects/8.o" "$variants/inside-0.o"
cmp "$source/build/compiler" "$variants/compiler-0"
sha256sum --check "$receipts/$label-from-assembly-before.sha256" > "$receipts/$label-from-assembly-after.txt"
sha256sum "$variants"/compiler-* > "$receipts/$label-all-images.sha256"
printf 'PASS label=%s entire_zero_object_and_image_identical=true normal_link_image_identical=true\n' "$label"
