#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# tables.sh: builds the reducer (reduce.c) and makes tables/ from results/: the rounds and medians by page state of
# musl's command and of sqlite3.c, and the stage reports' lanes and total lines (a command of several units reports
# their run as one stage, lanes), from the reports as written or gzipped. Run it under the lock (it compiles).
set -u
cd "$(dirname "$0")"
mkdir -p tables build
cc -O2 -Wall -Werror -o build/reduce reduce.c
build/reduce results/musl > tables/musl.tsv
build/reduce results/sqlite > tables/sqlite.tsv
if [[ -d results/stages ]]; then
    {
        echo "run	stage	ms"
        for f in results/stages/stages-*.txt*; do
            n=${f##*/stages-}; n=${n%.gz}; n=${n%.txt}
            zcat -f "$f" | grep -P '^time-stage\t(lanes|total)\t' | cut -f2,3 | sed "s/^/$n	/"
        done
    } > tables/stages.tsv
fi
