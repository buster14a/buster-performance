#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# tables.sh RAW TABLES: the record's reductions, made from RAW (the host's results directory, as the record keeps it)
# into TABLES by the record's tools, built here; no measurement, so it runs anywhere.
#   NAME.tsv                  each list's runs, a line per label (tools/medians)
#   clocks/LIST/LABEL.tsv     each clock list's captured reports, a line per phase (tools/phasemedians); a line of
#                             several commands is its last command's report
#   stages-c.tsv, -cg.tsv     the samples of -c and -c -g by stage, with each stage's functions (tools/stagebuckets)
#   musl-c.tsv, -cg.tsv       musl's -c and -c -g by function
set -u
here=$(cd "$(dirname "$0")" && pwd)
raw=${1:?the raw results}
tables=${2:?the tables}
bin=$(mktemp -d)
for tool in medians phasemedians stagebuckets; do
    cc -O2 -o "$bin/$tool" "$here/tools/$tool.c" || exit 1
done
mkdir -p "$tables"
for runs in "$raw"/*/runs.tsv; do
    name=$(basename "$(dirname "$runs")")
    "$bin/medians" "$runs" > "$tables/$name.tsv"
done
for list in "$raw"/*clocks*/ "$raw"/musl-build-*/ "$raw"/busy-*/; do
    name=$(basename "$list")
    labels=$(ls "$list" | sed -n 's/^[0-9]*-\(.*\)-[0-9]*\.[0-9]*\.err$/\1/p' | sort -u)
    for label in $labels; do
        mkdir -p "$tables/clocks/$name"
        last=$(ls "$list" | sed -n "s/^[0-9]*-$label-[0-9]*\.\([0-9]*\)\.err\$/\1/p" | sort -n | tail -1)
        # A label's own reports: ROUND-LABEL-RUN.STEP.err, the run a number (another label may only add words to it).
        "$bin/phasemedians" "$list"/[0-9]*-"$label"-[0-9]*."$last".err > "$tables/clocks/$name/$label.tsv"
    done
done
if [[ -d $raw/stagecounters ]]; then
    for variant in c cg; do
        arguments=()
        for stages in "$raw"/stagecounters/$variant-*.stages.txt; do
            arguments+=("$stages" "${stages%.stages.txt}.samples.gz")
        done
        "$bin/stagebuckets" --functions 40 --merge tier0 code-atoms emission --prefix check_debug --prefix debug_ --prefix check_lower "${arguments[@]}" > "$tables/stages-$variant.tsv"
    done
fi
if [[ -d $raw/muslprofile ]]; then
    for variant in c cg; do
        arguments=()
        for samples in "$raw"/muslprofile/$variant-*.samples.gz; do
            arguments+=(- "$samples")
        done
        "$bin/stagebuckets" --functions 60 --prefix check_debug --prefix debug_ --prefix check_lower --prefix object_ "${arguments[@]}" > "$tables/musl-$variant.tsv"
    done
fi
rm -rf "$bin"
