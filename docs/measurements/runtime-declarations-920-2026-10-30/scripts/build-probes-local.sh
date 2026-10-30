#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Untimed clones only. Run through a local cores reservation.
set -euo pipefail
test "$#" -eq 7
base_tar=$(realpath "$1")
candidate_tar=$(realpath "$2")
base_objects=$(realpath "$3")
candidate_objects=$(realpath "$4")
flags_file=$(realpath "$5")
tc=$(realpath "$6")
out=$(realpath -m "$7")
packet=$(cd "$(dirname "$0")/.." && pwd)
test ! -e "$out"
mkdir -p "$out/receipts"
trap 'status=$?; printf "%s\n" "$status" > "$out/receipts/status"' EXIT
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400
export PATH="$tc/bin:$PATH" LD_LIBRARY_PATH="$tc/lib"
export BUSTER_CLANG_RESOURCE_DIR="$tc/lib/clang/23"
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
printf '%s  %s\n' \
  e555e11f9c6ffe66d032a7a2cf8c457eb8a3c8c3b955e61ca8c833ca22219211 "$base_tar" \
  a0c949b25423fe6640748caef104000573c5fdccb0c1f7245813cccea26ad5af "$candidate_tar" \
  4aa2a145d0a4c5646a1500584f3aa050c4e544303f76eb2e959c1e94c479b74f "$flags_file" \
  c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67 "$tc/bin/clang" \
  da1bd2ff0b126524a664b70ef1e0d5522ce335f73a0cae32024ee8e8038122a5 /usr/bin/wild \
  71106af0dbf3c434639f5940c1cd40d83ee1acd629e266ce9bc5ce413bad8041 "$packet/proof-tools/runtime_probe_source.c" \
  > "$out/receipts/pinned.sha256"
sha256sum --check --status "$out/receipts/pinned.sha256"
clang --version > "$out/receipts/compiler.txt"
sha256sum "$base_tar" "$candidate_tar" "$flags_file" > "$out/receipts/inputs.sha256"
sha256sum "$base_objects/"{0..40}.o "$candidate_objects/"{0..40}.o > "$out/receipts/retained-objects.sha256"
for kind in base candidate; do
  case "$kind" in base) objects=$base_objects;; candidate) objects=$candidate_objects;; esac
  # -MJ records include one trailing comma. Remove only that comma, validate the
  # known command shape, and omit only the distinct output pathname for comparison.
  sed '$s/,$//' "$objects/8.json" | jq -e --arg clang "$tc/bin/clang-23" \
    '.file == "src/buster/compiler/main_unit_checker.c" and .arguments[0] == $clang and .arguments[3] == "-o" and .arguments[4] == .output' \
    > "$out/receipts/$kind-command-valid.txt"
  sed '$s/,$//' "$objects/8.json" | jq '.arguments | del(.[4])' > "$out/receipts/$kind-checker-arguments.json"
done
cmp "$out/receipts/base-checker-arguments.json" "$out/receipts/candidate-checker-arguments.json"
mapfile -d '' -t flags < "$flags_file"
clang -std=c17 -O2 -Wall -Wextra -Werror "$packet/proof-tools/runtime_probe_source.c" -o "$out/generate"
clang -std=c17 -O2 -Wall -Wextra -Werror "$packet/proof-tools/read_runtime_probe.c" -o "$out/read-runtime-probe"
sha256sum "$out/generate" "$out/read-runtime-probe" > "$out/receipts/generated-tools.sha256"
for mode in base candidate candidate-mutant; do
  kind=$mode
  [ "$mode" != candidate-mutant ] || kind=candidate
  case "$kind" in base) archive=$base_tar; object_dir=$base_objects;; candidate) archive=$candidate_tar; object_dir=$candidate_objects;; esac
  root="$out/$mode"
  mkdir -p "$root/source"
  tar -xf "$archive" -C "$root/source"
  lower="$root/source/src/buster/compiler/c_check_program_lower.c"
  cp "$lower" "$root/original-lower.c"
  "$out/generate" "$mode" "$lower" "$root/diagnostic-lower.c" > "$root/generator.txt"
  diff -u "$root/original-lower.c" "$root/diagnostic-lower.c" > "$root/diagnostic.patch" || test "$?" -eq 1
  cp "$root/diagnostic-lower.c" "$lower"
  cd "$root/source"
  printf '%s\0' clang -c src/buster/compiler/main_unit_checker.c -o "$root/checker.o" "${flags[@]}" > "$root/compile-command.nul"
  clang -c src/buster/compiler/main_unit_checker.c -o "$root/checker.o" "${flags[@]}" > "$root/compile.log" 2>&1
  objects=()
  for i in $(seq 0 40); do
    if [ "$i" = 8 ]; then objects+=("$root/checker.o"); else objects+=("$object_dir/$i.o"); fi
  done
  printf '%s\0' clang -no-pie --ld-path=/usr/bin/wild "${objects[@]}" -lm -ldl -o "$root/compiler" > "$root/link-command.nul"
  clang -no-pie --ld-path=/usr/bin/wild "${objects[@]}" -lm -ldl -o "$root/compiler"
  sha256sum "$root/compiler" "$root/checker.o" "$root/original-lower.c" "$root/diagnostic-lower.c" "${objects[@]}" > "$root/inputs.sha256"
done
sha256sum --check --status "$out/receipts/inputs.sha256"
sha256sum --check --status "$out/receipts/retained-objects.sha256"
sha256sum --check --status "$out/receipts/pinned.sha256"
printf 'three untimed diagnostic clones built with original forty non-checker objects\n' > "$out/receipts/passed.txt"
