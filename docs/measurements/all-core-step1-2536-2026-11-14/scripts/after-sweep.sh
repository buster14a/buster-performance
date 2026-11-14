#!/bin/bash
cd ~/buster-fast-bench/2536-step1-claude
export EXCLUSIVE_OWNER=claude-2536-step1 EXCLUSIVE_TITLE="Problem 2536 (step 1)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
while systemctl --user is-active --quiet c2536-sweep; do sleep 10; done
[ -x compiler-head3 ] || exit 1
timeout 600 ~/buster-fast-bench/exclusive.sh ./musl.sh "$PWD/compiler-head3" "$PWD/musl-head3" > musl-head3.log 2>&1
