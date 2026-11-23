#!/bin/bash
# usage: build.sh TREE ; one Release build under the lock
set -uo pipefail
D=~/buster-fast-bench/3360-claude; . $D/env.sh
cd $D/$1 && ~/buster-fast-bench/exclusive.sh timeout -k 5 1800 ./build.sh --config Release > $D/build-$1.log 2>&1; echo "$1 exit $?" >> $D/build.status
