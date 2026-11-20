#!/bin/bash
# assemble.sh FINAL BASE: copy the entries' values' piece's evidence into the record (idempotent): the builds and the
# counters, the experiments, the fault rounds, the probes, and with the final readings there (FINAL, the switch
# build's label, and BASE, the piece before's) the final readings, the cloud container's checks and sanitizers, and the
# generators as this session ran them.
set -e
k=/home/user/keep/values
s=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad/values
r=/home/user/buster-performance/docs/measurements/x-values-2850-2026-11-20
final=$1; base=$2
mkdir -p $r/builds/9700x $r/experiments $r/faults/raw $r/faults/checks $r/probes $r/final/9700x $r/final/cloud-checks/shadow $r/final/cloud-checks/probes $r/final/cloud-sanitizers $r/final/generators
# The builds.
for l in xb6 xv1 xv1s xv2 xv3 xv3s xv4 xv4p xv5 xv6 xv7p; do
    mkdir -p $r/builds/9700x/$l
    cp $s/fetch/results/$l/* $r/builds/9700x/$l/
done
cp $s/fetch/job-xv*.log $r/builds/9700x/
cp $s/fetch/turns.sh $s/fetch/turns-env.sh $s/fetch/build-label.sh $s/fetch/lock.sh $s/fetch/corpora.sh $r/builds/
cp $k/builds/xv-table.py $k/builds/counters.py $r/builds/
python3 $k/builds/xv-table.py $r/builds/9700x > $r/builds/xv-table.txt
python3 $k/builds/counters.py $r/builds/9700x > $r/builds/counters.txt
cp $s/fetch/functions.txt $r/builds/functions.txt
# The experiments on the terms the first fault round found implied.
rm -rf $r/experiments && mkdir -p $r/experiments
cp -r $k/experiments/object-kinds $k/experiments/start-two-after $k/experiments/number-calls $r/experiments/
cp $k/experiments/object-kinds.py $k/experiments/start-two-after.py $k/experiments/number-calls.py $r/experiments/
# The fault rounds.
cp $k/faults/make-faults-values.py $k/faults/faults-values-round1.py $k/faults/make-faults-values2.py $k/faults/faults-values-round2.py $k/faults/faults-values-round2.py.no-faults.txt $r/faults/
cp $k/faults/round2-indices.txt $k/faults/job-faults-values.sh $k/faults/local-round.sh $k/faults/syntax-check.sh $k/faults/join-round.py $r/faults/
cp $s/values-frozen.patch $r/faults/xvf1.patch
cp $s/xvf2.patch $r/faults/xvf2.patch
cp $s/round1-9700x/xvf1/round1.txt $r/faults/raw/round1-9700x.txt
cp $s/round1/round.txt $r/faults/raw/round1-cloud-from-the-end.txt
cp $s/round1b/round.txt $r/faults/raw/round1-cloud-from-260.txt
cp $s/round1c/round.txt $r/faults/raw/round1-cloud-from-170.txt
cp $s/round1-joined.txt $r/faults/round1-joined.txt
cp $s/round2-9700x/round2.txt $r/faults/round2.txt
for q in 2 3 4 5 6; do cp $s/quick$q/round.txt $r/faults/checks/check$q.txt; done
cat $s/syntax2/out*.txt | grep -v '^done' | sort -k2 -n > $r/faults/syntax-round2.txt
# The probes.
cp /home/user/keep/probes/probe.py /home/user/keep/probes/cases15.py /home/user/keep/probes/cases16.py /home/user/keep/probes/cases17.py /home/user/keep/probes/cases18.py /home/user/keep/probes/cases19.py \
    /home/user/keep/probes/cases20.py /home/user/keep/run-probes-values.sh /home/user/keep/run-probes.sh $r/probes/
# The final readings.
mkdir -p $r/final/9700x/$final $r/final/9700x/$base
cp $s/final-fetch/results/$final/* $r/final/9700x/$final/
cp $s/final-fetch/results/$base/* $r/final/9700x/$base/
cp $s/final-fetch/job-$final.log $r/final/9700x/
cp $k/final/job-xv.sh $k/final/xv-final-table.py $k/final/pins.py $r/final/
python3 $k/final/xv-final-table.py $r/final/9700x $final $base > $r/final/$final-table.txt
python3 $k/final/pins.py /home/user/buster-values/src/buster/compiler/c_check_node_census_test.c > $r/final/pins.txt
# The cloud container's checks, on the pull request's code's commit.
c=$s/checks6; o=$r/final/cloud-checks
cp /home/user/keep/checks-rows.sh /home/user/keep/shadow-limited.sh /home/user/keep/checker.sh $o/
cp $c/progress.txt $c/revision.txt $c/ownership.txt $o/
cp $c/shadow/status.txt $o/shadow/status.txt && cp $c/test-checker/status.txt $o/test-checker-status.txt && cp $c/modes/status.txt $o/modes-status.txt
for f in $c/shadow/*window-rows*.out; do grep -a '^node-shadow: window \(tests\|contexts\|rows\)' "$f" > $o/shadow/$(basename "$f"); done
for list in light heavy; do grep -a '^parallel:\|^== ' $c/complete-$list.log > $o/complete-$list-items.txt; done
grep -a 'differently\|^files:' $c/complete-light.log > $o/complete-light-the-preprocessor-against-clang.txt
cp $s/probes6/earlier.txt $s/probes6/cases9.txt $s/probes6/cases1[0-9].txt $s/probes6/cases20.txt $s/probes6/values.log $s/probes6/earlier.log $o/probes/
# The sanitizers' pass, when it has ended.
if grep -q '^all done' $s/san6/progress.txt 2>/dev/null; then
    cp $s/san6/progress.txt $s/san6/revision.txt $r/final/cloud-sanitizers/
    cp /home/user/keep/sanitizers-parts.sh $r/final/cloud-sanitizers/
fi
# The generators, as this session ran them.
cp $k/generators/gen-docs.py $k/generators/node-machine-section.md $k/generators/one-core-path-section.md $k/assemble.sh $r/final/generators/
[ -f $k/generators/gen-readme.py ] && cp $k/generators/gen-readme.py $r/final/generators/
[ -f $k/generators/apply-docs.py ] && cp $k/generators/apply-docs.py $r/final/generators/
cp $s/xv8x-final.patch $r/final/9700x/$final/$final.patch
du -sh $r | cut -f1
