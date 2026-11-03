#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# ab2.sh: after campaign.sh, main (base) against head2 and main again, each executable from 3 fresh copies, one input
# per time-runs process, which ab locks on its own.
cd ~/buster-fast-bench/652-claude
until grep -q '^done' campaign.log 2>/dev/null; do sleep 10; done
cd in
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="solve 652" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
mkdir -p ~/.cache/claude-652-copies
B="--build base ../base/build/compiler --build head2 ../head2/build/compiler --build base-again ../base/build/compiler"
run() {
    local rounds=$1 runs=$2; shift 2
    ../head2/build/compiler ab --rounds "$rounds" --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ../head2/build/compiler \
        -- time-runs --runs "$runs" --copies 3 --directory ~/.cache/claude-652-copies $B --list "$@"
}
run 3 31 -fsyntax-only empty.c
run 3 31 -E -P empty.c -o /dev/null
run 3 31 -c tiny.c -o tiny.o
run 3 7 -c sqlite3.c -o sqlite3.o
echo done
