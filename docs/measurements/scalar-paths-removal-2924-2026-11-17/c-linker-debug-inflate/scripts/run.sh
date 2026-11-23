#!/bin/sh
# usage: run.sh NAME COMMAND... : one locked run in ~/buster-fast-bench/2924-linker, output in NAME.log
cd ~/buster-fast-bench/2924-linker
name=$1; shift
export EXCLUSIVE_OWNER=claude-2924-linker EXCLUSIVE_TITLE="buster #2924: linker and executable twins" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924#issuecomment-7113415815
~/buster-fast-bench/exclusive.sh timeout -k 5 600 "$@" > $name.log 2> $name.err
echo "exit $?" >> $name.log
