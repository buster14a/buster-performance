#!/bin/bash
# assemble.sh: copy this session's part of the branches' rows piece's evidence into the record (idempotent): the final
# readings, the functions' sizes with the final build's, the generators as this session ran them, the cloud container's
# checks and probes on the pull request's commit, and the sanitizers' pass.
set -e
k=/home/user/keep/xbranch
r=/home/user/buster-performance/docs/measurements/x-branch-rows-2850-2026-11-20
final=xb6
mkdir -p $r/final/9700x/$final $r/final/9700x/xu8 $r/final/cloud-checks/probes $r/final/cloud-sanitizers
cp $k/fetch/functions.txt $r/builds/functions.txt
cp $k/fetch/$final/*.txt $k/fetch/$final/compiler.sha256 $k/fetch/$final/build.log $r/final/9700x/$final/
cp $r/final/generators/xb6x.patch $r/final/9700x/$final/
cp $k/fetch/xu8/$final-base*.txt $r/final/9700x/xu8/
cp $k/fetch/job-xb6.log $r/final/9700x/
cp $k/fetch/$final-table.txt $r/final/
# The generators, as this session ran them.
cp $k/doc/gen-docs.py $k/doc/apply-docs.py $k/doc/gen-readme.py $k/doc/node-machine-section.md $k/doc/one-core-path-section.md $r/final/generators/
cp $k/doc/out/values.json $r/final/generators/
cp $k/pr/gen-body.py $k/pr/body-template.md $k/pr/result-note-template.md $k/pr/tests.md $r/final/generators/
cp $k/assemble.sh $r/final/generators/
# The cloud container's checks, on the pull request's commit.
c=$k/checks; o=$r/final/cloud-checks
cp /home/user/keep/checks-rows.sh /home/user/keep/shadow-limited.sh /home/user/keep/checker.sh /home/user/keep/run-probes.sh $o/
cp $c/progress.txt $c/revision.txt $c/ownership.txt $o/
cp $c/shadow/status.txt $o/shadow-status.txt && cp $c/test-checker/status.txt $o/test-checker-status.txt && cp $c/modes/status.txt $o/modes-status.txt
for f in $c/shadow/*window-rows*.out; do echo "== $(basename "$f")"; grep -a '^node-shadow: window contexts expressions=\|^node-shadow: window rows expressions=\|^node-shadow: window rows listed\|^node-shadow: window rows records read' "$f"; done > $o/rows-counts.txt
for list in light heavy; do grep -a '^parallel:\|^== ' $c/complete-$list.log > $o/complete-$list-items.txt; done
grep -a 'differently\|^files:' $c/complete-light.log > $o/complete-light-the-preprocessor-against-clang.txt
cp $c/probes/earlier.txt $c/probes/cases9.txt $c/probes/cases1[0-4].txt $o/probes/
# The sanitizers' pass, when it has ended.
if grep -q '^all done' $k/san/progress.txt 2>/dev/null; then
    cp $k/san/progress.txt $r/final/cloud-sanitizers/progress-73b723aa9.txt
    cp $k/san/revision.txt $r/final/cloud-sanitizers/revision-73b723aa9.txt
    cp /home/user/keep/sanitizers-parts.sh $r/final/cloud-sanitizers/
fi
du -sh $r | cut -f1
