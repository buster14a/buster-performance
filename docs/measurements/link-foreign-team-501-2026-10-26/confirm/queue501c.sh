#!/bin/bash
# queue501c.sh PASSES: #501's confirmation campaign, detached: the final head's build (v3, BUSTER_DEBUG_INFO=0, one hold
# of the shared lock), the lists (lists501c.py), then PASSES passes of pass501c.sh, each under its own hold, 20 s
# apart. Status in confirm/campaign501.log, sha256s in confirm/builds501c.sha256.
set -u
D=~/buster-fast-bench/perf-501-claude
export EXCLUSIVE_OWNER=claude-501
export EXCLUSIVE_TITLE="Solve #501: link-foreign's lane team"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/501
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D/confirm"
~/buster-fast-bench/exclusive.sh bash -c "cd $D/v3 && BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh" > build-v3.log 2>&1
status=$?
echo "build v3 status $status $(date -Is)" >> campaign501.log
[ $status -eq 0 ] || exit 1
(cd "$D" && sha256sum v0/build/compiler v3/build/compiler) > builds501c.sha256
python3 lists501c.py >> campaign501.log 2>&1 || { echo "lists failed $(date -Is)" >> campaign501.log; exit 1; }
mkdir -p out out501
for pass in $(seq 1 "$1"); do
    ~/buster-fast-bench/exclusive.sh ./pass501c.sh "$pass" >> campaign501.out 2>> campaign501.err
    echo "pass $pass status $? $(date -Is)" >> campaign501.log
    sleep 20
done
echo "done $(date -Is)" >> campaign501.log
