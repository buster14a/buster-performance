#!/bin/bash
# x.sh COMMAND...: one run under the 9700X's lock, with this session's owner lines.
export EXCLUSIVE_OWNER=claude-direct-r9uggb
export EXCLUSIVE_TITLE="Direct path speed, redesign (#2850)"
export EXCLUSIVE_LINK=https://claude.ai/code/session_01TiDLntcMpWpDsqnKHV2fbS
exec "$HOME/buster-fast-bench/exclusive.sh" "$@"
