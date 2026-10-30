#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# File-only qualification of retained production objects. No compiler image is run.
# Run the compile/link work through the local cores reservation, never on a shared
# host outside that host's exclusive lock. Output must be a new directory.
set -euo pipefail
if [ "$#" -ne 6 ]; then
  printf 'usage: %s SOURCE_ROOT OBJECT_DIRECTORY NORMAL_COMPILER OFFICIAL_TOOLCHAIN NEW_OUTPUT PROOF_TOOLS\n' "$0" >&2
  exit 2
fi
src=$(realpath "$1")
input_objects=$(realpath "$2")
normal=$(realpath "$3")
tc=$(realpath "$4")
out=$(realpath -m "$5")
tools=$(realpath "$6")
test -f "$src/build.sh" && test -d "$src/src"
test -d "$input_objects" && test -x "$normal"
test -x "$tc/bin/clang" && test -d "$tc/lib/clang/23"
case "$out/" in "$src/"*|"$input_objects/"*|"$tc/"*|"$tools/"*)
  printf 'output must be outside every immutable input directory\n' >&2; exit 2;;
esac
test ! -e "$out"
mkdir "$out"
mkdir "$out/receipts" "$out/objects" "$out/normal" "$out/proof-tools"
trap 'status=$?; printf "%s\n" "$status" > "$out/receipts/status"' EXIT
export LC_ALL=C LC_NUMERIC=C SOURCE_DATE_EPOCH=1792454400 PYTHONDONTWRITEBYTECODE=1
export PATH="$tc/bin:$PATH" LD_LIBRARY_PATH="$tc/lib"
export BUSTER_CLANG_RESOURCE_DIR="$tc/lib/clang/23"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none BUSTER_LINKER=/usr/bin/wild
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
unset BUSTER_HOST_RUNTIME BUSTER_FUZZ_AVAILABLE BUSTER_FUZZ_ENTRY BUSTER_SANITIZER_OPTIMIZATION
printf '%s  %s\n' \
  c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67 "$tc/bin/clang" \
  da1bd2ff0b126524a664b70ef1e0d5522ce335f73a0cae32024ee8e8038122a5 /usr/bin/wild \
  3688b585de9991a0bb40303bc4dbddd6ed9c1a65af538b0ae5cf01c66c224a31 "$tools/elf_proof.py" \
  94a586047b63e9cac0dfa73deff8a05277e7ce1902e29d82e1a70322f5e26937 "$tools/check_linked.py" \
  3d89b4e8408dd317d72a72638594882fc14802609e07cc76c0aa9d5d26b076e1 "$tools/pad_hot_section.py" \
  18a1cb27213ec3ca59b1704378e7418a34a96a50dccf761ba814c7eaefc5576f "$tools/normalize_x87_roundtrip.c" \
  > "$out/receipts/pinned-inputs.sha256"
sha256sum --check --status "$out/receipts/pinned-inputs.sha256"
for file in elf_proof.py check_linked.py pad_hot_section.py normalize_x87_roundtrip.c; do
  cp "$tools/$file" "$out/proof-tools/$file"
  cmp "$tools/$file" "$out/proof-tools/$file"
done
{
  date -u +%FT%TZ
  clang --version
  clang -print-resource-dir
  /usr/bin/wild --version
  uname -a
  printf 'source=%s\nobjects=%s\nnormal=%s\n' "$src" "$input_objects" "$normal"
} > "$out/receipts/identity.txt"
snapshot_source()
{
  (cd "$src"; find src -type f -print0 | sort -z | xargs -0 sha256sum; sha256sum build.sh)
}
snapshot_source > "$out/receipts/source-before.sha256"
cd "$src"
./build.sh print-compile-flags > "$out/receipts/flags.nul"
./build.sh print-sources > "$out/receipts/sources.nul"
mapfile -d '' -t flags < "$out/receipts/flags.nul"
mapfile -d '' -t sources < "$out/receipts/sources.nul"
test "${#sources[@]}" -eq 41
selected=
objects=()
input_files=()
for i in "${!sources[@]}"; do
  test -f "$input_objects/$i.o" && test -f "$input_objects/$i.json"
  cp "$input_objects/$i.o" "$out/objects/$i.o"
  cp "$input_objects/$i.json" "$out/receipts/$i.json"
  cmp "$input_objects/$i.o" "$out/objects/$i.o"
  objects+=("$out/objects/$i.o")
  input_files+=("$input_objects/$i.o" "$input_objects/$i.json")
  if [ "${sources[$i]}" = src/buster/compiler/main_unit_checker.c ]; then
    test -z "$selected"
    selected=$i
  fi
