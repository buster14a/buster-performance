#!/bin/bash
# Usage: ex.sh DIR COMMAND... : runs COMMAND in DIR under the 9700X lock, one hold per call.
dir="$1"; shift
cd "$dir" || exit 1
export EXCLUSIVE_OWNER=claude-2086-k5
export EXCLUSIVE_TITLE="Parser K5 stale scratch (#2086)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2086
exec ~/buster-fast-bench/exclusive.sh "$@"
