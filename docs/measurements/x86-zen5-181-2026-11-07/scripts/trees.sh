#!/bin/bash
# trees.sh MAIN_COMMIT HEAD_COMMIT: a git archive of each commit into a fresh directory named for it.
set -e
B=$HOME/buster-fast-bench/181-claude/campaign
mkdir -p $B/trees
cd $HOME/buster-fast-bench/181-claude/src
git fetch -q origin main claude/magical-albattani-dhulqc
for c in "$1" "$2"; do
    name=$(echo $c | cut -c1-8)
    rm -rf $B/trees/$name
    mkdir -p $B/trees/$name
    git archive $c | tar -x -C $B/trees/$name
    echo $c > $B/trees/$name/COMMIT
done
echo $(echo $1 | cut -c1-8) > $B/main.name
echo $(echo $2 | cut -c1-8) > $B/head.name
