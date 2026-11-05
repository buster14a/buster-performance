#!/bin/sh
# time-runs of main and the static head, once with main (dynamic) as the host and once with the head (static).
cd ~/buster-fast-bench/652-claude-5
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1431
for host in shifts-main/compiler-0 shifts-s2/compiler-0; do
  echo "== host $host"
  ~/buster-fast-bench/exclusive.sh taskset -c 2 $host time-runs --runs 40 --warmups 4 --build main shifts-main/compiler-0 --build head shifts-s2/compiler-0 --list -fsyntax-only empty.c 2>&1 | grep -A3 "^list 1, \(wall\|user\)"
done > host.txt 2>&1
echo done >> host.txt
