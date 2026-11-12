#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# units.sh: scratch/musl-units.txt, musl's units (common.sh's musl_units), and how many of them have an asm statement in
# their source or the headers they include (as -E -P of each by main's build shows it). No compiler run but -E: run it
# under the lock (lock.sh).
set -u
cd "$(dirname "$0")"
. ./common.sh
mkdir -p scratch results
musl_units > scratch/musl-units.txt
wc -l < scratch/musl-units.txt > results/musl-units.txt
compiler=$(compiler_of main)
count=0
while read -r f; do
    if taskset -c 2 "$compiler" "${musl_options[@]}" -E -P "$f" 2> /dev/null | grep -q '__asm__\|\basm\b'; then count=$((count + 1)); fi
done < scratch/musl-units.txt
echo "$count" > results/units-with-asm.txt
