#!/bin/bash
# The final head: rebuild head and dhead, then measure.sh, dom.sh (dhead only) and stat.sh, each run its own lock hold.
D=$HOME/buster-fast-bench/1729-opencode
cd "$D"; echo $$ > run-final.pid
lockrun() { title=$1; shift; EXCLUSIVE_OWNER=opencode-1729 EXCLUSIVE_TITLE="#1729 SCCP phi: $title" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1729 ~/buster-fast-bench/exclusive.sh "$@" 2>&1 | grep -v '^exclusive.sh'; }
(cd head && lockrun "head build" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > ../head-build.log 2>&1)
./measure.sh
DOM_BUILDS=dhead ./dom.sh
lockrun "sqlite stat" ./stat.sh > stat.txt
echo all-done > run-final.done
