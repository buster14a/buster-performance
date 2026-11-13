#!/bin/bash
cd ~/buster-fast-bench/1378-claude
export EXCLUSIVE_OWNER=claude-1378 EXCLUSIVE_TITLE="Solve 1378 (declarator climbs qualification)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1378
for v in base fix main; do
  (cd $v && timeout 900 ~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh > ../build-$v.log 2>&1; echo "exit $?" >> ../build-$v.log)
done
echo done > builds.done
