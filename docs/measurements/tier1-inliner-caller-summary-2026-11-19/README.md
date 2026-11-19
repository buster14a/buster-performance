# Skipping the finished caller's callee summary

[Buster PR #3119](https://github.com/buster14a/buster/pull/3119) omits the final callee summary for the designated caller of a single-caller inlining unit. Base `903bf7ef4300ec8e70898afd734d66c3f0bd1ad3` and head `2115a6e1c4d9f408f947c0b22da8cdf235f40f29` used the repository Release build with `BUSTER_HOST_ARCH=znver5` and pinned Clang 23.1.4 (`7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`). The installed 9700X ran Linux 6.18.50-2-lts with boost enabled and the performance governor.

## Normal compiler layout

One warmup and six paired runs per workload on physical CPU 2. The inliner’s compiled output was identical across each pair. Changes below are the medians of the within-round ratios. CPU time is task-clock recorded for the whole compiler process, with one lane. Elapsed seconds printed by test programs are separate.

| Unit | Median base instructions | Median head instructions | Instruction change | Cycle change | CPU-time change |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite 3.53.2, Tier 1 | 7,852,212,636 | 7,798,104,607 | −0.689% | −0.572% | −0.613% |
| Lua 5.4.8 parser, Tier 1 | 151,748,808 | 150,455,484 | −0.852% | −0.623% | −0.031% |
| Lua 5.4.8 VM, Tier 1 | 301,719,307 | 301,415,918 | −0.101% | −0.064% | −0.292% |
| SQLite 3.53.2, Tier 0 control | 1,174,820,828 | 1,174,820,810 | 0.000% | +0.154% | +0.133% |

Each of the six SQLite Tier 1 cycle pairs improved (0.29%–1.11%). CPU time went from 590.30 to 586.77 ms. The Lua pair ranges span both signs in cycles. All four workloads produced exactly one object digest each, shared by base and head on every run.

`normal-layout.tsv` contains all 56 observations, including warmups, with timestamps, load averages, checksums and counters. Put the SQLite 3.53.2 amalgamation at `inputs/sqlite3.c` (SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`) and the Lua 5.4.8 distribution’s source directory at `inputs/lua`. Build each exact Buster checkout with `BUSTER_HOST_ARCH=znver5 ./build.sh --config Release` and put the stripped programs at `compilers/inline-base` and `compilers/inline-head`. On benchpress, set `EXCLUSIVE_OWNER` to your own session and run `./confirm-compile.sh inline 6 sqlite-tier1 lua-lvm sqlite-tier0 lua-lparser`. The harness takes a fresh shared lock for each invocation and exits if the host is busy. The checked-in copy uses a generic private temporary-object filename and links the published PR.

## Correctness

The new regression exercises a caller with 8,192 stack slots and 4 KiB of scratch. Only that check fails with the parent inliner restored and the regression present. The candidate passes all 125,211 `test-ir-inline` checks with 22,432 independent interpreter executions. `objects.tsv` gives the identical SHA-256 for each pair in local Tier 1 builds of all 34 Lua translation units and SQLite at both `-O2` and `-O2 -g`, using the same flags as the harness.
