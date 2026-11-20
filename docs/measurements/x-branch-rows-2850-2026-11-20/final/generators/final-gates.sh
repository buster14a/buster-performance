#!/bin/bash
# final-gates.sh: the cloud container's two long gates on the piece's final sources, one after the other: the checks
# (checks-rows.sh) in /home/user/buster-x1, then every one-statement probe on the checks' build, then the sanitizers'
# rows (sanitizers-parts.sh) in /home/user/buster-san at the same commit.
k=/home/user/keep/xbr
TREE=/home/user/buster-x1 OUT=$k/checks /home/user/keep/xrows/checks-rows.sh > $k/checks-run.log 2>&1
mkdir -p $k/final-probes
/home/user/keep/xupd/doc/run-probes.sh $k/checks/compiler $k/final-probes/probes > $k/final-probes/run-probes.log 2>&1
python3 $k/probes/probe-again.py $k/checks/compiler $k/probes/cases13.py > $k/final-probes/cases13.txt
python3 $k/probes/probe-again.py $k/checks/compiler $k/probes/cases14.py > $k/final-probes/cases14.txt
rm -rf $k/checks/probes && cp -r $k/final-probes/probes $k/checks/probes && cp $k/final-probes/cases13.txt $k/final-probes/cases14.txt $k/checks/
echo "probes done $(date -u +%H:%M): $(cat $k/final-probes/probes/earlier.txt $k/final-probes/probes/cases9.txt $k/final-probes/probes/cases10.txt $k/final-probes/probes/cases11.txt $k/final-probes/probes/cases12.txt $k/final-probes/cases13.txt $k/final-probes/cases14.txt | wc -l) lines, $(cat $k/final-probes/probes/earlier.txt $k/final-probes/probes/cases9.txt $k/final-probes/probes/cases10.txt $k/final-probes/probes/cases11.txt $k/final-probes/probes/cases12.txt $k/final-probes/cases13.txt $k/final-probes/cases14.txt | grep -vc ' status 0 .*refused [0-9]* diff 0 .*entries [0-9]* diff 0 ') that do not agree" >> $k/checks/progress.txt
revision=$(git -C /home/user/buster-x1 rev-parse HEAD)
git -C /home/user/buster-san checkout -q --detach "$revision" || exit 1
mkdir -p $k/san && echo "$revision" > $k/san/revision.txt
/home/user/keep/sanitizers-parts.sh /home/user/buster-san $k/san "--passes 0 --window-rows" "5" > $k/san-run.log 2>&1
echo "gates done $(date -u +%H:%M)" >> $k/san/progress.txt
