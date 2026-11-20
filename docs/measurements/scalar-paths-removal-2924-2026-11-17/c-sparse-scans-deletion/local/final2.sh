#!/bin/bash
# After the core-2 mutation round: the local CI blocks on the head, the tests commit's sixteen parts (buster-c12kt), the
# sanitizer rows, then the head's Release build with CI's toolchain and the ownership check.
C=/root/.cache/claude-c7/c12k; S=$C/final2-status.txt; : > $S
until grep -q 'runner exit' $C/mut3/results.txt; do sleep 15; done
echo "round done $(date +%T)" >> $S
bash $C/localcheck2.sh; echo "localcheck2 exit $? $(date +%T)" >> $S
( cd /home/user/buster-c12kt && git checkout -q --detach 007afe62f && nice -n 5 ./build.sh > $C/final2-tbuild.log 2>&1; echo "tests build $? $(git rev-parse --short HEAD)" >> $S )
sed -e "s|O=/root/.cache/claude-c7/c12k/tparts2|O=$C/tparts4|" $C/tparts2.sh > $C/tparts4.sh; bash $C/tparts4.sh; echo "tparts4 exit $? $(date +%T)" >> $S
bash $C/san2.sh; echo "san2 exit $? $(date +%T)" >> $S
( cd /home/user/buster-c12c2 && ./build.sh --config Release > $C/final2-release.log 2>&1; echo "release $?" >> $S; /tmp/claude-0/-home-user/a5cf9d3c-54b3-5f35-a2b2-f7ae4ba74bd8/scratchpad/br --ownership-only $PWD/build/compiler > $C/final2-ownership.log 2>&1; echo "ownership $?: $(tail -1 $C/final2-ownership.log)" >> $S )
( cd /home/user/buster-c12c2 && T=$(dirname $(ls -d /root/.cache/buster/toolchain/*/llvm-23.1.4/bin/clang | head -1)) && PATH=$T:$PATH ./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > $C/final2-selfcheck.log 2>&1; echo "self-check $?" >> $S; PATH=$T:$PATH ./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c >> $C/final2-selfcheck.log 2>&1; echo "complete driver $?" >> $S )
echo done >> $S
