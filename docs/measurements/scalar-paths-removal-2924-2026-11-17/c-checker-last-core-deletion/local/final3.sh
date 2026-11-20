#!/bin/bash
# After core-3's mutation round: the local CI blocks on the head, the tests commit's sixteen parts and its deferred test
# (buster-c12kt at eb73fa8ca), the sanitizer rows, then the head's Release build with CI's toolchain, the ownership
# check, the self-check and the complete driver's.
C=/root/.cache/claude-c7/c12k; S=$C/final3-status.txt; : > $S
until grep -q '^reruns 2 done' $C/mut5/results.txt; do sleep 15; done
echo "round done $(date +%T)" >> $S
bash $C/localcheck3.sh; echo "localcheck3 exit $? $(date +%T)" >> $S
( cd /home/user/buster-c12kt && git checkout -q --detach eb73fa8ca && nice -n 5 ./build.sh > $C/final3-tbuild.log 2>&1; echo "tests build $? $(git rev-parse --short HEAD)" >> $S )
sed -e "s|O=/root/.cache/claude-c7/c12k/tparts[0-9]*|O=$C/tparts6|" $C/tparts4.sh > $C/tparts6.sh; bash $C/tparts6.sh; echo "tparts6 exit $? $(date +%T)" >> $S
( cd /home/user/buster-c12kt && ./build/compiler test-checker-deferred > $C/tparts6/deferred.log 2>&1; echo "tests deferred $?: $(tail -1 $C/tparts6/deferred.log)" >> $S )
bash $C/san3.sh; echo "san3 exit $? $(date +%T)" >> $S
( cd /home/user/buster-c12c3 && ./build.sh --config Release > $C/final3-release.log 2>&1; echo "release $?" >> $S; cc -std=c17 -O2 -o $C/br3 tools/ci/build_regression.c && $C/br3 --ownership-only $PWD/build/compiler > $C/final3-ownership.log 2>&1; echo "ownership $?: $(tail -1 $C/final3-ownership.log)" >> $S )
( cd /home/user/buster-c12c3 && T=$(dirname $(ls -d /root/.cache/buster/toolchain/*/llvm-23.1.4/bin/clang | head -1)) && PATH=$T:$PATH ./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror src/buster/compiler/main.c > $C/final3-selfcheck.log 2>&1; echo "self-check $?" >> $S; PATH=$T:$PATH ./build/compiler -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c >> $C/final3-selfcheck.log 2>&1; echo "complete driver $?" >> $S )
echo done >> $S
