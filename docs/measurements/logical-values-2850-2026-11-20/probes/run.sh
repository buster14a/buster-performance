#!/bin/bash
# The piece's probes and every earlier piece's through the frozen build (e93eb1e9c), one file at a time beside the sanitizers.
S=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad
c=$S/lchecks/compiler
out=$S/lpf
sha256sum $c > $out/compiler.sha256
python3 /home/user/keep/probes/probe.py $c /home/user/keep/probes/cases21.py > $out/cases21.txt
echo "cases21 lines $(wc -l < $out/cases21.txt); that do not agree: $(grep -vc ' status 0 .*refused [0-9]* diff 0 .*entries [0-9]* diff 0 .*values alone 0 listed [0-9]* numbered [0-9]*$' $out/cases21.txt)" > $out/summary.txt
grep '^baseline' $out/cases21.txt > $out/baseline.txt
python3 /home/user/keep/logical/probe-summary.py $out/baseline.txt $out/cases21.txt > $out/summary21.txt 2>&1
bash /home/user/keep/run-probes-values.sh $c $out/values >> $out/summary.txt 2>&1
bash /home/user/keep/run-probes.sh $c $out/earlier >> $out/summary.txt 2>&1
echo "probes done" >> $out/summary.txt
