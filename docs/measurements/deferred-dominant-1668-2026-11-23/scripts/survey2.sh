#!/bin/bash
# survey2.sh: survey.sh's runs (round 1's first two groups done) with each round's groups in one lock hold, which lasts
# seconds: the #1667 units by every lane up to 2 and the rule on 8 (rounds 1 to 5, round 1 with its third group alone),
# the #1668 units and held-out shapes by the rule on 8 (5 rounds), then the probe's units (one round, holds of 750).
cd ~/buster-fast-bench/1667-claude
gap='musl/regex/regexec.c musl/stdio/vfprintf.c cts/00204.c musl/thread/pthread_create.c musl/malloc/mallocng/malloc.c musl/math/fmal.c musl/math/lgamma_r.c musl/math/j0.c musl/math/exp2l.c musl/crypt/crypt_des.c lua/lvm.c lua/lparser.c lua/lcode.c lua/lstrlib.c lua/lapi.c'
dom='syn/d16x19f384s288.c syn/d16x19f384s192.c syn/l16x38f384.c syn/h16x38.c sqlite lua/onelua.c syn/d32x10f768s96.c syn/d4x19f768s384.c syn/d24x19f768s48.c syn/d8x38f512s288.c syn/d32x5f384s192.c syn/d12x38f192s192.c syn/d32x10f384s96.c syn/d16x19f256s96.c syn/d32x10f192s48.c syn/d12x38f256s48.c syn/d24x19f384s192.c syn/d16x38f384s96.c syn/d32x19f256s48.c syn/d32x10f96s48.c syn/d24x38f768s288.c'
NO_DONE=1 scripts/queue.sh survey 1 every:2,rule:8 'musl/regex/regexec.c musl/stdio/vfprintf.c cts/00204.c musl/thread/pthread_create.c musl/malloc/mallocng/malloc.c lua/lvm.c lua/lparser.c lua/lcode.c lua/lstrlib.c lua/lapi.c'
FIRST_ROUND=2 scripts/queue.sh survey 5 every:2,rule:8 "$gap"
scripts/queue.sh dom 5 rule:8 "$dom"
scripts/probe-run.sh
