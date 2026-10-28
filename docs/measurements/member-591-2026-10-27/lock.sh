#!/bin/bash
# Runs one command under the 9700X's lock, as member-591-claude.
export EXCLUSIVE_OWNER=member-591-claude
export EXCLUSIVE_TITLE="#591 member lookup"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/591
exec ~/buster-fast-bench/exclusive.sh "$@"
