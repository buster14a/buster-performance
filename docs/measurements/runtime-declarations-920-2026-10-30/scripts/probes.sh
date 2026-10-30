#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Real-input full-token oracle and count diagnostics; never used for timing.
set -euo pipefail
. "$(dirname "$0")/env.sh"
cd "$Q"
test "$(cat logs/semantic.status)" = 0
sha256sum --check --status manifests/executables.sha256
test ! -e diagnostics
mkdir diagnostics
trap 'status=$?; printf "%s\n" "$status" > "$Q/logs/diagnostics.status"' EXIT
ulimit -c 0
for corpus in sqlite lua; do
  declare -n input=$corpus
  for kind in base candidate; do
    for state in native scalar; do
      setting=()
      [ "$state" != scalar ] || setting=(--scalar)
      stem="$Q/diagnostics/$corpus-$kind-$state"
      argv=(taskset -c 2 "$Q/probes/$kind/compiler" "${input[@]}" --lanes 1 "${setting[@]}" -o "$stem.o")
      printf '%s\0' "${argv[@]}" > "$stem.argv.nul"
      "${argv[@]}" > "$stem.stdout" 2> "$stem.stderr"
      cmp "semantic/$corpus-base-0.o" "$stem.o"
      test "$(grep -c '^runtime-scan ' "$stem.stderr")" = 1
      test "$(grep -c '^runtime-slots ' "$stem.stderr")" = 1
      grep '^runtime-slots ' "$stem.stderr" | sed 's/mode=base/mode=table/;s/mode=candidate/mode=table/' > "$stem.slots"
      cmp "diagnostics/$corpus-base-native.slots" "$stem.slots"
      if [ "$kind" = candidate ]; then grep -q 'oracle-equal=1$' "$stem.stderr"; fi
      sha256sum "$stem.o"
    done
  done
  "$Q/proof-tools/read-runtime-probe" "$corpus" \
    "diagnostics/$corpus-base-native.stderr" "diagnostics/$corpus-base-scalar.stderr" \
    "diagnostics/$corpus-candidate-native.stderr" "diagnostics/$corpus-candidate-scalar.stderr" \
    > "diagnostics/$corpus-counts.csv"
  unset -n input
done
stem="$Q/diagnostics/sqlite-mutant"
argv=(taskset -c 2 "$Q/probes/candidate-mutant/compiler" "${sqlite[@]}" --lanes 1 -o "$stem.o")
printf '%s\0' "${argv[@]}" > "$stem.argv.nul"
set +e
"${argv[@]}" > "$stem.stdout" 2> "$stem.stderr"
status=$?
set -e
printf '%s\n' "$status" > "$stem.status"
test "$status" -ne 0
grep -q 'oracle-equal=0$' "$stem.stderr"
grep -q '^runtime-scan full-token oracle mismatch$' "$stem.stderr"
test ! -s "$stem.o"
printf 'eight diagnostic objects equal ordinary outputs; full-token table oracle passes; corrupted-copy control refused status=%s\n' "$status"
