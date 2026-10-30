#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Read the producer's printed values without changing their scope or precision.
set -euo pipefail
export LC_ALL=C LC_NUMERIC=C
packet=$(realpath "${1:?packet directory}")
test "$(cat "$packet/logs/stages.status")" = 0
test "$(cat "$packet/logs/semantic.status")" = 0
expected=()
labels=(base candidate base-again)
for run in $(seq 0 10); do
  for slot in 0 1 2; do
    label=${labels[$(((slot + run) % 3))]}
    expected+=("$packet/stages/run-$run-$slot-$label.stderr")
  done
done
actual=("$packet/stages/"*.stderr)
test "${#actual[@]}" -eq 33
cmp <(printf '%s\n' "${expected[@]}" | sort) <(printf '%s\n' "${actual[@]}" | sort)
printf 'label,metric,samples,upper_median,min,max\n'
for label in base candidate base-again; do
  files=("$packet/stages/"*"-$label.stderr")
  test "${#files[@]}" -eq 11
  for metric in preprocess check-input check-program backend-setup lower total peak-rss-kb; do
    values=()
    for file in "${files[@]}"; do
      if [ "$metric" = peak-rss-kb ]; then tag=time-process; else tag=time-stage; fi
      value=$(awk -F '\t' -v tag="$tag" -v metric="$metric" '
        $1 == tag && $2 == metric { count++; value=$3 }
        END { if (count != 1 || value !~ /^[0-9]+([.][0-9]+)?$/ || !(value + 0 > 0) || !(value + 0 < 9007199254740992)) exit 1; print value }
      ' "$file")
      values+=("$value")
    done
    mapfile -t sorted < <(printf '%s\n' "${values[@]}" | sort -n)
    printf '%s,%s,11,%s,%s,%s\n' "$label" "$metric" "${sorted[5]}" "${sorted[0]}" "${sorted[10]}"
  done
done
