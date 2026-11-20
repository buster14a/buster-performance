#!/bin/bash
# census-own.sh: on the 9700X, the values' census on the compiler's own source (the working tree's main.c, the census's
# patch in it), one run under the lock, and its simulation.
cd ~/buster-fast-bench/2850-values-claude/trees/xrd || exit 1
BUSTER_CENSUS_V=1 ../../lock.sh bash -c "taskset -c 2 ./build/compiler measure-node-machine --shadow --passes 0 --window-rows --list 12 -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h src/buster/compiler/main.c; echo status \$?" > ../../results/xrd/corpus-own.txt 2>&1
cd ../.. || exit 1
grep -a '^x[vh]' results/xrd/corpus-own.txt > census/own.tsv
grep -a -v '^x[vh]' results/xrd/corpus-own.txt > census/corpus-own.txt
python3 simulate-values.py census/own.tsv > census/sim-own.txt 2>&1
python3 check-strides.py census/own.tsv > census/check-strides-own.txt 2>&1
wc -l census/own.tsv >> census/lines.txt
echo own-done
