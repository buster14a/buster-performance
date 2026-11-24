#!/bin/bash
# x.sh COMMAND...: one run under the 9700X's lock, with this session's owner lines.
export EXCLUSIVE_OWNER=claude-direct-tx5wvj
export EXCLUSIVE_TITLE="Direct path performance optimization (#2850)"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLnvzqy65ZRMt31udZB9
exec "$HOME/buster-fast-bench/exclusive.sh" "$@"
