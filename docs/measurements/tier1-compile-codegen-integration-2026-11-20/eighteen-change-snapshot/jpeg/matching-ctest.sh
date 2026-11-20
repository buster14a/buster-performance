#!/usr/bin/env bash
set -euo pipefail
p=$(pwd)/eighteen-evidence/jpeg
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
for v in clang control candidate;do
 cp "$p/$v-tests.log" "$p/$v-automatic-tests.log"
 cp "$p/$v-ctest.xml" "$p/$v-automatic-ctest.xml"
 cp "$p/$v-tests.status" "$p/$v-automatic-tests.status"
 sha256sum "$p/$v"/{cjpeg-static,djpeg-static,jpegtran-static,libjpeg.a} >"$p/$v-before-test-mode.sha256"
 cmake -S "$(pwd)/independent-corpus/libjpeg-turbo-3.1.3" -B "$p/$v" -DFLOATTEST12=fp-contract > "$p/$v-contract-config.log" 2>&1
 sha256sum -c "$p/$v-before-test-mode.sha256" >"$p/$v-same-binaries.txt"
 ctest --test-dir "$p/$v" -j1 --output-on-failure --output-junit "$p/$v-ctest.xml" >"$p/$v-tests.log" 2>&1
 echo "$?" >"$p/$v-tests.status"
done
touch "$p/matching-ctest-complete"
