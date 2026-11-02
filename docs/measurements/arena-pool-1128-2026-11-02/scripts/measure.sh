#!/bin/bash
# measure.sh TAG MAIN_TREE HEAD_TREE [RUNS]: the Lua link at 1, 2, 4 and 8 lanes, main and head interleaved
# (time-runs), as whole processes on CPUs 0-7, then each build's syscall counts at 1 and 4 lanes, in one hold.
set -u
D=$HOME/buster-fast-bench/1128-claude
tag=$1; main=$D/$2/build/compiler; head=$D/$3/build/compiler; runs=${4:-11}
mkdir -p $D/out $D/logs
cd $D/lua
L=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
lists=()
for n in 1 2 4 8; do lists+=(--list "${L[@]}" --lanes $n -o $D/out/lua *.c -lm -ldl); done
cat > $D/logs/inner-$tag.sh <<INNER
#!/bin/bash
cd $D/lua
echo "commits: \$(cat $D/$2/COMMIT) \$(cat $D/$3/COMMIT)"
uname -r; cat /proc/sys/vm/overcommit_memory; cat /sys/kernel/mm/transparent_hugepage/enabled
taskset -c 0-7 $main time-runs --runs $runs --warmups 1 --build main $main --build head $head $(printf '%q ' "${lists[@]}")
for b in main head; do for n in 1 4; do
  exe=$main; [ \$b = head ] && exe=$head
  echo "strace \$b lanes \$n"
  taskset -c 0-7 strace -f -c -o $D/logs/strace-$tag-\$b-\$n.txt \$exe ${L[*]} --lanes \$n -o $D/out/lua-s *.c -lm -ldl
  head -12 $D/logs/strace-$tag-\$b-\$n.txt
done; done
INNER
chmod +x $D/logs/inner-$tag.sh
EXCLUSIVE_OWNER=claude-1128 EXCLUSIVE_TITLE="solve #1128 measure $tag" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1128 \
    ~/buster-fast-bench/exclusive.sh $D/logs/inner-$tag.sh > $D/logs/measure-$tag.log 2>&1
echo "exit $?" >> $D/logs/measure-$tag.log
