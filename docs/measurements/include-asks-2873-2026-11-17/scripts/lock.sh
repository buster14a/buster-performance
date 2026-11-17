#!/bin/bash
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run, and writes the holder's line
# (the lock's own record of this hold) to holds.txt first.
export EXCLUSIVE_OWNER="claude-2873-files" EXCLUSIVE_TITLE="Issue 2850 and related: the files rows of the kernel row (#2873)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/2873#issuecomment-6937495274"
cd "$(dirname "$0")"
exec ~/buster-fast-bench/exclusive.sh bash -c 'head -1 /var/lib/buster-9700x/owner >> holds.txt; exec "$@"' lock "$@"
