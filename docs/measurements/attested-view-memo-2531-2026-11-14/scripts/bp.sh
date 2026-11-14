#!/bin/bash
# bp.sh COMMAND ARGS...: COMMAND (run.sh or build.sh) under the 9700X's lock, one hold, bounded by 900 s once it has it.
command=$1
shift
arguments=$(printf ' %q' "$@")
timeout 14400 tailscale ssh david@benchpress "cd ~/buster-fast-bench/2531-step3c-claude && EXCLUSIVE_OWNER=claude-2531-step3c EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 ./$command$arguments" 2>&1 | grep -v '^  \(title\|link\):\|^[0-9-]*T.*: '
