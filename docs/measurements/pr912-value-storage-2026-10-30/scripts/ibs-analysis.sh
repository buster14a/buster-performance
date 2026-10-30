#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
source "$(dirname "$0")/environment.sh"
variant=$1
case "$variant" in base|candidate) ;; *) exit 2 ;; esac
cd "$Q"
perf report --stdio --no-children --percent-limit 0 -i "evidence/ibs-$variant.data" > "evidence/ibs-$variant.report.txt" 2> "evidence/ibs-$variant.report.stderr"
perf script -i "evidence/ibs-$variant.data" -F ip,sym,symoff,dso \
  > "evidence/ibs-$variant.script.txt" 2> "evidence/ibs-$variant.script.stderr"
perf script -d -i "evidence/ibs-$variant.data" -F event > /dev/null 2> "evidence/ibs-$variant.integrity.txt"
perf script -D -i "evidence/ibs-$variant.data" 2> "evidence/ibs-$variant.raw-decode.stderr" | \
  awk '/PERF_RECORD_LOST/ { print; lost++; } END { printf "lost_record_count %d\n", lost; exit lost != 0; }' \
  > "evidence/ibs-$variant.loss-records.txt"
awk '
  FNR == NR {
    parts=split($0, fields, "\t");
    sub(/^[[:space:]]+/, "", fields[3]);
    split(fields[3], instruction, /[[:space:]]+/);
    if (parts >= 3 && instruction[1] ~ /^f[a-z0-9]+$/) {
      address=$1; sub(/:$/, "", address); x87[address]=1;
    }
    next;
  }
  { total++; }
  $2 ~ /^(check_input_expressions|check_literal_value)(\+|$)/ {
    address=$1; sub(/^0+/, "", address); function_samples++;
    if (address in x87) { x87_samples++; }
    counts[address]++;
  }
  END {
    printf "all_script_samples %d\ntarget_function_samples %d\ntarget_x87_samples %d\n", total, function_samples, x87_samples;
    for (address in counts) { printf "%s %d %s\n", address, counts[address], address in x87 ? "x87" : "other"; }
  }
' "evidence/assembly-$variant.txt" "evidence/ibs-$variant.script.txt" > "evidence/ibs-$variant.counts.txt"
awk 'NR == 2 { if ($2 <= 0) { exit 1; } }' "evidence/ibs-$variant.counts.txt"
grep -E 'check_input_expressions|check_literal_value' "evidence/ibs-$variant.script.txt" > "evidence/ibs-$variant.targets.txt" || true
zstd -q -f "evidence/ibs-$variant.data" -o "evidence/ibs-$variant.data.zst"
sha256sum "evidence/ibs-$variant.data" "evidence/ibs-$variant.data.zst"
head -3 "evidence/ibs-$variant.counts.txt"
