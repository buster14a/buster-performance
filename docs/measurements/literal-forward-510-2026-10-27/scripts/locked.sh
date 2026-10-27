#!/usr/bin/env bash
# Runs "$@" under the 9700X lock, one run per call.
export EXCLUSIVE_OWNER=claude-510-literal
export EXCLUSIVE_TITLE="#510: integer literals' store-to-load forward (Claude Code)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/510
exec "$HOME/buster-fast-bench/exclusive.sh" "$@"
