#!/bin/bash
# assemble-record.sh: the piece's evidence into buster-performance's record directory (re-runnable: it copies over).
set -eu
S=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad
K=/home/user/keep/logical
R=/home/user/buster-performance/docs/measurements/logical-values-2850-2026-11-20
mkdir -p $R/builds $R/final/9700x $R/final/cloud-checks $R/final/cloud-sanitizers $R/final/generators $R/faults $R/probes
# The builds: the 9700X's job, its scripts and the two first builds' readings.
cp $K/9700x/job-xl.sh $K/9700x/xl-table.py $K/9700x/xl1.patch $K/9700x/xl2.patch $R/builds/
for b in xl1 xl2; do rm -rf $R/builds/$b; cp -r $K/9700x/$b $R/builds/$b; done
[ -d $S/9700x-scripts ] && cp $S/9700x-scripts/* $R/builds/
# The final readings.
rm -rf $R/final/9700x/results; cp -r $S/xl3/results $R/final/9700x/results
cp $S/xl3/table.txt $S/xl3/job-xl3.log $S/xl3.patch $R/final/9700x/
# The cloud container's checks of the frozen commit.
C=$S/lchecks
cp $C/progress.txt $C/revision.txt $C/build.log $C/check-call-graph.txt $C/test-call-graph.txt $C/ownership.txt $C/complete-heavy.log $C/complete-light.log $R/final/cloud-checks/
rm -rf $R/final/cloud-checks/shadow $R/final/cloud-checks/modes $R/final/cloud-checks/test-checker $R/final/cloud-checks/complete-lists
mkdir -p $R/final/cloud-checks/shadow $R/final/cloud-checks/modes $R/final/cloud-checks/test-checker $R/final/cloud-checks/complete-lists
cp $C/shadow/*.out $C/shadow/status.txt $R/final/cloud-checks/shadow/
find $C/shadow -name '*.err' -size +0 -exec cp {} $R/final/cloud-checks/shadow/ \;
cp $C/modes/*.out $R/final/cloud-checks/modes/ 2>/dev/null || true
[ -f $C/modes/status.txt ] && cp $C/modes/status.txt $R/final/cloud-checks/modes/
find $C/modes -name '*.err' -size +0 -exec cp {} $R/final/cloud-checks/modes/ \;
cp $C/test-checker/*.out $R/final/cloud-checks/test-checker/
find $C/test-checker -name '*.err' -size +0 -exec cp {} $R/final/cloud-checks/test-checker/ \;
cp $C/fix/* $R/final/cloud-checks/complete-lists/
cp /home/user/keep/checks-rows.sh /home/user/keep/checker.sh /home/user/keep/shadow-limited.sh /home/user/keep/corpora.sh $R/final/cloud-checks/
mkdir -p $R/final/cloud-checks/own
cp $S/own/run.sh $S/own/progress.txt $S/own/before-revision.txt $S/own/source-revision.txt $S/own/before-*.out $S/own/after-*.out $R/final/cloud-checks/own/
# The sanitizers' rows.
if [ -f $S/lsan/progress.txt ]; then
    cp $S/lsan/progress.txt $R/final/cloud-sanitizers/
    cp $S/lsan/part5-*.out $S/lsan/shadow-*.out $R/final/cloud-sanitizers/ 2>/dev/null || true
    find $S/lsan -maxdepth 1 \( -name '*.err' -o -name 'log.txt' \) -size +0 -exec cp {} $R/final/cloud-sanitizers/ \;
    for d in $S/lsan/reports-*; do [ -n "$(ls $d 2>/dev/null)" ] && cp -r $d $R/final/cloud-sanitizers/; done
    cp /home/user/keep/sanitizers-parts.sh $R/final/cloud-sanitizers/
fi
# The generators and what they made.
cp $K/generators/*.py $K/generators/*.md $R/final/generators/
cp $S/xl3/all.json $S/xl3/faults.json $S/xl3/table.md $S/xl3/table-short.md $S/xl3/beside.md $S/xl3/node-machine-section.out.md $S/xl3/one-core-path-section.out.md $R/final/generators/
mkdir -p $R/final/generators/pr
cp $K/pr/*.md $K/pr/*.py $K/pr/gen.sh $R/final/generators/pr/
cp $S/xl3/part-*.md $S/xl3/pr-body.md $R/final/generators/
[ -f $S/xl3/result-note.md ] && cp $S/xl3/result-note.md $R/final/generators/
cp $S/xl3/README.md $R/README.md
cp $K/assemble-record.sh $R/final/generators/
# The fault rounds.
cp $K/faults/*.py $K/faults/round2-indices.txt $R/faults/
for r in round1 round2; do rm -rf $R/faults/$r; mkdir -p $R/faults/$r; cp $K/faults/$r/* $R/faults/$r/; done
cp $S/xlf1.patch $S/xlf2.patch $R/faults/
for n in 1 2; do [ -f $S/lround$n/round.txt ] && cp $S/lround$n/round.txt $R/faults/round$n/cloud-round.txt; done
[ -d $S/faults-scripts ] && cp $S/faults-scripts/* $R/faults/
# The probes.
cp /home/user/keep/probes/cases21.py /home/user/keep/probes/probe.py $K/probe-summary.py $S/lpf/run.sh $R/probes/
rm -rf $R/probes/final; mkdir -p $R/probes/final
cp $S/lpf/cases21.txt $S/lpf/summary.txt $S/lpf/summary21.txt $S/lpf/baseline.txt $S/lpf/compiler.sha256 $R/probes/final/
cp -r $S/lpf/values $S/lpf/earlier $R/probes/final/
find $R -name __pycache__ -prune -exec rm -rf {} \;
du -sh $R $R/*
