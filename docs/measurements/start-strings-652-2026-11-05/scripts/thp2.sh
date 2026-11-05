#!/bin/sh
# Which mapping holds the huge pages of a small compile (#652): the static head stopped at exit_group under gdb, its
# smaps' AnonHugePages by mapping, and the mappings' order from strace (setarch -R, so addresses match).
cd ~/buster-fast-bench/652-claude-5
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
C=$PWD/shifts-s3/compiler-0
for args in "-fsyntax-only empty.c" "-E -P empty.c -o /dev/null"; do
  echo "== $args"
  ~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 setarch -R gdb -q -batch -x smapsexit.gdb --args $C $args 2>&1 | grep '^huge'; taskset -c 2 setarch -R strace -e trace=mmap -o thp2-strace.txt $C $args > /dev/null 2>&1"
  grep -n "mmap" thp2-strace.txt | awk -F'= ' '{print $NF}' | tr '\n' ' '; echo
done
echo done
