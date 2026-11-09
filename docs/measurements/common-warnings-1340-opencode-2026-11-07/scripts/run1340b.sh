#!/usr/bin/env bash
# #1340 (opencode): main 73fcf006 against the PR head on sq-c/sq-syn and the self workload, through tools/microarch.
set -u
cd ~/buster-fast-bench/1340-opencode || exit 2
echo $$ > run2.pid
export ROOT=$PWD/root2 MICROARCH_OWNER=opencode-1340 MICROARCH_TITLE="opencode #1340 default warnings' cost" \
    MICROARCH_LINK=https://github.com/buster14a/buster/issues/1340 BUILD_ARCHES=znver5 SELF_PREPROCESSOR=znver5
H=repo/tools/microarch/hosts/zen5-9700x.sh
R=repo/tools/microarch/run.sh
status=0
"$R" "$H" setup env build-commit main 73fcf006d znver5 || status=1
if [[ $status -eq 0 ]]; then
    AB_NAME=ab1340 AB_BUILDS="main-znver5 znver5" "$R" "$H" ab || status=1
    AB_NAME=ab1340-self AB_BUILDS="main-znver5 znver5" "$R" "$H" ab-self || status=1
    "$R" "$H" summarize || status=1
fi
echo "done status=$status" >> run2.done
