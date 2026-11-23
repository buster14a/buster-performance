#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run, and writes the holder's line
# (the lock's own record of this hold) to holds.txt first.
export EXCLUSIVE_OWNER="claude-2886" EXCLUSIVE_TITLE="buster #2886: the executable's data-page faults" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2886"
cd "$(dirname "$0")"
exec ~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> holds.txt; exec "$@"' lock "$@"
