#!/bin/bash
# queue.sh COMMAND...: each argument a command run under the lock in its own hold, in order (one hold a run).
cd "$(dirname "$0")" || exit 1
for command in "$@"; do
    EXCLUSIVE_OWNER=claude-2531 EXCLUSIVE_TITLE="Attested declarations step 0: the census (#2531)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 \
        timeout 1800 ~/buster-fast-bench/exclusive.sh bash -c "$command"
    echo "$(date -u +%FT%TZ) $? $command" >> queue.log
done
echo done >> queue.log
