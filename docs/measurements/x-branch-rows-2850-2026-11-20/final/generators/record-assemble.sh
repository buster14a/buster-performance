#!/bin/bash
# record-assemble.sh [FINAL]: copy the branches' rows piece's evidence into the record (idempotent): the builds, the
# faults, the probes and, with FINAL (the final readings' label), the final readings, the cloud container's checks and
# sanitizers, and the generators.
set -e
k=/home/user/keep/xbr
r=/home/user/buster-performance/docs/measurements/x-branch-rows-2850-2026-11-20
final=${1:-}
mkdir -p $r/builds/9700x $r/faults/raw $r/faults/mutants $r/faults/syntax-round1 $r/faults/syntax-round2 $r/probes $r/final
# The builds.
cp $k/job-xb.sh $k/make-patch.sh $k/xb-table.py $k/functions.sh $r/builds/
cp $k/fetch/functions.txt $r/builds/functions.txt
for n in 1 2 3 4 5; do
    cp $k/fetch/xb$n-table.txt $r/builds/
    mkdir -p $r/builds/9700x/xb$n $r/builds/9700x/xu8
    cp $k/fetch/xb$n/*.txt $k/fetch/xb$n/compiler.sha256 $r/builds/9700x/xb$n/
    cp $k/fetch/xb$n/build.log $r/builds/9700x/xb$n/ 2>/dev/null || true
    cp $k/v/xb${n}x.patch $r/builds/9700x/xb$n/
    cp $k/fetch/xu8/xb$n-base*.txt $r/builds/9700x/xu8/
done
# The faults.
cp $k/faults/make-faults-round1.py $k/faults/make-faults.py $k/faults/job-faults-branch.sh $k/faults/local-round.sh $k/faults/syntax-check.sh $k/faults/make-fault-patch.sh $r/faults/
cp $k/faults/faults-branch-round1-final.py $r/faults/faults-branch-round1.py
cp $k/faults/faults-branch-round2.py $k/faults/faults-branch-round3.py $r/faults/
cp $k/faults/xbf1.patch $k/faults/xbf2.patch $k/faults/xbf3.patch $r/faults/
cp $k/rounds/round*.txt $r/faults/
cp $k/faults/round1-9700x.txt $r/faults/raw/round1-9700x.txt
cp $k/faults/local-1/round.txt $r/faults/raw/round1-cloud.txt
cp $k/faults/local-1b/round.txt $r/faults/raw/round1-cloud-the-two-rewritten.txt
cp $k/faults/round2-9700x.txt $r/faults/raw/round2-9700x.txt
cp $k/faults/local-2/round.txt $r/faults/raw/round2-cloud.txt
[ -f $k/faults/round3-9700x.txt ] && cp $k/faults/round3-9700x.txt $r/faults/raw/round3-9700x.txt
[ -f $k/faults/local-3/round.txt ] && cp $k/faults/local-3/round.txt $r/faults/raw/round3-cloud.txt
cp $k/faults/syntax-1/shard-*.txt $r/faults/syntax-round1/
cp $k/faults/syntax-2/shard-*.txt $r/faults/syntax-round2/
cp $k/faults/mutant-two-part5.err $r/faults/mutants/list-branching-with-two-on-the-turns-count.err
cp $k/faults/mutant-147-part5.out $r/faults/mutants/reason-mark-other-way-before-the-line.out
cp $k/faults/mutant-147b-part5.err $r/faults/mutants/reason-mark-other-way-with-the-line.err
rm -rf $r/faults/reason-probe && mkdir -p $r/faults/reason-probe
cp $k/faults/reason-probe/reason-probe.patch $k/faults/reason-probe/status.txt $k/faults/reason-probe/t4.c $k/faults/reason-probe/t4.out $k/faults/reason-probe/part5.out $k/faults/reason-probe/part5.err $r/faults/reason-probe/
for c in sqlite lua musl; do grep -a "window rows\|reason-probe" $k/faults/reason-probe/$c--passes0--window-rows--list20.out > $r/faults/reason-probe/$c.txt; done
# The probes.
cp $k/probes/probe-again.py $k/probes/cases13.py $k/probes/cases14.py $r/probes/
cp /home/user/keep/xrows/probes/probe.py $r/probes/
cp $k/final-probes/probes/earlier.txt $k/final-probes/probes/cases9.txt $k/final-probes/probes/cases10.txt $k/final-probes/probes/cases11.txt $k/final-probes/probes/cases12.txt $k/final-probes/cases13.txt $k/final-probes/cases14.txt $r/probes/
if [ -n "$final" ]; then
    mkdir -p $r/final/9700x/$final $r/final/9700x/xu8 $r/final/cloud-checks $r/final/cloud-sanitizers
    cp $k/fetch/$final/*.txt $k/fetch/$final/compiler.sha256 $r/final/9700x/$final/
    cp $k/fetch/$final/build.log $r/final/9700x/$final/ 2>/dev/null || true
    cp $k/v/${final}x.patch $r/final/9700x/$final/
    cp $k/fetch/xu8/$final-base*.txt $r/final/9700x/xu8/
    cp $k/fetch/$final-table.txt $r/final/
    cp $k/doc/gen-docs.py $k/doc/apply-docs.py $k/doc/gen-readme.py $k/doc/node-machine-section.md $k/doc/one-core-path-section.md $r/final/
    cp $k/doc/out/values.json $r/final/
    cp $k/pr/gen-body.py $k/pr/body-template.md $k/pr/result-note-template.md $k/pr/tests.md $r/final/
    /home/user/keep/xupd/doc/record-checks.sh $k/checks $r/final/cloud-checks > /dev/null
    cp $k/san/progress.txt $k/san/revision.txt $r/final/cloud-sanitizers/
    cp /home/user/keep/sanitizers-parts.sh $r/final/cloud-sanitizers/
fi
du -sh $r | cut -f1
