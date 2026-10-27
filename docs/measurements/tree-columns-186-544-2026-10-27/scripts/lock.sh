#!/bin/bash
# Runs one command under the 9700X's lock, as the #186/#544 session.
export EXCLUSIVE_OWNER=claude-186-544
export EXCLUSIVE_TITLE="Problems 186 and 544: the tree's columns"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/544
exec ~/buster-fast-bench/exclusive.sh "$@"
