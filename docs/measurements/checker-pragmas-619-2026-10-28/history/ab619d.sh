#!/bin/bash
# After the suites and the profile: ab's rotating rounds of time-runs of -fsyntax-only and -c of the frozen sqlite3.c,
# main (base) against head3, each run under its own hold of the lock (ab --lock), pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #619 time-runs, main against head3" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/619
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export TMPDIR=~/buster-fast-bench/claude-126-cloud/ab619/tmp
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
check=(--clang-features "${lower[@]}")
cd ~/buster-fast-bench/claude-126-cloud/ab619
until grep -q "after done" tests619.log 2>/dev/null; do sleep 10; done
./head3/build/compiler ab --rounds 5 --cpu 2 --lock $lock base head3 -- time-runs --runs 11 --list -fsyntax-only "${check[@]}" --list -c -o /dev/null "${lower[@]}" > ab3.log 2>&1
echo "ab3 status $?"
