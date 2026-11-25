#!/bin/bash
# The product for znver5 without debug information, as the 9700X's job builds it: main's (base-tree) then the checkout's.
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
cd /home/user/dp/base-tree && ./build.sh --config Release > /home/user/dp/build-prod-base.log 2>&1 && cp "$(./build.sh print-output --config Release)" /home/user/dp/bin/compiler-base-znver5
cd /home/user/buster && ./build.sh --config Release > /home/user/dp/build-prod-head.log 2>&1 && cp "$(./build.sh print-output --config Release)" /home/user/dp/bin/compiler-head-znver5
ls -la /home/user/dp/bin/compiler-*-znver5
echo products-done
