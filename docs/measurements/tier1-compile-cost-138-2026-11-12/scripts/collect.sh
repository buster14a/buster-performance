#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# collect.sh HOST RAW: the part of the host's directory (HOST: the session's directory on the 9700X, or a copy of it,
# with results/ and the queue and build logs) that the record keeps, into RAW. Every experiment's small files whole:
# runs.tsv and peaks.tsv with their logs, the reports, the holders, the executables' and objects' hashes, the functions
# that differ (but the superseded first baseline's per-unit stage reports of musl). Of the large ones, recompressed
# from gzip to xz:
#   laps/                    every --tier1 lap log (the stage tables are made of them) and the first default one;
#   stagecounters/           the first run of each group (samples, lap log, perf's log) of six;
#   stagecounters-batch64/   the first run of the td group;
#   prototype/               sqlite3.c's "two" lap log, whose G lines say what became of every second allocation;
#   prototype5/              each corpus's "two" log, whose G lines the verdict's prefix was sized from;
#   prototype7/              sqlite3.c's first "quiet" log;
#   prototype8/              the first lap log of each configuration for sqlite3.c.
# The tables were made from all of the host's results (tables.sh), not from this part.
set -eu
host=${1:?the host directory}
raw=${2:?the raw directory}
mkdir -p "$raw"
keep() {
    # keep FILE: RAW's copy of HOST/results/FILE, a .gz as .xz.
    local from=$host/results/$1 to=$raw/$1
    mkdir -p "$(dirname "$to")"
    if [[ $from == *.gz ]]; then
        gzip -dc "$from" | xz -9e -T1 > "${to%.gz}.xz"
    else
        cp "$from" "$to"
    fi
}
(cd "$host/results" && find . -type f ! -name '*.gz' ! -name '.done' ! -path './baseline/musl-*' -size -400k | sed 's|^\./||' | sort) | while IFS= read -r f; do keep "$f"; done
for c in sqlite lua musl; do
    for f in "$host"/results/laps/$c/tier1-*.laps.gz; do keep "laps/$c/${f##*/}"; done
    keep "laps/$c/default-1.laps.gz"
    keep "prototype5/$c/two.laps.gz"
done
for g in work td lat mem; do
    for kind in samples laps; do keep "stagecounters/sqlite/$g-1.$kind.gz"; done
done
for kind in samples laps; do keep "stagecounters-batch64/sqlite/td-1.$kind.gz"; done
keep prototype/sqlite/two.laps.gz
keep prototype7/sqlite/quiet-1.laps.gz
for v in two shared prefix inline; do keep "prototype8/sqlite/$v-1.laps.gz"; done
mkdir -p "$raw/logs"
cp "$host"/q-*.log "$host"/build-*.log "$host"/COMMIT "$raw/logs/" 2>/dev/null || true
du -sh "$raw"
