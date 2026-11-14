#!/bin/bash
# bp.sh ARGS...: run.sh ARGS under the 9700X's lock, one hold; the run bounded by 900 s once it has the lock.
arguments=$(printf ' %q' "$@")
timeout 14400 tailscale ssh david@benchpress "cd ~/buster-fast-bench/2531-step3b-claude && EXCLUSIVE_OWNER=claude-2531-step3b EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 ./run.sh$arguments" 2>&1 | grep -v '^  \(title\|link\):\|^[0-9-]*T.*: '
