#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Parser-only controls. Runs the C reader and synthetic generator, never Buster.
set -euo pipefail
export LC_ALL=C LC_NUMERIC=C
reader_source=$(realpath "${1:?read_grid.c}")
out=$(realpath -m "${2:?new output directory}")
here=$(cd "$(dirname "$0")" && pwd)
test ! -e "$out"
mkdir -p "$out/grid"
cc --version > "$out/compiler.txt"
sha256sum "$reader_source" "$here/generate-grid.c" "$0" > "$out/tested-inputs.sha256"
cc -std=c17 -O2 -Wall -Wextra -Werror "$reader_source" -o "$out/reader"
cc -std=c17 -O2 -Wall -Wextra -Werror "$here/generate-grid.c" -o "$out/generate"
"$out/generate" "$out/grid"
cp "$out/grid/time-plain-1.log" "$out/original.log"
logs=("$out"/grid/time-plain-{1,2,3}.log "$out"/grid/time-after-scalar-{1,2,3}.log)
printf 'case,expected,actual\n' > "$out/receipt.csv"
"$out/reader" "${logs[@]}" > "$out/positive.csv" 2> "$out/positive.stderr"
printf 'positive,0,0\n' >> "$out/receipt.csv"
for case in inf negative-counter overflow-counter zero-counter negative-wall overflow-wall missing duplicate stable-nonzero; do
  case "$case" in
    inf) sed '0,/100.000 ms wall/s//inf ms wall/' "$out/original.log" > "$out/grid/time-plain-1.log";;
    negative-counter) sed '0,/10000 user cycles/s//-1 user cycles/' "$out/original.log" > "$out/grid/time-plain-1.log";;
    overflow-counter) sed '0,/10000 user cycles/s//18446744073709551616 user cycles/' "$out/original.log" > "$out/grid/time-plain-1.log";;
    zero-counter) sed '0,/10000 user cycles/s//0 user cycles/' "$out/original.log" > "$out/grid/time-plain-1.log";;
    negative-wall) sed '0,/100.000 ms wall/s//-1.0 ms wall/' "$out/original.log" > "$out/grid/time-plain-1.log";;
    overflow-wall) sed '0,/100.000 ms wall/s//1e309 ms wall/' "$out/original.log" > "$out/grid/time-plain-1.log";;
    missing) sed '1d' "$out/original.log" > "$out/grid/time-plain-1.log";;
    duplicate) cat "$out/original.log" > "$out/grid/time-plain-1.log"; head -1 "$out/original.log" >> "$out/grid/time-plain-1.log";;
    stable-nonzero) sed 's/status 0/status 1/g' "$out/original.log" > "$out/grid/time-plain-1.log";;
  esac
  set +e
  "$out/reader" "${logs[@]}" > "$out/$case.csv" 2> "$out/$case.stderr"
  actual=$?
  set -e
  printf '%s,1,%s\n' "$case" "$actual" >> "$out/receipt.csv"
  test "$actual" -eq 1
done
sha256sum --check --status "$out/tested-inputs.sha256"
