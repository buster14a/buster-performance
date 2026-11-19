#!/bin/bash
# Each open PR that changes the parser, merged onto C12b's head (git merge-tree), in an archived copy: does test-parser
# still give the frozen digests?
cd /home/user/buster-c12b
W=~/.cache/claude-c7/c12b/openprs
mkdir -p $W
: > $W/summary.txt
for b in codex/issue-2332-suppress-recovery claude/focused-cerf-rqw1pe codex/solve-2409 codex/issue-2406-call-recovery claude/determined-cray-imfcdm; do
    h=$(git rev-parse "refs/remotes/origin/$b" 2>/dev/null || git rev-parse FETCH_HEAD)
    git fetch -q origin "$b" && h=$(git rev-parse FETCH_HEAD)
    tree=$(git merge-tree --write-tree c12b "$h" 2>/dev/null | head -1)
    name=${b//\//-}
    rm -rf $W/tree && mkdir -p $W/tree
    git archive "$tree" | tar -x -m -C $W/tree
    (cd $W/tree && nice -n 10 ./build.sh > $W/$name.build 2>&1); st=$?
    if [ $st = 0 ]; then
        (cd $W/tree && timeout 1200 build/compiler test-parser > $W/$name.test 2>&1); t=$?
        echo "$b: build 0, test-parser $t; $(grep -E 'recorded digest' $W/$name.test | sed 's/: the vector path.s outputs / /; s/ their recorded digest.*//' | tr '\n' ' ')" >> $W/summary.txt
    else
        echo "$b: build $st" >> $W/summary.txt
    fi
done
rm -rf $W/tree
echo done >> $W/summary.txt
