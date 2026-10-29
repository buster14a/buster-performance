#!/bin/bash
# #152: where musl's units' -c on 8 lanes spends its system time (perf record -g, user and kernel), with perf stat on 8
# lanes and 1, and strace -c's system calls on 8 (profile_inner.sh, one hold of the lock).
set -u
W=$HOME/buster-fast-bench/units-152-claude
echo $$ > $W/profile.pid
D=$W/final/profile && mkdir -p $D && cd $D
awk '/^[^ \t].*\.o: /{print $2}' $W/final/musl/Makefile > units.txt
EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="solve #152 multi-file driver (musl profile)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/152" ~/buster-fast-bench/exclusive.sh bash $W/profile_inner.sh
perf report -i musl8.data --no-children --sort sym --stdio 2> /dev/null | grep -v "^$" | head -80 > report8.txt
perf report -i musl8.data --no-children --sort dso --stdio 2> /dev/null | grep -v "^#" | grep -v "^$" | head -10 > dso8.txt
echo profile-finished
