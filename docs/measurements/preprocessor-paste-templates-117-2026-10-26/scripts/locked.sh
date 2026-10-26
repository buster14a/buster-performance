#!/usr/bin/env bash
# Runs "$@" under the 9700X lock, one run per call.
export EXCLUSIVE_OWNER=claude-117-templates
export EXCLUSIVE_TITLE="#117: templates for ## and # (Claude Code)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/117
exec "$HOME/buster-fast-bench/exclusive.sh" "$@"
