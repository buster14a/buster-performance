#!/bin/bash
# measure3.sh TAG RUNS NAME=TREE...: the Lua link at 1, 2, 4 and 8 lanes, the builds interleaved (time-runs), as whole
# processes on CPUs 0-7, in one hold; then each build's syscall counts at 4 lanes.
set -u
D=$HOME/buster-fast-bench/1128-claude
tag=$1; runs=$2; shift 2
builds=(); exes=()
for b in "$@"; do builds+=(--build "${b%%=*}" "$D/${b#*=}/build/compiler"); exes+=("${b%%=*}=$D/${b#*=}/build/compiler"); done
first=$D/${1#*=}/build/compiler
mkdir -p $D/out $D/logs
cd $D/lua
L=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
lists=()
for n in 1 2 4 8; do lists+=(--list "${L[@]}" --lanes $n -o $D/out/lua *.c -lm -ldl); done
cat > $D/logs/inner-$tag.sh <<INNER
#!/bin/bash
cd $D/lua
for b in $*; do echo "\$b: \$(cat $D/\${b#*=}/COMMIT)"; done
taskset -c 0-7 $first time-runs --runs $runs --warmups 1 $(printf '%q ' "${builds[@]}") $(printf '%q ' "${lists[@]}")
for e in ${exes[*]}; do
  echo "strace \${e%%=*} lanes 4"
  taskset -c 0-7 strace -f -c -o $D/logs/strace-$tag-\${e%%=*}-4.txt \${e#*=} ${L[*]} --lanes 4 -o $D/out/lua-s *.c -lm -ldl
  grep -E 'mprotect|madvise|mmap|munmap|prlimit|total' $D/logs/strace-$tag-\${e%%=*}-4.txt
done
INNER
chmod +x $D/logs/inner-$tag.sh
EXCLUSIVE_OWNER=claude-1128 EXCLUSIVE_TITLE="solve #1128 measure $tag" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1128 \
    ~/buster-fast-bench/exclusive.sh $D/logs/inner-$tag.sh > $D/logs/measure-$tag.log 2>&1
echo "exit $?" >> $D/logs/measure-$tag.log
