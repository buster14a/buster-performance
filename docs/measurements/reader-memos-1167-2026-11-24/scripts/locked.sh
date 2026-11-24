#!/bin/bash
set -eu
export EXCLUSIVE_OWNER=codex-1167-6b0557dc EXCLUSIVE_TITLE="Sparse reader columns for issue 1167" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1167
export CORES_TITLE="$EXCLUSIVE_TITLE" CORES_LINK="$EXCLUSIVE_LINK"
exec "$HOME/buster-fast-bench/exclusive.sh" bash -c '
  cat /proc/loadavg >&2
  ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >&2
  "$@"
  result=$?
  cat /proc/loadavg >&2
  ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >&2
  exit "$result"' bash "$@"
