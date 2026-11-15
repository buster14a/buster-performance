#!/bin/bash
# measure.sh NAME [ENV=VALUE...]: one measure-tier1-programs run with --tier1-passes=+memory as its variant, under the lock.
D=~/buster-fast-bench/2718-claude
N=$1; shift
mkdir -p $D/results /tmp/2718-$N
cat > $D/inner-$N.sh <<INNER
#!/bin/bash
cd $D/buster
echo "== before"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8
env $* taskset -c 2 ./build/compiler measure-tier1-programs --runs 11 --clang clang --sqlite /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite \
  --speedtest $D/inputs --lua $D/inputs/lua-5.4.8/src --scripts $D/inputs/scripts --directory /tmp/2718-$N --variant --tier1-passes=+memory
status=\$?
echo "== after"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8
exit \$status
INNER
chmod +x $D/inner-$N.sh
export EXCLUSIVE_OWNER=claude-2718 EXCLUSIVE_TITLE="#2718 memory value numbering" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2718
~/buster-fast-bench/exclusive.sh timeout -k 5 1500 $D/inner-$N.sh > $D/results/$N.log 2>&1
echo "exit $?" >> $D/results/$N.log
