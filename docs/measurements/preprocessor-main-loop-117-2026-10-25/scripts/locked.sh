#!/usr/bin/env bash
# Runs "$@" under the 9700X's lock, one run per call.
export EXCLUSIVE_OWNER=claude-117
export EXCLUSIVE_TITLE="Issue 117 coordination (Claude Code)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/117
exec "$HOME/buster-fast-bench/exclusive.sh" "$@"
