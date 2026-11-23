#!/bin/bash
# ship.sh REV NAME: builds REV (znver5 Release) in the worktree /home/user/wt, ships it to the 9700X as bin/NAME, and
# runs stages.sh for main and NAME there in one hold (results/main-NAME, results/NAME).
set -eu
S=/tmp/claude-0/-home-user-buster/e2ef93d9-0a28-5860-99ad-744c2baee624/scratchpad
REV=$1; NAME=$2
[ -d /home/user/wt ] || git -C /home/user/buster worktree add -q --detach /home/user/wt $REV
git -C /home/user/wt checkout -q -- src && git -C /home/user/wt checkout -q --detach $REV
(cd /home/user/wt && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $S/build-wt.log 2>&1) || { tail -20 $S/build-wt.log; exit 1; }
cp /home/user/wt/build/cmake/znver5/Release/compiler $S/z-$NAME
strip -o $S/z-$NAME.s $S/z-$NAME && zstd -q -f -T4 -10 $S/z-$NAME.s -o $S/z-$NAME.zst
timeout 900 tailscale ssh david@benchpress "cat > ~/buster-fast-bench/3393-claude/bin/$NAME.zst" < $S/z-$NAME.zst
timeout 120 tailscale ssh david@benchpress "cd ~/buster-fast-bench/3393-claude && zstd -q -d -f bin/$NAME.zst && chmod +x bin/$NAME && printf '#!/bin/bash\nD=~/buster-fast-bench/3393-claude\n\$D/scripts/stages.sh \$D/bin/main main-$NAME 7\n\$D/scripts/stages.sh \$D/bin/$NAME $NAME 7\n' > scripts/run-$NAME.sh && chmod +x scripts/run-$NAME.sh && (setsid nohup env EXCLUSIVE_OWNER=claude-3393 EXCLUSIVE_TITLE='buster #3393 unit parts' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3393 ~/buster-fast-bench/exclusive.sh timeout -k 5 300 scripts/run-$NAME.sh > results/run-$NAME.log 2>&1 < /dev/null &) ; echo launched"
