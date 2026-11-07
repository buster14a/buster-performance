#!/bin/bash
# usage: lock.sh COMMAND... ; runs under the 9700X lock
export EXCLUSIVE_OWNER="claude-672" EXCLUSIVE_TITLE="#672: 1 GB/s tracker, peak-RSS work" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/672"
exec ~/buster-fast-bench/exclusive.sh "$@"
