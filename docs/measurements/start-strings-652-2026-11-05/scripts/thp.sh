#!/bin/sh
# Huge pages a small compile allocates (#652): /proc/vmstat's thp_fault_alloc around 100 runs of the static head.
cd ~/buster-fast-bench/652-claude-5
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
C=$PWD/shifts-s3/compiler-0
~/buster-fast-bench/exclusive.sh sh -c "
for args in '-fsyntax-only empty.c' '-E -P empty.c -o /dev/null' '-c tiny.c -o /dev/null' '-c hello.c -o /dev/null'; do
  a=\$(awk '/^thp_fault_alloc /{print \$2}' /proc/vmstat)
  for i in \$(seq 100); do taskset -c 2 $C \$args > /dev/null 2>&1; done
  b=\$(awk '/^thp_fault_alloc /{print \$2}' /proc/vmstat)
  echo \"\$args: \$((b - a)) huge pages allocated by 100 runs\"
done"
echo done
