#!/bin/bash
# Every probe file through a build: run.sh COMPILER OUT
S=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad
c=$1; out=$2
mkdir -p $out
sha256sum $c > $out/compiler.sha256
for k in 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1; do
    python3 /home/user/keep/probes/probe.py $c /home/user/keep/probes/cases$k.py > $out/cases$k.txt 2> $out/cases$k.err &
    while [ "$(jobs -r | wc -l)" -ge 2 ]; do wait -n; done
done
wait
agree=' status 0 .*refused [0-9]* diff 0 .*entries [0-9]* diff 0 .*values alone 0 .*compared [0-9]* program-refs [0-9]* diff refs 0 facts 0 folds 0 truths 0$'
{
    echo "cases: $(cat $out/cases*.txt | wc -l); of them the piece's (cases22 to 25): $(cat $out/cases22.txt $out/cases23.txt $out/cases24.txt $out/cases25.txt | wc -l)"
    echo "lines that do not agree: $(cat $out/cases*.txt | grep -vc "$agree")"
    echo "probes done"
} > $out/summary.txt
