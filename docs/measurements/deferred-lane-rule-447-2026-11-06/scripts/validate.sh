#!/bin/bash
# #447's validation: main's rule (tree/, 7997476e) against the refitted rule (cand/, a2f11bd8), each by the rule on 8
# permitted lanes against one lane in the same process, in processes that alternate by round, on the 35 units of the
# grid and the fit whose lanes the two rules give differently and four controls they give alike. Five rounds, each one
# lock hold.
cd ~/buster-fast-bench/447-claude
scripts/queue.sh validate 5 rule:8,cand+rule:8 'musl/regex/regcomp.c cts/00204.c musl/stdio/vfprintf.c musl/malloc/mallocng/malloc.c musl/math/lgamma_r.c musl/math/j0.c musl/internal/floatscan.c musl/math/fmal.c musl/math/exp2l.c musl/math/__rem_pio2_large.c syn/b16x19.c syn/b16x5.c syn/d16x19f384s192.c syn/d16x19f384s288.c syn/d2x1f384s288.c syn/d2x1f480s240.c syn/h16x10.c syn/h16x19.c syn/h16x38.c syn/h16x5.c syn/h64x1.c syn/h64x10.c syn/h64x3.c syn/l16x10f192.c syn/l16x10f384.c syn/l16x19f192.c syn/l16x19f384.c syn/l16x38f192.c syn/l16x38f384.c syn/l16x5f384.c syn/l4x38f384.c syn/l8x38f384.c syn/x16x19.c syn/x16x38.c syn/x16x77.c  sqlite syn/b16x77.c cts/00213.c musl/string/strlen.c'
