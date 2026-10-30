#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Synthetic parser controls made from one retained record, no hardware run.
set -euo pipefail
packet=$(cd "$(dirname "$0")/.." && pwd)
fixture=$(realpath "${1:?new fixture directory}")
test ! -e "$fixture"
mkdir "$fixture"
cc --version | head -1
cc -std=c17 -O2 -Wall -Wextra -Werror "$packet/proof-tools/read_grid.c" -o "$fixture/reader"
sha256sum "$fixture/reader" "$packet/proof-tools/read_grid.c"
source_log="$packet/logs/time-plain-1.log"
for state in plain after-scalar; do
  for round in 1 2 3; do cp "$source_log" "$fixture/time-$state-$round.log"; done
done
grid=("$fixture"/time-plain-{1,2,3}.log "$fixture"/time-after-scalar-{1,2,3}.log)
printf 'synthetic positive grid: '
"$fixture/reader" "${grid[@]}" > /dev/null
sed '/^run 1 list 1 base placement 1 copy 1:/d' "$source_log" > "$fixture/time-plain-1.log"
printf 'missing-cell negative: '
if "$fixture/reader" "${grid[@]}" > /dev/null; then exit 1; fi
cp "$source_log" "$fixture/time-plain-1.log"
sed -n '/^run /{p;q;}' "$source_log" >> "$fixture/time-plain-1.log"
printf 'duplicate-cell negative: '
if "$fixture/reader" "${grid[@]}" > /dev/null; then exit 1; fi
sed 's/instructions, status 0/instructions, status 1/g' "$source_log" > "$fixture/time-plain-1.log"
printf 'stable-nonzero-status negative: '
if "$fixture/reader" "${grid[@]}" > /dev/null; then exit 1; fi
printf 'all reader controls passed\n'
