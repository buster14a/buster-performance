#!/bin/bash
# The kernels' and the sizes' measurement, then sqlite3.c's compile, each its own lock hold.
cd ~/buster-fast-bench/1376-opencode
lock() { EXCLUSIVE_OWNER=opencode-1376 EXCLUSIVE_TITLE="#1376 zero-initialized locals" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1376 ~/buster-fast-bench/exclusive.sh "$@"; }
echo "== measure"; lock ./measure.sh
echo "== compile"; lock ./compile.sh
echo done
