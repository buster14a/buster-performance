#!/bin/bash
# sweep594.sh TREE PASSES: #594's lane sweep by TREE's link-foreign, PASSES passes, each under one hold of the shared
# lock (about 100 s): sweep-small (10 rounds) and sweep-big (3 rounds), each list's rounds continuing procbench's
# rotation from its last pass (--first). Results append to results594-LIST.tsv, the --time reports to out594/.
set -u
D=~/buster-fast-bench/perf-594-claude
cd "$D"
tree=$1
passes=$2
echo $$ > "sweep594-$tree.pid"
export EXCLUSIVE_OWNER=claude-594 EXCLUSIVE_TITLE="link-foreign lanes by the link's work (#594): sweep" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/594
python3 lists594.py "$tree" || exit 1
mkdir -p out out594
for list in "sweep-small-$tree" "sweep-big-$tree"; do
    [ -s "results594-$list.tsv" ] || ./procbench --rounds 0 "$list.list" > "results594-$list.tsv"
done
for pass in $(seq 1 "$passes"); do
    small_first=$(( (pass - 1) * 10 + 1 ))
    big_first=$(( (pass - 1) * 3 + 1 ))
    ~/buster-fast-bench/exclusive.sh bash -c "./procbench --first $small_first --rounds 10 --no-header --out out594 sweep-small-$tree.list >> results594-sweep-small-$tree.tsv; ./procbench --first $big_first --rounds 3 --no-header --out out594 sweep-big-$tree.list >> results594-sweep-big-$tree.tsv"
    echo "$tree pass $pass status $? $(date -Is)" >> sweep594.log
    sleep 20
done
echo "$tree done $(date -Is)" >> sweep594.log
