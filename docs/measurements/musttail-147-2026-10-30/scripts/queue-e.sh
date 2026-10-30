#!/bin/bash
# Runs measure-ab.sh between main b424fe30 and #147's musttail head (measure-ab.sh builds the head first).
cd ~/buster-fast-bench/solve-147-claude
echo $$ > queue-e.pid
./measure-ab.sh main-b424fe30 musttail-d6e7dc2b musttail "solve #137 #147 #148 (#147: musttail A/B)" https://github.com/buster14a/buster/issues/147 > measure-musttail.out 2>&1
echo "musttail: status $?"
echo done
