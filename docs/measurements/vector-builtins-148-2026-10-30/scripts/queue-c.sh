#!/bin/bash
# Runs measure-ab.sh for #148's atomics and vectors against main, one after the other.
cd ~/buster-fast-bench/solve-147-claude
echo $$ > queue-c.pid
./measure-ab.sh main-7f857786 atomics-fa9c006d atomics "solve #137 #147 #148 (#148: atomics A/B)" https://github.com/buster14a/buster/issues/148 > measure-atomics.out 2>&1
echo "atomics: status $?"
./measure-ab.sh main-7f857786 vectors-16d2c4ef vectors "solve #137 #147 #148 (#148: vector builtins A/B)" https://github.com/buster14a/buster/issues/148 > measure-vectors.out 2>&1
echo "vectors: status $?"
echo done
