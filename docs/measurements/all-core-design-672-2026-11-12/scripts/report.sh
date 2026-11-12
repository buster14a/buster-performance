#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# report.sh: results/tables' tables as one Markdown file, results/tables.md, for the record's README to quote: every
# .tsv there as a table, in name order, each under its file's name. No run; it only formats.
set -u
cd "$(dirname "$0")"
T=results/tables
{
    echo "# The tables (tables.sh's, from results/ alone)"
    for file in "$T"/*.tsv; do
        echo
        echo "## $(basename "$file")"
        echo
        awk -F'\t' '
            /^#/ { print "_" substr($0, 3) "_"; print ""; next }
            !header { n = NF; line = "|"; rule = "|"; for (i = 1; i <= NF; i += 1) { line = line " " $i " |"; rule = rule (i == 1 ? " --- |" : " ---: |") } print line; print rule; header = 1; next }
            { line = "|"; for (i = 1; i <= n; i += 1) line = line " " $i " |"; print line }' "$file"
    done
} > results/tables.md
wc -l results/tables.md
