#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -euo pipefail
cd "$(dirname "$0")/.."
export EXCLUSIVE_OWNER=codex-596
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/627
root=$PWD
lock="$HOME/buster-fast-bench/exclusive.sh"
cd "$root/record"
mkdir -p aa/objects
printf '%s  %s\n' cde1420d71e3099dea0682350c4eab1b015873bef2ba2a1bf79a60e8c64e9da8 ../base/build/compiler | sha256sum -c -
sha256sum ../base/build/compiler compare compare.c > aa/identities-before.sha256
date -u > aa/start.txt
for round in 0 1 2; do
    EXCLUSIVE_TITLE="Buster #596 identical-base control round $round" "$lock" taskset -c 2 ./compare \
        "$root/base/build/compiler" "$root/base/build/compiler" "$root/record/inputs" "$root/record/aa/objects" "$round" \
        "$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c" > "aa/round-$round.tsv" 2> "aa/round-$round.err"
done
sha256sum ../base/build/compiler compare compare.c > aa/identities-after.sha256
cmp aa/identities-before.sha256 aa/identities-after.sha256
for object in aa/objects/*-base.o; do
    cmp "$object" "${object%-base.o}-head.o"
done
sha256sum aa/objects/*.o > aa/object-identities.sha256
date -u > aa/complete.txt
