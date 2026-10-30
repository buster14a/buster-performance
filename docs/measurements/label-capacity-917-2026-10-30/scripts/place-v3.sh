#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# One source's structural placements per hold, no benchmark execution.
set -euo pipefail
. "$(dirname "$0")/env.sh"
kind=${1:?base or candidate}
case "$kind" in base|candidate) ;; *) exit 2;; esac
cd "$Q/$kind"
trap 'status=$?; printf "%s\n" "$status" > "$Q/logs/place-$kind-v3.status"' EXIT
clang -std=c17 -O2 -Wall -Wextra -Werror "$Q/proof-tools/normalize_x87_roundtrip.c" -o "build/normalize-x87"
"build/normalize-x87" build/checker.s build/checker-normalized.s > "$Q/logs/$kind-normalization.json"
mapfile -d '' -t sources < build/sources.nul
objects=()
for i in "${!sources[@]}"; do
  objects+=("$Q/$kind/build/$i.o")
  if [ "${sources[$i]}" = src/buster/compiler/main_unit_checker.c ]; then selected=$i; fi
done
test "${selected:?}" = 8
nm -S --defined-only "build/$selected.o" > "$Q/logs/$kind-object-symbols.txt"
required=(--required check_input_run --required check_input_controls --required check_input_controls_prefix)
if nm --defined-only "build/$selected.o" | grep -q ' check_input_label_capacity$'; then required+=(--required check_input_label_capacity); fi
for shift in 0 16 64 256 1024 2048; do
  out="$Q/placements-$kind-v3/$shift"
  mkdir -p "$out"
  python3 "$Q/proof-tools/pad_hot_section.py" build/checker-normalized.s "$out/checker.s" --shift "$shift" --receipt "$out/anchor.json"
  clang -c -x assembler --target=x86_64-unknown-linux-gnu -march=znver5 "$out/checker.s" -o "$out/checker.o"
  if [ "$shift" = 0 ]; then cmp "build/$selected.o" "$out/checker.o"; fi
  python3 "$Q/proof-tools/elf_proof.py" object "build/$selected.o" "$out/checker.o" --hot-section .text.buster_checker --shift "$shift" > "$out/object-proof.json"
  linked=("${objects[@]}")
  linked[$selected]="$out/checker.o"
  clang -no-pie --ld-path=/usr/bin/wild "${linked[@]}" -lm -ldl -o "$out/compiler"
  if [ "$shift" = 0 ]; then cmp build/compiler "$out/compiler"; fi
  python3 "$Q/proof-tools/check_linked.py" "build/$selected.o" build/compiler "$out/compiler" --shift "$shift" "${required[@]}" > "$out/linked-proof.json"
  sha256sum "$out/compiler"
done
