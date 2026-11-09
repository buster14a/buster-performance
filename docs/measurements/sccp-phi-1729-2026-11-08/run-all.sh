#!/bin/bash
D=$HOME/buster-fast-bench/1729-opencode
cd "$D"
until grep -q "published as" head-build.log; do sleep 5; done
./measure.sh
./dom.sh
echo all-done > run-all.done
