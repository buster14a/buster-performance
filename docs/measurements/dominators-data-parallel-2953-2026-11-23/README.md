# Dominator tree and natural-loop construction on Zen 5

## Natural-loop measurements for PR 3455

The original November 23 runs compare revisions `6c67b3b85` (`full4`) and `86e84d6c3` (`full5`) with the same parent, `968a085fe`. Each directory contains three paired SQLite CFG runs and three paired synthetic runs on CPU 2 of the locked Ryzen 7 9700X. The SQLite correctness run checked 7,806 control-flow graphs from 2,602 functions and passed 33,748,419 checks. Both builds, both correctness fixtures and every benchmark process exited successfully. The archive preserves the original author's runner, exact revisions, executable hashes, status records and raw logs.

[Native measurement archive](natural-loop-handoff.tar.xz) · [Original issue handoff](https://github.com/buster14a/buster/issues/2953) · [Natural-loop implementation](https://github.com/buster14a/buster/pull/3455)
