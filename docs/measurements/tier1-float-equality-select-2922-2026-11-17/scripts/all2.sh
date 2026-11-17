#!/bin/bash
# The record's second round, detached: the final head's tree (f7bf49f9, the refined walk), then the kernels (5 rounds of
# base, final, always and clang -O2), sqlite3.c's compile and the corpora's code, base against final.
set -u
cd ~/buster-fast-bench/2922-claude
scripts/setup.sh claude/keen-edison-gg8qxt final=f7bf49f9be6fff3397b919a9a3fc85cb6ea35323 > setup2.log 2>&1
scripts/measure.sh kernels2 5 base final always > kernels2.log 2>&1
scripts/compile.sh compile2 base final > compile2.log 2>&1
scripts/corpus.sh corpus2 base final > corpus2.log 2>&1
echo done > all2.done
