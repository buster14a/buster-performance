#!/bin/bash
# Runs measure-ab.sh between main 7f857786 and #929's head after its review's fixes.
cd ~/buster-fast-bench/solve-147-claude
echo $$ > queue-g.pid
./measure-ab.sh main-7f857786 asm-a40d0817 asm3 "solve #137 #147 #148 (#929 review fixes A/B)" https://github.com/buster14a/buster/pull/929 > measure-asm3.out 2>&1
echo "asm3: status $?"
echo done
