#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
ready()
{
    (grep -qx 'comparisons status=0' comparisons-progress.log 2>/dev/null || \
     grep -qx 'comparisons status=0' comparisons-complete 2>/dev/null) && \
    grep -qx 'string_counters byte_identical=1 status=0' control-progress.log 2>/dev/null
}
while ! ready; do
    if test -f STOP; then echo 'record validation stopped'; exit 1; fi
    sleep 10
done
echo 'record validation queued'
EXCLUSIVE_OWNER=codex-593 EXCLUSIVE_TITLE='Buster #593 evidence validation' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/618 \
    "$HOME/buster-fast-bench/exclusive.sh" bash finish.sh > logs/record-validation.log 2> logs/record-validation-lock.log
echo 'record validation complete'
