# Standalone oracle runners: measured policy and local correction

This record supports [Buster PR #729](https://github.com/buster14a/buster/pull/729)
and the remaining runner scope of [#542](https://github.com/buster14a/buster/issues/542).
The measured `7ae3a32f` candidate is preserved separately from the reviewed
`5ac632f8` policy correction. The corrected head has passed local functional gates;
**no controlled native timing result here measures `5ac632f8`**. The PR remains
draft, with new-head CI and final acceptance separate from these receipts.

The measured result rejects caching the twelve cheap standalone builtin commands
in USE mode. The correction keeps their common runner and runs their external
oracles freshly in USE; explicit CHECK still independently executes and validates
the cache. Assembler reuse remains a conditional warm-cache tradeoff. No
whole-CI speedup or workload hit distribution was measured.

## Exact identities and method

| Item | Identity |
| --- | --- |
| Pure source control | `e7f89091648f68940b595aadd648841c1ffc3ec5` |
| Control native image SHA-256 | `06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e` |
| Measured candidate source | `7ae3a32f866ccf3df5fa3becade7bf264d6da76e` |
| Measured candidate native image SHA-256 | `d173bf9255536476b1a532737467c3ea6aa71f9c9d8c254288331bb2559ec1d6` |
| Corrected source | `5ac632f8f22022d67a07bc01db280e28826a38cd`, tree `f71ea844a0422988d62e16bf2fc064d1108f311b` |
| Corrected local image SHA-256 | `9148a3f85ee26dd61d7b1fd46ae8fb2c4f1838d86ad31df553eeb40d32435ddf` |
| Official native Clang executable SHA-256 | `c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67` |
| Original C timing helper SHA-256 | `fb20acbc9e30810a40bdd6e3b119d09593233fc9be3829bdc455385f41bd11aa` |

Native builds use official Clang 23.1.4, `BUSTER_HOST_ARCH=native` and
`BUSTER_DEBUG_INFO=1` on the shared Ryzen 7 9700X. Local corrected-head gates use
Clang 23.1.4, native/debug0. The native control and candidate use the **same frozen
e7 source working directory**, tool/runtime paths, locale, timezone and
`SOURCE_DATE_EPOCH=1792454400`. Native test/timing processes are pinned to CPU 2.
Every substantial target action holds the shared exclusive lock separately;
test processes have 110-second inner and 120-second outer bounds. Complete shell
commands, lock receipts, timestamps, tool paths and recorded hashes are in
[`native-7ae/receipts`](native-7ae/receipts/) and the per-run `.method` files.
The longest timed command took 9.042 seconds. No host setting or package changed.

The original [`native_time.c`](native-7ae/native_time.c) uses monotonic wall time
and `wait4` child CPU/resource totals, propagating the child status. Its exit-7
negative control is retained. Traced functional runs and untraced timings are
separate; no traced elapsed time contributes to the table below. All 42 controlled
receipts passed: 17 functional, 24 timed, and one final builtin OFF execution proof.
The directed object-output probe is separate from that count.

## Frozen 7ae mode costs

Seconds are **wall / user+system CPU**. Warm rows are medians of three matched
pairs, in AB/BA/AB order. Each OFF, cold and CHECK row is one matched pair, so
those costs carry no tight confidence claim. Every timed sample exited zero and
reported zero major faults. Raw C receipts are in [`native-7ae/logs`](native-7ae/logs/);
[`timed-samples.tsv`](timed-samples.tsv) lists every sample used.

| Group / mode | Pure e7 control | Candidate 7ae |
| --- | ---: | ---: |
| Builtins OFF | 4.659511 / 1.350004 | 1.463543 / 1.356013 |
| Builtins cold USE | 8.973127 / 5.558757 | 8.874037 / 8.743167 |
| Builtins warm USE | 8.276042 / 4.766803 | 7.074865 / 6.839237 |
| Builtins CHECK | 8.743384 / 5.611884 | 9.042037 / 8.881130 |
| Assembler OFF | 1.379013 / 1.241337 | 1.343986 / 1.252825 |
| Assembler cold USE | 1.372540 / 1.239995 | 1.468306 / 1.375342 |
| Assembler warm USE | 1.378574 / 1.240727 | 1.306350 / 1.200848 |
| Assembler CHECK | 1.377462 / 1.238390 | 1.487265 / 1.383945 |

Builtin warm USE reduces wall versus the control's USE by 14.51%, but increases
CPU by 43.48%, and is substantially worse than the same candidate's OFF path.
Warm-only acceptance is therefore rejected. The OFF comparison measures the
combined runner/pipeline change: common process runners, stable fixture paths
and two object-compile/fresh-link splits changed together. It does **not** isolate
one wait primitive. Historical native CI used CHECK; the old USE comparison is
an additional control rather than its historical CI policy.

Assembler warm wall/CPU improve 5.24%/3.21%, with all three pairs improving.
The single cold/CHECK pairs add about 0.096/0.110 seconds wall and 0.135/0.146
seconds CPU. The retained policy exposes this tradeoff; it does not establish a
net job improvement at an unknown warm-hit rate.

## Verified execution counts and the corrected counting error

Successful complete executable paths are recorded under
[`native-7ae/full-paths`](native-7ae/full-paths/). For these frozen exec traces,
first verify there are **no `unfinished` or `resumed` records**, select only
`execve` lines ending in `= 0`, extract the first quoted executable path, sort
and count identical full paths. Failed PATH probes do not count. Combine the
verified official `bin/clang` **and** `bin/clang-23` paths as one Clang family.
GCC driver, its `cc1`, GNU `as`, `ld` and temporary generated programs remain
separate. The table was checked against that full-path view, not basenames.

| Warm group | Pure e7 control | Candidate 7ae |
| --- | --- | --- |
| Builtins | Clang family 324; ld 2; generated programs 2 | Clang family 4; ld 2; generated programs 2 |
| Assembler | Clang family 108; GCC driver 9; cc1 8; GNU as 81; ld 50; generated programs 51 | Clang family 108; GCC driver 1; cc1 0; GNU as 0; ld 50; generated programs 51 |

The earlier derived basename-only figures **322→4** and **59→108** missed
`clang-23`; the claim of 49 extra assembler Clang executions is withdrawn.
Correct figures are **324→4** and **108→108**. Raw traces were untouched.
[`negative-records/analysis-basename-only.json`](negative-records/analysis-basename-only.json)
preserves that wrong view as a method negative, never as authoritative counts.
Private Python analysis/orchestration is deliberately excluded from this record.

All twelve builtin commands passed 54,482 checks per group, and assembler
`--cross-check` passed 1,891,352 checks in every functional phase for both images.
The 7ae native cache regression passed 124/0. Candidate cache counters were:

| Group | Cold taken/run/stale/unkept | Warm | CHECK |
| --- | --- | --- | --- |
| Builtins | 0/544/0/2 | 544/0/0/2 | 0/544/0/2 |
| Assembler | 1/88/0/58 | 89/0/0/58 | 0/89/0/58 |

The official toolchain's two builtin and 58 assembler unkept calls are retained
limits. The separate direct-output probe observes a random-device read on Clang
direct object output, none on stdout-object output, with byte-identical objects
SHA-256 `3bf21d41113f3907af8e3591fbefde15b60674368ba2858af9f8fd641fea4b5f`.
Objects are omitted, while source, traces and the successful compare receipt are
retained. No cache identity or random-device rule was weakened.

## Corrected 5ac policy and exact local gates

The four-file correction saves/restores the builtin translation unit's mode
around dispatch for an explicit twelve-command whitelist. It turns USE into OFF
only within that scope. CHECK remains literal and stale-rejecting; OFF, unrelated
commands, timed competitors, cache schema/identity, assembler policy and CI gates
remain unchanged. Normal success, command failure, launcher failure and argument
rejection restore the prior mode. The signed source metadata and exact follow-up
patch are in [`source`](source/).

| Exact 5ac local gate | Result |
| --- | --- |
| Complete compiler build | 41 units, 131.8 seconds |
| Actual cache module, optimized | 143 checks, zero failures |
| Actual cache module, ASan+UBSan/leak | 143 checks, zero failures |
| Actual rebuilt dispatcher, all twelve USE commands | 54,482 checks, zero failures; 557 successful Clang-family executions; 2 links; both native programs executed; zero cache entries |
| Actual rebuilt dispatcher, all twelve CHECK commands | 54,482 checks, zero failures; twelve literal CHECK reports; 546 run, zero taken/stale/unkept |

The USE dispatcher trace has 333 `/usr/bin/clang` plus 224 `/usr/bin/clang-23`
executions. Its original `strace -ff` files are concatenated with `FILE` headers
in [`local-5ac/policy-use-exec.txt`](local-5ac/policy-use-exec.txt); records are
otherwise unchanged and have no unfinished/resumed calls. This actual-dispatch
gate matters because oracle state is per translation unit. Permanent regressions
also cover exact-name exclusions, nested/off restoration and stale CHECK refusal.
All local receipts and counts are under [`local-5ac`](local-5ac/).

Independent source review found no blocker in the original object/text-only
adapter, portable fixture correction, or final scoped mode lifecycle. Source
review is separate from test results. At publication, 5ac native timing and
new-head hosted CI remain separate pending gates. The prior 7ae CI run
[40759348096](https://github.com/buster14a/buster/actions/runs/40759348096) passed
both hosted variants, native Benchpress and the aggregate; that result does not
qualify 5ac. Current-head CI is
[40777887048](https://github.com/buster14a/buster/actions/runs/40777887048).

## Retained first failures and dispositions

- The first adapter regression restored a cached executable as a non-executable
  file and failed 116/1. The fix caches objects/text only and links/executes
  freshly; it does not alter the approved cache format or add mode machinery.
- The first target harness expected absent GNU `time` and stopped before tests.
  Its setup failure is retained separately from actual test failures.
- Old 816 hosted/native cache fixtures failed 122/7 because direct Clang object
  output can legitimately be uncacheable. The portable stdout-object fixture
  passed 124/0, preserving explicit uncacheable-success/fresh-execution coverage.

Those receipts are under [`negative-records`](negative-records/). Old source and
image identities remain distinguishable. Binary executables, object files, cache
contents, duplicate tar files and private Python tooling are excluded. This is
a bounded source/receipt record, not a cache payload or toolchain distribution.
