#!/bin/bash
# Runs one command under the 9700X's lock, as #529's session.
export EXCLUSIVE_OWNER=claude-529
export EXCLUSIVE_TITLE="#529 check_input throughput"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/529
exec ~/buster-fast-bench/exclusive.sh "$@"
