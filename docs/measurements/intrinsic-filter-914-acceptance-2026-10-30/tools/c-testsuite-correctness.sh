#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Original qualification glue; run one variant per shared-host lock.
set -euo pipefail
stage=${1:?usage: c-testsuite-correctness.sh STAGING_ROOT base-or-head}
variant=${2:?}
case "$variant" in base|head) ;; *) exit 2;; esac
corpus=/home/david/buster-fast-bench/claude-env-check/build/c-testsuite
clang=/home/david/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378/bin/clang
subset=$stage/corpus-tools/subset.txt
harness=$stage/head/compiler
compiler=$stage/$variant/compiler
export PATH="$(dirname "$clang"):$PATH" LC_ALL=C SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
test "$(git -C "$corpus" rev-parse HEAD)" = 5c7275656d751de0e68b2d340a95b5681858ed07
test -z "$(git -C "$corpus" status --porcelain)"
printf '%s  %s\n' cf2301d719f1377d91921faec7f888883abaedb75ea2577893c9731414b7d54c "$subset" | sha256sum --check
printf '%s  %s\n' e0bbf2ced14fc4bb38c2073887b0fac5f8bf694789f8c9d71b726db8f292f7bf "$stage/base/compiler" | sha256sum --check
printf '%s  %s\n' 67d5039a94d367f1d8f9b61ace82fb0b9b0ad699d5360bb4979367c247d85c75 "$stage/head/compiler" | sha256sum --check
"$clang" --version
sha256sum "$clang"
printf 'corpus_source=%s corpus_commit=%s variant=%s harness=head expected_subset=220 jobs=1\n' "$corpus" "$(git -C "$corpus" rev-parse HEAD)" "$variant"
"$harness" test-c-testsuite --compiler "$compiler" --cross-check --clang "$clang" --jobs 1 --subset "$subset" "$corpus"
