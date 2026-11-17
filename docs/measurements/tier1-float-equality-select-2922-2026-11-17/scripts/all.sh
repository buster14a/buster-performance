#!/bin/bash
# The record's runs in order, detached: the kernels (5 rounds), sqlite3.c's compile, the corpora's code.
set -u
cd ~/buster-fast-bench/2922-claude
while [ ! -f setup.done ]; do sleep 10; done
scripts/measure.sh kernels 5 > kernels.log 2>&1
scripts/compile.sh compile base head > compile.log 2>&1
scripts/corpus.sh corpus base head > corpus.log 2>&1
echo done > all.done
