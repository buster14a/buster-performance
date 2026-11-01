#!/bin/bash
set -uo pipefail
cd ~/buster-fast-bench/droid-zen5
. scripts/env.sh
echo "start $(date -Is)"
(cd head-wip2 && BUSTER_DEBUG_INFO=0 $lock ./build.sh) > build-head-wip2.log 2>&1; echo "build head status $?"
[ -x head-wip2/build/compiler ] || { echo "no head build"; exit 1; }
./scripts/shifts.sh head-wip2 head head-wip2/build.sh > shifts-head.log 2>&1; echo "shifts head status $?"
./scripts/validate.sh head-wip2 base-9a511a6a val-wip2 > val-wip2.log 2>&1; echo "validate status $?"
./scripts/abshifts.sh ab-wip2 3 > ab-wip2.log 2>&1; echo "ab status $?"
./scripts/prof.sh head-wip2 prof-head-wip2 > prof-head-wip2.log 2>&1; echo "prof status $?"
echo "end $(date -Is)"
