#!/bin/bash
cd $(dirname $0)
while pgrep -x run-s2.sh > /dev/null; do sleep 10; done
./measure2.sh s4 claude/zen-johnson-cah6b5 27ee009a3 $PWD/patches/s4.patch annotate
