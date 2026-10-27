#!/usr/bin/env bash
# Runs "$@" under the 9700X lock, one run per call.
export EXCLUSIVE_OWNER=claude-502-placement
export EXCLUSIVE_TITLE="#502: the checker's time and its code's placement (Claude Code)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/502
exec "$HOME/buster-fast-bench/exclusive.sh" "$@"
