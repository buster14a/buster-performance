#!/bin/bash
# head2's build and its compile-time comparison, each its own hold.
set -euo pipefail
cd ~/buster-fast-bench/1372-claude
echo $$ > run3.pid
./build2.sh
export EXCLUSIVE_OWNER=claude-1372 EXCLUSIVE_TITLE="Bit-field access units (#1372)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1372
~/buster-fast-bench/exclusive.sh timeout 500 ./compile2.sh
echo done3
