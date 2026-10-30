#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Read-only structural analysis, no target execution.
set -euo pipefail
Q=/home/david/buster-fast-bench/codex-pr912-20261030
mkdir -p "$Q/evidence/proofs"
for variant in base candidate; do
    cmp "$Q/$variant/build/compiler" "$Q/hot-$variant-0/build/compiler"
    for shift in 64 512; do
        for original in "$Q/objects-$variant-0"/*.o; do
            object=$(basename "$original")
            changed="$Q/objects-$variant-$shift/$object"
            if [ "$object" = main_unit_checker.c.o ]; then
                python3 "$Q/scripts/elf_proof.py" object "$original" "$changed" --shift "$shift" > "$Q/evidence/proofs/object-$variant-$shift-$object.json"
            else
                cmp "$original" "$changed"
            fi
        done
        python3 "$Q/scripts/check_linked.py" "$Q/objects-$variant-0/main_unit_checker.c.o" \
          "$Q/$variant/build/compiler" "$Q/hot-$variant-$shift/build/compiler" --shift "$shift" \
          > "$Q/evidence/proofs/linked-$variant-$shift.json"
    done
done
echo 'all exact-object translation and linked hot-code gates PASS'
