#!/bin/bash
# lock.sh COMMAND...: COMMAND under the 9700X's lock, held for that one run, and a timeout of an hour.
export EXCLUSIVE_OWNER="claude-138-acceptance" EXCLUSIVE_TITLE="#138: Tier 1's acceptance record (run and compile time, campaigns)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/138"
exec ~/buster-fast-bench/exclusive.sh timeout 3600 "$@"
