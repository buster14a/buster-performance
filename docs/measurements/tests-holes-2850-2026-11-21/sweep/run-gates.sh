#!/bin/bash
# run-gates.sh TAG COMPILER [PARTS]: the holes' campaign's runs of one build in the cloud container, a directory of
# results (scratchpad/holes/TAG): the sweep of the compiler's own tests' programs and of tests/ under three warning
# sets, timed; the four corpora with no option and with -Wall -Wextra; the generator's six runs; every one-statement
# program of the probes (cases1 to cases26); and the warnings' triggers. PARTS names the ones to run (default all):
# sweep corpora fuzz probes triggers. One heavy thing at a time: the compiler's own source takes 5 GB a run.
S=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad
tag=$1; compiler=$2; parts=${3:-"sweep corpora fuzz probes triggers"}
out=$S/holes/$tag
mkdir -p $out
cd /home/user/buster-values
for part in $parts; do
    case $part in
        sweep)
            start=$(date +%s)
            bash $S/holes/run-sweep.sh $tag $compiler > $out/sweep.log 2>&1
            echo $(( $(date +%s) - start )) > $out/sweep-seconds.txt ;;
        corpora)
            rm -rf $out/shadow
            bash $S/holes/run-corpora.sh $tag $compiler > $out/corpora.log 2>&1 ;;
        fuzz)
            rm -rf $out/fuzz
            bash /home/user/keep/holes/fuzz-campaign.sh $compiler $out/fuzz > $out/fuzz.log 2>&1 ;;
        probes)
            rm -rf $out/probes; mkdir -p $out/probes
            for k in $(seq 1 26); do
                echo "python3 /home/user/keep/probes/probe.py $compiler /home/user/keep/probes/cases$k.py > $out/probes/cases$k.txt 2> $out/probes/cases$k.err"
            done | xargs -P 4 -I{} bash -c "{}" ;;
        triggers)
            cp $S/holes/ids.json $out/ids.json
            python3 /home/user/keep/holes/triggers.py $compiler $out/triggers $out/inline-default.tsv $out/tests-default.tsv $out/inline-wall.tsv $out/tests-wall.tsv \
                $out/inline-everything.tsv $out/tests-everything.tsv > $out/triggers.txt 2>&1 ;;
    esac
    echo "$part done" >> $out/gates.txt
done
echo "gates exit 0" >> $out/gates.txt
