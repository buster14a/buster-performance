#!/bin/bash
# e2e-wait.sh: e2e.sh's three rounds of the 21 #1668 units, in three holds a round, after dom's survey.
cd ~/buster-fast-bench/1667-claude
until grep -q ^done logs/dom.queue 2>/dev/null; do sleep 15; done
scripts/e2e.sh 3 "syn/d16x19f384s288.c syn/d16x19f384s192.c syn/l16x38f384.c syn/h16x38.c sqlite lua/onelua.c syn/d32x10f768s96.c" \
    "syn/d4x19f768s384.c syn/d24x19f768s48.c syn/d8x38f512s288.c syn/d32x5f384s192.c syn/d12x38f192s192.c syn/d32x10f384s96.c syn/d16x19f256s96.c" \
    "syn/d32x10f192s48.c syn/d12x38f256s48.c syn/d24x19f384s192.c syn/d16x38f384s96.c syn/d32x19f256s48.c syn/d32x10f96s48.c syn/d24x38f768s288.c"
