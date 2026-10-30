#!/bin/bash
# Waits for measure-asm2.sh (by its PID file), then runs measure-ab.sh for #137's compiled worlds and #147's aliases,
# one after the other.
cd ~/buster-fast-bench/solve-147-claude
echo $$ > queue-b.pid
while kill -0 "$(cat measure-asm2.pid)" 2>/dev/null; do sleep 10; done
./measure-ab.sh main-7f857786 worlds-cda3a412 worlds "solve #137 #147 #148 (#137: compiled worlds A/B)" https://github.com/buster14a/buster/issues/137 > measure-worlds.out 2>&1
echo "worlds: status $?"
./measure-ab.sh main-7f857786 alias-2402c9d2 alias "solve #137 #147 #148 (#147: alias, weakref, ifunc, retain A/B)" https://github.com/buster14a/buster/issues/147 > measure-alias.out 2>&1
echo "alias: status $?"
echo done
