# #442 bounded initializer qualification

Source is frozen at `73b6ba60604ca3da7494375f2468b23ae7d4c258`, on
`e7f89091648f68940b595aadd648841c1ffc3ec5`. No PR, push, merge or host setting
change was made. Broader timing expansion is stopped after the one approved
warm-image repeat; the whole-CLI effect remains below the layout/noise
qualification needed for an attribution claim. The isolated setup improvement
is clear. Original #442/#517 historical acceptance remains separate credited work.

## Exact build and gates

The target is the shared Ryzen7 9700X. Every staging, build, test, sample,
hash and archive operation acquired the common exclusive.sh lock independently
with owner/title/issue metadata and a finite bound. Single-thread work was CPU2;
the native build used physical CPUs0–7. No baseline was rebuilt.

Both compiler binaries use official Clang23.1.4 (LLVM7a941dfb...), native host
architecture and debug1. Frozen baseline SHA256:
`06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e`.
Candidate: `be00af5b1a8265c28122af9bd44d40cee35afda932b3de27df92dab801843290`.
Candidate native build41 sources/30.1s. Source/archive manifests and the current
toolchain/resource directory were checked before running. Input checks cover
all220 source bytes at c-testsuite5c727565 and the shared frozen SQLite/header
manifests. Native musl uses the documented Zig-vendored1.2.5 snapshot and copy-only
overlay, verified by known manifests; it is not pristine upstream musl.

| Native gate | Result | Receipt |
| --- | --- | --- |
| ABI cross400, including both char modes/all vector widths | Pass | target-abi.log |
| Guarded initializer/allocation cutoffs | 67,536 cases,0 failures | target-guard.log |
| c-testsuite cross-check | 220/220 pass,0 unsupported | target-c-testsuite.log |
| Baseline/head scalar/vector objects | All220 byte-identical | target-objects.log |
| Full checker | 497,021 checks,0 failures | target-checker.log |
| Current frozen symbols gate | 354/354 compared,0 differences/unexplained/failures | target-symbols.log |
| Frozen SQLite four-path objects | All match8e9361e7a6c5efe5b25c214c162b643f3eacbe0605ff9004678323178072ef5c | target-sqlite-objects.log |

Local complementary gates are in REPORT.md, including native and generic-host
ASan+UBSan, independent seven-column scalar recomputation, capacity/prefix0..66,
CI selector, callgraph and byte-identical regeneration. The rejected local
debug0/debug1 whole/fresh screens are retained and excluded from conclusions.

## Isolated setup mechanism

Matching original-C helper builds initialize the same64-row ABI reservation,
with all three vector widths and both plain-char modes. Each call's result is
observable to an opaque memory consumer; allocation/type setup is outside the
timed loop. Each configuration has a retained primer and the nine-role cycle
aaa,aaa,bbb,aaa,ccc,bbb,bbb,ccc,ccc, covering every predecessor/current pair once.
Each role appears three times,200,000 initializations per observation. aaa/ccc
are baseline and bbb is candidate. Every output checksum and success flag agrees.

The baseline role means are486.55–503.23ns per initialization and the candidate
18.18–19.42ns. This difference greatly exceeds observed A/A variation. The
measurement is a hot repeated initializer; it excludes fresh exec, type
construction, later classification/lowering and final output. It does not
reproduce or reinterpret the historical25ns figure, and establishes no
whole-compiler throughput gain. Raw target-init-first.log, extracted
target-first/results/init-first and target-init-first-summary.tsv retain it.

## First-image observations, retained

The first fresh-exec method primed only ccc to establish its predecessor. It
therefore mixed two initial image touches with primed ccc executions. All nine
cohorts per case have64 child observations,192 per role. The first aaa function
sample took3.509ms with two major faults; the first bbb took11.225ms with two major
faults; ccc had no major faults. All samples, including these, remain unchanged.
The function candidate mean is+3.3% versus the A/A mean; its cohort medians and
child CPU means do not show that persistent regression. This is not a fair
population for warm-image attribution, nor a sufficient cold-image sample to
identify a compiler or upstream root cause. No sample was dropped.

Archive target-first-results.tar SHA256:
`45a7397ab2e5005123427263f343dc4a3bcef3ba5876e6ad5c47eff4a387cc10`.
Raw methods, outputs, counters, child rows, status and hashes are preserved.

## One warm-image/new-exec repeat

Root approved exactly one bounded correction of unequal priming. Version3 primes
aaa,bbb,ccc with the same64-child work, ccc last, then uses the same nine-edge
measured cycle. It is a new method filename/hash; the first method and raw data
were preserved. This is warm-image/new-exec work, not a cold-page-cache claim.
It still counts each new process's minor faults and runtime memory footprint.

Before each case, all aliases were verified regular, executable, mode755,
distinct inodes, link count1, equal-length paths and exact pinned byte hashes.
Every measured cohort completes64 ordered children with status0 and nonempty
objects. All nine perf events are supported at100% duty, with zero migrations
and zero major faults across the eighteen measured cohorts. Child and parent
counter records remain separate; no missing value becomes zero.

The table reports means over each role's three cohorts; the median column is the
mean of those three64-child cohort medians, not a pooled median or confidence
interval. Child CPU is wait4 user+system; RSS and minor faults are per-child means.

| Case / role | Child wall mean(ms) | Cohort median mean(ms) | Child CPU mean(ms) | RSS(KiB) | Minor faults |
| --- | ---: | ---: | ---: | ---: | ---: |
| Function / aaa | 1.264270 | 1.235985 | 1.209245 | 22169.1 | 374.271 |
| Function / bbb | 1.258101 | 1.231401 | 1.205167 | 22165.3 | 373.516 |
| Function / ccc | 1.271216 | 1.239916 | 1.215526 | 22164.0 | 373.953 |
| No body / aaa | 0.729083 | 0.697519 | 0.670885 | 17024.6 | 350.953 |
| No body / bbb | 0.722926 | 0.698074 | 0.671672 | 17037.2 | 351.536 |
| No body / ccc | 0.725292 | 0.698456 | 0.673385 | 17023.0 | 351.167 |

Function cohort medians are0.53% lower than the average A/A value, with0.32%
A/A drift. No-body medians are0.01% higher. Wall means move by about0.6–0.8%,
including a similar apparent improvement in the no-body negative control where
ABI setup is skipped. A/A mean drift is about0.5%; code/data placement is another
unqualified factor. These controls do not establish a general CLI gain, neutral
equivalence bound or universal startup behavior. RSS shows no repeatable2MiB
increase; the small remaining no-body difference is about13KiB and must not be
called an ABI allocation increase. The allocation sizes are unchanged by source.

Version3 method hashc5c9995cc2fc6db81fc76f2ca3192a816f94683841ca757c87193515a5900ba4.
Warm archive SHA256:
`b27c90c415a857729ab5f6310efd6d67da920fb92a89b375a5f061ad27a48893`.
target-warm-role-summary.tsv, target-warm-cohort-summary-direct.tsv and
target-warm-counter-gate.tsv summarize immutable raw rows without exclusions.

## Publication boundary

The source is functionally qualified for this frozen snapshot and clearly
removes repeated initializer work. Whole-CLI benefit is not qualified. Per the
stop policy, no broader post-checking/large-unit timing campaign is being run and
no performance conclusion is filled in from isolated results. Root must choose
whether to retain this as a prototype/closure record or publish a narrowly scoped
draft with these limits. There is no blanket Fixes442, demand-scheduler delivery,
universal whole-compiler headline or claim about later main revisions.
