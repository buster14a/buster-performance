#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Parser-only synthetic controls. Never executes a Buster compiler image.
set -euo pipefail
test "$#" -eq 2
reader_source=$(realpath "$1")
out=$(realpath -m "$2")
test ! -e "$out"
mkdir -p "$out/positive"
trap 'status=$?; printf "%s\n" "$status" > "$out/status"' EXIT
cp "$reader_source" "$out/read_runtime_probe.c"
cmp "$reader_source" "$out/read_runtime_probe.c"
sha256sum "$reader_source" "$out/read_runtime_probe.c" > "$out/reader-inputs.sha256"
cc --version > "$out/compiler.txt"
cc -std=c17 -O2 -Wall -Wextra -Werror "$out/read_runtime_probe.c" -o "$out/read-runtime-probe"
printf '%s\n' 'runtime-scan mode=base scalar=0 spelled=1 full=1000 compact=20 visited=1000 errno-index=0' > "$out/positive/base-native.stderr"
printf '%s\n' 'runtime-scan mode=base scalar=1 spelled=1 full=1000 compact=20 visited=1000 errno-index=0' > "$out/positive/base-scalar.stderr"
printf '%s\n' 'runtime-scan mode=candidate scalar=0 spelled=1 full=1000 compact=20 visited=20 errno-index=0 oracle-equal=1' > "$out/positive/candidate-native.stderr"
printf '%s\n' 'runtime-scan mode=candidate scalar=1 spelled=1 full=1000 compact=20 visited=1000 errno-index=0 oracle-equal=1' > "$out/positive/candidate-scalar.stderr"
printf 'control,expected_status,actual_status\n' > "$out/results.csv"
run_case()
{
  local name=$1 expected=$2 status
  set +e
  "$out/read-runtime-probe" synthetic \
    "$out/$name/base-native.stderr" "$out/$name/base-scalar.stderr" \
    "$out/$name/candidate-native.stderr" "$out/$name/candidate-scalar.stderr" \
    > "$out/$name/stdout" 2> "$out/$name/stderr"
  status=$?
  set -e
  printf '%s\n' "$status" > "$out/$name/status"
  printf '%s,%s,%s\n' "$name" "$expected" "$status" >> "$out/results.csv"
  test "$status" -eq "$expected"
}
run_case positive 0
printf '%s\n' \
  'corpus,full_token_visits,compact_list_visits,visits_removed,reduction_factor' \
  'synthetic,1000,20,980,50.000000' > "$out/positive/expected.csv"
cmp "$out/positive/expected.csv" "$out/positive/stdout"
for name in spelled-zero wrong-scalar wrong-visit cross-count oracle-zero duplicate-trace non-digit uint32-overflow; do
  mkdir "$out/$name"
  cp "$out/positive/"*.stderr "$out/$name/"
  fixture="$out/$name/candidate-native.stderr"
  case "$name" in
    spelled-zero) sed 's/spelled=1/spelled=0/' "$fixture" > "$fixture.new";;
    wrong-scalar) sed 's/scalar=0/scalar=1/' "$fixture" > "$fixture.new";;
    wrong-visit) sed 's/visited=20 /visited=1000 /' "$fixture" > "$fixture.new";;
    cross-count) sed 's/full=1000 /full=1001 /' "$fixture" > "$fixture.new";;
    oracle-zero) sed 's/oracle-equal=1/oracle-equal=0/' "$fixture" > "$fixture.new";;
    duplicate-trace) cat "$fixture" "$fixture" > "$fixture.new";;
    non-digit) sed 's/full=1000 /full=100x /' "$fixture" > "$fixture.new";;
    uint32-overflow) sed 's/full=1000 /full=4294967296 /' "$fixture" > "$fixture.new";;
  esac
  if cmp -s "$fixture" "$fixture.new"; then
    printf 'mutation did not alter fixture: %s\n' "$name" >&2
    exit 1
  fi
  mv "$fixture.new" "$fixture"
  run_case "$name" 1
done
sha256sum --check --status "$out/reader-inputs.sha256"
printf 'one valid four-file synthetic receipt accepted with exact counts; all eight independent rejection controls passed\n' > "$out/passed.txt"
