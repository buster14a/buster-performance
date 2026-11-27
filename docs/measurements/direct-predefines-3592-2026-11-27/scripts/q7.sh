#!/bin/bash
d=~/buster-fast-bench/3586-claude2
cd $d
export EXCLUSIVE_OWNER=claude-3586 EXCLUSIVE_TITLE="Direct path predefines (#3586/#3592)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3586
~/buster-fast-bench/exclusive.sh timeout -k 5 600 ./build-variant.sh final final.patch
cd $d/equiv
EQUIV_JOBS=8 ~/buster-fast-bench/exclusive.sh timeout -k 5 900 ./run.sh $d/bin/compiler-main main.tsv > main.summary 2>&1
EQUIV_JOBS=8 ~/buster-fast-bench/exclusive.sh timeout -k 5 900 ./run.sh $d/bin/compiler-final final.tsv > final.summary 2>&1
cat final.summary
if cmp -s main.tsv final.tsv; then echo "EQUIVALENT: $(wc -l < final.tsv) units, $(awk -F'\t' '$6=="direct"' final.tsv | wc -l) direct"; else echo "DIFFERENT:"; diff main.tsv final.tsv | head -40; fi
echo Q7-DONE
