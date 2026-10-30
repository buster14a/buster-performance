#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Parser-only canonical stage controls, no compiler image execution.
set -euo pipefail
export LC_ALL=C LC_NUMERIC=C
reducer=$(realpath "${1:?summarize-stages.sh}")
out=$(realpath -m "${2:?new output directory}")
here=$(cd "$(dirname "$0")" && pwd)
test ! -e "$out"
mkdir "$out"
cc --version > "$out/compiler.txt"
sha256sum "$reducer" "$here/generate-stages.c" "$0" > "$out/tested-inputs.sha256"
cc -std=c17 -O2 -Wall -Wextra -Werror "$here/generate-stages.c" -o "$out/generate"
printf 'case,expected,actual\n' > "$out/receipt.csv"
for case in positive wrong-filename missing duplicate-file duplicate-metric zero-value overflow-value bad-status; do
  fixture="$out/$case"
  mkdir -p "$fixture/stages" "$fixture/logs" "$fixture/held"
  "$out/generate" "$fixture"
  printf '0\n' > "$fixture/logs/semantic.status"
  printf '0\n' > "$fixture/logs/stages.status"
  case "$case" in
    wrong-filename) mv "$fixture/stages/run-0-0-base.stderr" "$fixture/stages/run-99-0-base.stderr";;
    missing) mv "$fixture/stages/run-0-0-base.stderr" "$fixture/held/omitted.stderr";;
    duplicate-file) cp "$fixture/stages/run-0-0-base.stderr" "$fixture/stages/run-99-0-base.stderr";;
    duplicate-metric) grep '^time-stage.*preprocess' "$fixture/stages/run-0-0-base.stderr" > "$fixture/held/duplicate.txt"; cat "$fixture/held/duplicate.txt" >> "$fixture/stages/run-0-0-base.stderr";;
    zero-value) sed 's/preprocess\t100.000/preprocess\t0.000/' "$fixture/stages/run-0-0-base.stderr" > "$fixture/held/mutant.txt"; cp "$fixture/held/mutant.txt" "$fixture/stages/run-0-0-base.stderr";;
    overflow-value) sed 's/preprocess\t100.000/preprocess\t999999999999999999999999999999999999999999/' "$fixture/stages/run-0-0-base.stderr" > "$fixture/held/mutant.txt"; cp "$fixture/held/mutant.txt" "$fixture/stages/run-0-0-base.stderr";;
    bad-status) printf '1\n' > "$fixture/logs/stages.status";;
  esac
  set +e
  bash "$reducer" "$fixture" > "$out/$case.csv" 2> "$out/$case.stderr"
  actual=$?
  set -e
  expected=1
  if test "$case" = positive; then expected=0; fi
  printf '%s,%s,%s\n' "$case" "$expected" "$actual" >> "$out/receipt.csv"
  test "$actual" -eq "$expected"
done
grep -q '^base,preprocess,11,105.000,100.000,110.000$' "$out/positive.csv"
grep -q '^candidate,preprocess,11,115.000,110.000,120.000$' "$out/positive.csv"
grep -q '^base-again,preprocess,11,125.000,120.000,130.000$' "$out/positive.csv"
sha256sum --check --status "$out/tested-inputs.sha256"
