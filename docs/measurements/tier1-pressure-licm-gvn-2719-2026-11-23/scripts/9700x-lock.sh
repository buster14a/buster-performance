#!/bin/bash
# lock.sh PART: one run.sh PART under the 9700X's lock, its log in PART.log.
D=~/buster-fast-bench/2719-claude
export EXCLUSIVE_OWNER=claude-2719 EXCLUSIVE_TITLE="Tier 1 pressure-aware LICM and GVN (#2719)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2719
cd $D && ~/buster-fast-bench/exclusive.sh ./run.sh "$1" > $D/$1.log 2>&1
echo "lock rc=$?" >> $D/$1.log
