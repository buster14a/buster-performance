#!/bin/bash
cd ~/buster-fast-bench/1380-claude
export EXCLUSIVE_OWNER=claude-1380 EXCLUSIVE_TITLE="Solve 1380" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1380
(cd head && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build2.log 2>&1 || { echo build-failed; exit 1; }
./measure2.sh > measure2.log 2>&1
echo all-done
