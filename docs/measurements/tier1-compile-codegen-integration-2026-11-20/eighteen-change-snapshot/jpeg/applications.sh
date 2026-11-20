#!/usr/bin/env bash
set -euo pipefail
p=eighteen-evidence/jpeg
while [[ ! -e $p/official-done ]];do sleep 5;done
for v in clang control candidate;do test "$(cat "$p/$v-build.status")" = 0;done
export CORES_LINK=https://github.com/buster14a/buster/pull/3136
CORES_TITLE='Compare actual JPEG encoding, decoding, lossless transforms, and 8/12/16-bit image outputs' cores -n 1 -- bash -ec 'for phase in build check time;do python eighteen-evidence/jpeg/applications.py "$phase";done' >$p/application-run.log 2>&1
touch $p/applications-complete
