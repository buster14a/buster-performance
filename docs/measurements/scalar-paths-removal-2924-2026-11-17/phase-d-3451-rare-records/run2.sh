#!/bin/bash
# run.sh: #3451's rare-records gate: main aeb99a83e's effects (old) against the branch's fbc389044 (new), every dumped
# real call of main.c (t1g, t1v), c-testsuite (t1g, t1v) and Lua 5.4.8 (t1g), CPU 2, one locked run.
set -u
cd "$(dirname "$0")"
sha256sum gate-f
for f in mainc-t1g ct-t1g ct-t1v lua-t1g mainc-t1v; do taskset -c 2 ./gate-f dumps/$f.bin; echo "exit $?"; done
