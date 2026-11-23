#!/bin/bash
# cmp.sh BIN TAG: objs.sh with BIN into objs-TAG, then the differences from objs-base.
S=/tmp/claude-0/-home-user-buster/e2ef93d9-0a28-5860-99ad-744c2baee624/scratchpad
JOBS=${JOBS:-4} $S/tools/objs.sh $1 $S/objs-$2 > /dev/null 2>&1
for v in plain g unwind g-unwind; do echo "$v: $(diff $S/objs-base/$v.txt $S/objs-$2/$v.txt | grep -c '^>') differences"; done
diff $S/objs-base/plain.txt $S/objs-$2/plain.txt | head -10
