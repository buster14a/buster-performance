#!/usr/bin/env bash
set -u
cd "$HOME/buster-fast-bench/issue-612-codex"
mkdir -p evidence
export EXCLUSIVE_OWNER=codex-612
export EXCLUSIVE_TITLE='Buster 612 overload qualification'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/612
lock="$HOME/buster-fast-bench/exclusive.sh"
failed=0
for suite in test-checker test-checker-driver test-checker-asm test-types; do
 if [ "$suite" = test-checker-driver ]; then args=(--executable "$PWD/head/build/compiler"); else args=(); fi
 "$lock" ./head/build/compiler "$suite" "${args[@]}" > "evidence/$suite.stdout" 2> "evidence/$suite.private-stderr"
 result=$?
 printf '%s\t%s\n' "$suite" "$result" >> evidence/test-status.tsv
 if ((result != 0)); then failed=1; fi
done
exit "$failed"
