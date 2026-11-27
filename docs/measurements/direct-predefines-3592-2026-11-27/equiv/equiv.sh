#!/bin/bash
# equiv.sh BASE HEAD: bin/compiler-BASE and bin/compiler-HEAD over the corpus (run.sh); the rows that differ.
set -uo pipefail
d=$HOME/buster-fast-bench/3586-claude2
cd $d/equiv
./run.sh $d/bin/compiler-$1 $1.tsv > $1.summary 2>&1
./run.sh $d/bin/compiler-$2 $2.tsv > $2.summary 2>&1
cat $2.summary
if cmp -s $1.tsv $2.tsv; then echo "EQUIVALENT: $(wc -l < $2.tsv) units, $(awk -F'\t' '$6=="direct"' $2.tsv | wc -l) direct"; else echo "DIFFERENT:"; diff $1.tsv $2.tsv | head -40; fi
