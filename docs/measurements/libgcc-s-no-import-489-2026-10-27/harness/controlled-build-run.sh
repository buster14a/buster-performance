#!/bin/bash
set -eu
export EXCLUSIVE_OWNER=codex-489 EXCLUSIVE_TITLE='Buster #489 control build' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/489
cd "$HOME/buster-fast-bench/codex-489-control"
BUSTER_DEBUG_INFO=0 "$HOME/buster-fast-bench/exclusive.sh" ./controlled-build-command.sh > controlled-build.log 2> controlled-build.stderr
./controlled-campaign.sh > controlled-run.log 2>&1