done
test "${selected:?missing checker source}" -eq 8
mapfile -d '' -t found_objects < <(find "$input_objects" -maxdepth 1 -type f -name '*.o' -print0)
test "${#found_objects[@]}" -eq 41
cp "$normal" "$out/normal/compiler"
cmp "$normal" "$out/normal/compiler"
sha256sum "${input_files[@]}" "$normal" > "$out/receipts/retained-inputs.sha256"
sha256sum "${objects[@]}" "$out/normal/compiler" > "$out/receipts/copied-inputs.sha256"
# This assembly capture changes no source, preprocessing definition, optimizer
# flag, or production object. Whole zero-object equality below proves the exact
# roundtrip; the independently retained compile commands remain in receipts/.
clang -S "${sources[$selected]}" -o "$out/checker.s" "${flags[@]}"
clang -std=c17 -O2 -Wall -Wextra -Werror "$out/proof-tools/normalize_x87_roundtrip.c" -o "$out/normalize-x87"
"$out/normalize-x87" "$out/checker.s" "$out/checker-normalized.s" > "$out/receipts/normalization.json"
nm -S --defined-only "$out/objects/$selected.o" > "$out/receipts/object-symbols.txt"
# The small runtime helper may be inlined. Its actual production caller must be
# owned by the selected hot contribution and must move by each requested shift.
# check_linked.py additionally requires emit/drain/batch_classify itself.
required=(--required check_lower_prepare)
for shift in 0 16 64 256 1024 2048; do
  variant="$out/$shift"
  mkdir "$variant"
  python3 "$out/proof-tools/pad_hot_section.py" "$out/checker-normalized.s" "$variant/checker.s" \
    --shift "$shift" --receipt "$variant/anchor.json"
  clang -c -x assembler --target=x86_64-unknown-linux-gnu -march=znver5 "$variant/checker.s" -o "$variant/checker.o"
  if [ "$shift" -eq 0 ]; then
    cmp "$out/objects/$selected.o" "$variant/checker.o"
    printf 'whole checker object: byte-identical to ordinary retained object\n' > "$variant/zero-object.txt"
  fi
  python3 "$out/proof-tools/elf_proof.py" object "$out/objects/$selected.o" "$variant/checker.o" \
    --hot-section .text.buster_checker --shift "$shift" > "$variant/object-proof.json"
  linked=("${objects[@]}")
  linked[$selected]="$variant/checker.o"
  printf '%s\0' clang -no-pie --ld-path=/usr/bin/wild "${linked[@]}" -lm -ldl -o "$variant/compiler" \
    > "$variant/link-command.nul"
  clang -no-pie --ld-path=/usr/bin/wild "${linked[@]}" -lm -ldl -o "$variant/compiler"
  if [ "$shift" -eq 0 ]; then
    cmp "$out/normal/compiler" "$variant/compiler"
    printf 'whole final image: byte-identical to ordinary production compiler\n' > "$variant/zero-image.txt"
  fi
  python3 "$out/proof-tools/check_linked.py" "$out/objects/$selected.o" "$out/normal/compiler" "$variant/compiler" \
    --shift "$shift" "${required[@]}" > "$variant/linked-proof.json"
  sha256sum "$variant/checker.s" "$variant/checker.o" "$variant/compiler" > "$variant/files.sha256"
done
snapshot_source > "$out/receipts/source-after.sha256"
cmp "$out/receipts/source-before.sha256" "$out/receipts/source-after.sha256"
sha256sum --check --status "$out/receipts/retained-inputs.sha256"
sha256sum --check --status "$out/receipts/copied-inputs.sha256"
sha256sum --check --status "$out/receipts/pinned-inputs.sha256"
for i in "${!sources[@]}"; do
  cmp "$input_objects/$i.o" "$out/objects/$i.o"
  cmp "$input_objects/$i.json" "$out/receipts/$i.json"
done
cmp "$normal" "$out/normal/compiler"
printf 'all six structural placements passed; whole zero object/image exact; all41 retained inputs and sources unchanged\n' \
  > "$out/receipts/passed.txt"
