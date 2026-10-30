<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->
# Exact timed interval and summary statistic

This is the unmodified source benchmark at
[`20e01ceb`](https://github.com/buster14a/buster/blob/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf/src/buster/compiler/c_lowering_source_benchmark.c#L74).
It is a warm lowering/object-in-memory comparison. Its source comment's broad
"everything -c does" shorthand does not describe unwind/verification accurately;
the actual call at
[lines 89–90](https://github.com/buster14a/buster/blob/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf/src/buster/compiler/c_lowering_source_benchmark.c#L89)
passes `unwind=false, verify=false`, as named in the
[emitter signature](https://github.com/buster14a/buster/blob/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf/src/buster/compiler/c_check_program_emit.c#L2198).

Before timing a process preprocesses and checks every body, prepares static data
and the checked program, reserves its outer/per-file arenas, and warms referenced then all mode.
The [timed loop](https://github.com/buster14a/buster/blob/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf/src/buster/compiler/c_lowering_source_benchmark.c#L235)
alternates the first mode for each of 21 passes. Each timed call includes:

- `check_program_select_mode`, including its per-run graph/planner construction;
- lowering/Tier 0, branch sizing, encoding and internal link code;
- static-data publication and named-section placement;
- link checks, object preparation, symbol mapping and `object_build` in memory;
- restoring the four arena marks before returning.

Preprocessing, checking, prepared-program/static-data construction, outer/per-file arena reservations,
warm-ups, unwind generation, optional emitter verification and writing the object
file are outside or absent from this interval. Ordinary lowerer/link/format checks
still run; `verify=false` does not mean every validation is disabled. These are
neither whole-driver times nor code/data emission costs with CLI unwind enabled.
The command reports no cycles/instructions or internal pass sample list.
Internal emitter allocations and releases remain timed: with `lanes=NULL`,
[`check_program_emit`](https://github.com/buster14a/buster/blob/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf/src/buster/compiler/c_check_program_emit.c#L1208)
reserves `own_columns` and releases it before return. The excluded outer
reservations must not be read as excluding every allocation/first touch.

For process i, let R_i be its referenced-mode 21-pass median and A_i its all-mode
21-pass median. The reader reports medians over 11 processes of R_i, A_i,
`S_i = A_i - R_i`, and `P_i = 100 * S_i / A_i`. The paired saving is the
**difference of the two within-process medians**, not the median of individual
inner paired differences; those inner differences are unavailable. The difference
of the separately reported outer medians also need not equal median(S_i).

The exact central binomial interval uses sorted process observations 2 and 10,
nominal coverage 0.988281250 under independent identically distributed rounds.
Its observations are process-level statistics; it gives no interval for the
unprinted inner samples. Fresh processes and separate lock holds do not prove
statistical independence; min/max and every raw process report are retained.
The two independent clock reads use `CLOCK_MONOTONIC_RAW`.

The raw benchmark object sizes are consistently 34,266,000 / 39,027,752 bytes.
Actual `--verify -c` selected/all CLI objects are 35,327,656 / 40,446,704 bytes;
their section reports include `.eh_frame`. The latter provide separate actual
object/unwind acceptance, not the timed payload identities. Benchmark repeats
check counts and object size against warm-up, not object-byte identity or native
arithmetic for instructions absent from the host.

The offline C reader's output reproduced the retained `postcheck/summary.tsv`
byte for byte (SHA-256
`00b1759029420953f5c838a2c1423f9bc0de96e93a54ef72c96ecfc8ba55f655`).
Synthetic reader controls were not observations in this campaign.
