#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p="$w/tip-evidence";i="$w/integration-evidence";export BUSTER_TEST_HOST_BUSY=0 SOURCE_DATE_EPOCH=1792454400 CORES_LINK=https://github.com/buster14a/buster/pull/3146
for stage in 3;do
 compiler="$w/late-control/build/compiler";if [[ $stage == 3 ]];then compiler="$p/tip-control-own-stage2/compiler";fi
 (cd "$w/late-control" && CORES_TITLE="Self-host current main for the 27-PR comparison (stage $stage)" cores -n1 -- "$i/selfhost" "$compiler" "$i/sources.argv" "$i/tier1-flags.argv" "$p/tip-control-own-stage$stage" 900) >"$p/control-stage$stage.log" 2>&1
done
touch "$p/control-verified"
