#!/bin/bash
# run2.sh SPLIT_REV HEAD_REV: the record at the rebased commit, each step's runs in holds of their own: the split's head
# (the commit's parent) and the commit built, the commit's corpora compared (main's were, in results/main), both timed,
# -c A/B between them, and c-testsuite's subset and main.c compared by main's and the commit's compilers.
set -u
cd "$(dirname "$0")"
./build.sh split "$1"
./build.sh head "$2"
./corpora.sh head
./time.sh split
./time.sh head
./ab.sh split head
./extra.sh main head
date -u +%FT%TZ > results/.all-done-2
