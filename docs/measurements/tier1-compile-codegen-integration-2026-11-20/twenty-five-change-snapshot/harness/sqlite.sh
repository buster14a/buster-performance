#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p="$w/final-evidence/sqlite";mkdir -p "$p"
while [[ ! -f final-evidence/candidate-build.status ]];do sleep 5;done
[[ $(cat final-evidence/candidate-build.status) == 0 ]]
cd final-candidate
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
export PATH="$(dirname "$cc"):$PATH" BUSTER_TEST_HOST_BUSY=0 SOURCE_DATE_EPOCH=1792454400
short=$(mktemp -d /tmp/b25-XXXXXXXX);echo "$short" >"$p/location"
ulimit -Sn 1024
set +e
CORES_TITLE='Run the full 1,451-script SQLite Tcl suite on the 25-PR compiler' CORES_LINK=https://github.com/buster14a/buster/pull/3144 cores -n2 -- ./build/compiler test-sqlite-testfixture --clang "$cc" --tree "$w/integration-evidence/sqlite-tree" --tcl /usr/lib64 --amalgamation /home/david/dev/buster-corpus/sqlite/sqlite3.c --jobs 2 --timeout 5400 --directory "$short" --keep >"$p/summary.log" 2>&1
rc=$?;echo "$rc" >"$p/status";set -e
for d in "$short"/test-sqlite-testfixture-*;do
 for v in clang tier0 tier1;do [[ ! -f "$d/jobs-$v.txt" ]] || cp "$d/jobs-$v.txt" "$p/";[[ ! -f "$d/run-$v.txt" ]] || cp "$d/run-$v.txt" "$p/";done
done
exit "$rc"
