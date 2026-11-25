#!/bin/bash
# x.sh COMMAND...: one run under the 9700X's lock, with this session's owner lines.
export EXCLUSIVE_OWNER=claude-3584-s6acj8
export EXCLUSIVE_TITLE="GitHub issue #3584"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3584
exec "$HOME/buster-fast-bench/exclusive.sh" "$@"
