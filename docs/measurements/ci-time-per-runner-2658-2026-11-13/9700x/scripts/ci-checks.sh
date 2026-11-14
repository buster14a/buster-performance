#!/bin/bash
# The CI tools' self-tests on a branch's worktree: the selector (changes) and the aggregate's predicate (qualification).
set -u
tree=${1:?tree}
cd "$tree"
mkdir -p build
TIMEFORMAT='%R s'
status=0
cc -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tools/ci/qualification.c -o build/qualification || status=1
{ time build/qualification --self-test; } 2>&1 || status=1
cc -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tools/ci/changes.c -o build/changes || status=1
{ time build/changes --self-test --root . > build/changes-self-test.txt 2>&1; } 2>&1 || status=1
tail -3 build/changes-self-test.txt
grep -i "fail" build/changes-self-test.txt | head -10
for e in pull_request merge_group push; do
  for g in success skipped failure ""; do
    env EVENT_NAME=$e CODE_CHANGED=true PR_DRAFT=false HARDWARE=$([ $e = push ] && echo admit || echo skip) PURPOSE= CHANGES_RESULT=success SIZE_RESULT=success DCO_RESULT=success EVIDENCE_RESULT=success GLUE_RESULT=$g TEST_RESULT=success FUZZ_RESULT=$([ $e = pull_request ] && echo skipped || echo success) BENCHMARK_RESULT=$([ $e = push ] && echo success || echo skipped) COVERAGE_RESULT=$([ $e = merge_group ] && echo success || echo skipped) build/qualification > /dev/null 2>&1
    printf 'event=%s glue=%s status=%s\n' "$e" "${g:-unset}" "$?"
  done
done
exit $status
