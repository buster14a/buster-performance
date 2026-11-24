#!/bin/bash
# Mutation round on LICM's remaining code after the deletion: each mutant built (Develop), then test-ir-licm,
# test-ir-optimize and test-ir-source --passes on c-testsuite's subset; killed if any fails.
set -u
D=$(dirname "$0")
cd /home/user/buster
F=src/buster/compiler/ir_optimize_licm.c
CT="$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt | tr '\n' ' ')"
for m in $(python3 -I $D/mutants.py list x); do
    git checkout -q -- $F
    if ! python3 -I $D/mutants.py $m $F > $D/$m.apply 2>&1; then echo "$m not-applied" >> $D/results.txt; continue; fi
    start=$(date +%s)
    if ! ./build.sh > $D/$m.build 2>&1; then echo "$m not-built" >> $D/results.txt; continue; fi
    built=$(( $(date +%s) - start ))
    killed=""
    timeout 600 ./build/compiler test-ir-licm > $D/$m.licm 2>&1 || killed="$killed licm($?)"
    timeout 900 ./build/compiler test-ir-optimize > $D/$m.optimize 2>&1 || killed="$killed optimize($?)"
    timeout 900 ./build/compiler test-ir-source --passes $CT > $D/$m.source 2>&1 || killed="$killed source($?)"
    if [ -n "$killed" ]; then echo "$m killed:$killed build=${built}s" >> $D/results.txt; else echo "$m SURVIVED build=${built}s" >> $D/results.txt; fi
done
git checkout -q -- $F
./build.sh > $D/restore.build 2>&1; echo "restore build: $?" >> $D/results.txt
echo done >> $D/results.txt
