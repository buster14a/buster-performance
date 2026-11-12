#!/bin/bash
cd $(dirname $0)
while pgrep -x run-merged.sh > /dev/null; do sleep 10; done
./measure2.sh stagger-f5b919f2 claude/zen-johnson-cah6b5 f5b919f20 $PWD/patches/stagger2.patch && rm -rf src/build
