#!/bin/bash
# linkbench594.sh TREE: benchmark-link's linkers' side for link-foreign alone, by TREE, every kind, as the 9700X job runs
# it (its lane on the job's first allowed CPU), under one hold of the shared lock; the output in linkbench594-TREE-N.log.
set -u
D=~/buster-fast-bench/perf-594-claude
cd "$D"
tree=$1
n=$2
export EXCLUSIVE_OWNER=claude-594 EXCLUSIVE_TITLE="link-foreign lanes by the link's work (#594): benchmark-link" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/594
mkdir -p "$D/bl-$tree"
~/buster-fast-bench/exclusive.sh bash -c "cd $D/$tree && cpu=\$(awk '/^Cpus_allowed_list:/ { split(\$2, cpus, /[,-]/); print cpus[1] }' /proc/self/status); ./build/compiler benchmark-link --cpus \$cpu --only linkers --linkers link-foreign --directory $D/bl-$tree" > "linkbench594-$tree-$n.log" 2>&1
echo "linkbench $tree $n $? $(date -Is)" >> confirm594.log
