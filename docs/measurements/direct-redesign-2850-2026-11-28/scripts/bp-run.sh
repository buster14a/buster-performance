#!/bin/bash
# bp-run.sh NAME COMMAND...: one command on the 9700X under its lock, pinned to CPU 2.
name=$1; shift
exec env EXCLUSIVE_OWNER=claude-fermat-16yme8 EXCLUSIVE_TITLE="Direct path performance redesign: $name" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850 \
  timeout -k 5 300 ~/buster-fast-bench/exclusive.sh taskset -c 2 "$@"
