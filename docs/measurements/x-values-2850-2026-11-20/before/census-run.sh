#!/bin/bash
# census-run.sh: on the 9700X, the values' census: the working tree with the census's patch (an incremental Develop
# build and test-checker's part 5, dev-xr.sh), its shadow on the three corpora with the census's lines on, and the
# simulation of the candidate rules over each corpus's lines and over the three together.
cd ~/buster-fast-bench/2850-values-claude || exit 1
./dev-xr.sh census-values.patch 5ee22d6a5 > dev-census.log 2>&1 || { echo BUILD-FAILED; tail -5 dev-census.log; exit 1; }
BUSTER_CENSUS_V=1 ./dev-xr-corpora.sh > census-corpora.log 2>&1
mkdir -p census
for c in sqlite3 lua musl; do grep -a '^x[vh]' results/xrd/corpus-$c.txt > census/$c.tsv; done
for c in sqlite3 lua musl; do python3 simulate-values.py census/$c.tsv > census/sim-$c.txt 2>&1; done
python3 simulate-values.py census/sqlite3.tsv census/lua.tsv census/musl.tsv > census/sim-three.txt 2>&1
wc -l census/*.tsv > census/lines.txt
echo census-done
