#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# tables.sh: the record's tables, made again from its raw files (no run, no lock): run it in the record's scripts
# directory; it reads ../raw and writes ../tables.
set -u
cd "$(dirname "$0")"
raw=../raw
out=../tables
mkdir -p "$out"
python3 tools/rank.py "$raw" > "$out/ranking.tsv"
python3 tools/probe_table.py "$raw/probe" musl ms cycles-u instructions-u cycles-k dram-fills > "$out/musl-stages.tsv"
python3 tools/probe_table.py "$raw/probe" sqlite ms cycles-u instructions-u cycles-k dram-fills > "$out/sqlite-stages.tsv"
python3 tools/probe_table.py "$raw/glibc" glibc ms cycles-u instructions-u cycles-k > "$out/glibc-stages.tsv"
python3 tools/probe_table.py "$raw/semi" musl ms cycles-u cycles-k > "$out/musl-emulation-stages.tsv"
python3 tools/probe_table.py "$raw/semi" glibc ms cycles-u cycles-k > "$out/glibc-emulation-stages.tsv"
python3 tools/probe_table.py "$raw/asm" musl ms cycles-u cycles-k > "$out/asm-stages.tsv"
(cd "$raw/profile" && python3 ../../scripts/tools/families.py c.work.tsv i-c.work.tsv spine-c.work.tsv empty-c.work.tsv --top 50) > "$out/musl-families.tsv"
(cd "$raw/profile" && python3 ../../scripts/tools/families.py sqlite-i.work.tsv sqlite-spine.work.tsv --top 50) > "$out/sqlite-families.tsv"
{
    for variant in c spine-c empty-c; do
        echo "## musl $variant: the kernel's cycles by what entered it (inclusive shares of the kernel's samples)"
        grep -E '\[.\] (asm_exc_page_fault|__x64_sys_[a-z0-9_]+|__do_sys_newfstatat|clear_page_erms|do_anonymous_page|unmap_page_range)$' "$raw/profile/$variant.kernel-inclusive.txt" | sort -t% -k1 -rn | head -16
        echo "## musl $variant: its system calls (strace -c: the counts)"
        awk 'NR > 2 && $4 + 0 > 0 { print $4 "\t" $NF }' "$raw/syscalls/$variant.strace.txt" | head -14
    done
} > "$out/kernel.txt"
python3 tools/repeats.py "$raw/prep/musl-declarations.tsv" > "$out/musl-repeats.tsv"
{
    echo "## musl, by kind (units.py)"; grep '^#' "$raw/prep/musl-census.tsv"
    echo "## sqlite3.c, by kind"; grep '^#' "$raw/prep/sqlite-census.tsv"
    echo "## musl: tokens in function bodies, in file-scope braces, in the rest of file scope"
    awk -F'\t' 'NR > 1 && $1 !~ /^#/ { t += $2; b += $3; r += $4; f += $5; n += $6; d += $7 } END { print t "\t" b "\t" r "\t" f "\tbodies " n "\tdeclarations " d }' "$raw/prep/musl-census.tsv"
} > "$out/census.txt"
{
    for report in live2/attest-musl.tsv live2/attest-musl-warm.tsv live2/attest-sqlite-warm.tsv glibc/attest-glibc.tsv; do
        echo "## $report"; grep '^#' "$raw/$report"
    done
    echo "## objects and diagnostics"
    echo "live (the tokens blanked):"; cat "$raw/live/objects.txt"
    echo "live2 (a placeholder a token):"; cat "$raw/live2/objects.txt"
    echo "glibc, first list of keywords:"; cat "$raw/glibc-first/objects.txt"
    echo "glibc:"; cat "$raw/glibc/objects.txt"
    echo "asm index, once against each unit:"; cat "$raw/asm/objects.txt"
} > "$out/emulation.txt"
{
    for directory in musl musl-pass1 live live2 semi glibc asm fixed; do
        echo "## $directory"; python3 tools/stat_medians.py "$raw/$directory"
    done
} > "$out/medians.txt"
{
    for run in chain/musl-1 chain/sqlite-1 chain2/musl-scan-1 chain2/sqlite-scan-warm-1 chain3/musl-lists-1 chain3/musl-scan-1 chain3/musl-scan-warm-1 chain3/sqlite-scan-1 chain3/sqlite-scan-warm-1 chain3/musl-check chain3/sqlite-check; do
        echo "## $run"; cat "$raw/$run.txt"
    done
} > "$out/prototype.txt"
python3 tools/gains.py "$raw" > "$out/gains.txt"
