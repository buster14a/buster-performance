#!/usr/bin/env bash
# #1340: pre-#1049, main and head on sq-c/sq-syn and self-syn, through tools/microarch.
set -u
cd ~/buster-fast-bench/1340-droid || exit 2
echo $$ > run.pid
export ROOT=$PWD/root MICROARCH_OWNER=droid-1340 MICROARCH_TITLE="droid #1340 common warnings cost" \
    MICROARCH_LINK=https://github.com/buster14a/buster/issues/1340 BUILD_ARCHES=znver5 SELF_PREPROCESSOR=znver5
H=repo/tools/microarch/hosts/zen5-9700x.sh
R=repo/tools/microarch/run.sh
status=0
"$R" "$H" setup env build-commit pre1049 aca9e53a znver5 build-commit main 0eca996a znver5 || status=1
if [[ $status -eq 0 ]]; then
    AB_NAME=ab1340 AB_BUILDS="pre1049-znver5 main-znver5 znver5" "$R" "$H" ab || status=1
    AB_NAME=ab1340-self AB_BUILDS="pre1049-znver5 main-znver5 znver5" "$R" "$H" ab-self || status=1
    "$R" "$H" summarize || status=1
fi
echo "done status=$status" >> run.done
