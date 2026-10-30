#!/bin/bash
# Runs measure-ab.sh between main 7f857786 and #930's head after its review's fixes.
cd ~/buster-fast-bench/solve-147-claude
echo $$ > queue-f.pid
./measure-ab.sh main-7f857786 alias-3030eb24 alias2 "solve #137 #147 #148 (#930 review fixes A/B)" https://github.com/buster14a/buster/pull/930 > measure-alias2.out 2>&1
echo "alias2: status $?"
echo done
