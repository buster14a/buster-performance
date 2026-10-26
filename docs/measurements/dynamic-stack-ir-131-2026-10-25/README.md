# Dynamic-stack IR lowering, October 25, 2026

Evidence for [Buster #131](https://github.com/buster14a/buster/issues/131) and
[PR #420](https://github.com/buster14a/buster/pull/420). The implementation and
benchmark are in Buster; this record contains original measurements, build/test
receipts, source identities and the small C sanitizer build adapter.

The final head passes 75/75 protected CI commands and 21/21 relevant optimized
and ASan/UBSan suites. Three refreshed-main pairs show 5.0-6.3% lower ordinary
lowering time in all six measured cases, with disjoint observed ranges and
unchanged ordinary IR counts/retained/scratch bytes. IR and checked execution
are qualified; native Tier1 dynamic execution remains explicitly unsupported.

The final PR head is `90903dedebfcf4574cfed05c90b358ae5c37cfd0`.
Its production integration parent `c59c70df4d1a9d09302199617303f7aebdb912ac` merges
the feature/test head `618d734a805e033e904bb942be5dcea19183b88c` with main
`2a76514a025f2778f1b4994d794fb20a618fb96d`. Main landed the coordinated F80
work during qualification. The two shared-file conflicts preserve its F80
type refusal and interpreter guards together with dynamic-stack handling.
No Tier0 or F80 implementation is changed by this feature relative to main.
The last commit adds the reviewer's focused valid dynamic/F80 boundary fixture
and corrects two comments; production C tokens are unchanged from that parent.
The composed-head qualification and refreshed baseline are recorded separately.

The earlier `9f1d3caf76ca9dcb7bfcf4851008065669a1d545` has C
implementation/test/build inputs byte-identical to
`d2e4bfebfb0a014ef663a1119d4b155a511b1b0f`; that parent only adds
`ir_lower_emit` to the conditioned-measurement source pattern. Primary measured
executables and implementation qualification use the `d2e4bfe` archive and
checked source manifests. Commit `618d734a` adds only the exact positive
allocation/store/zero allocation/load regression requested in the GitHub
review, in `ir_stack_test.c`; production and benchmark sources are unchanged.
Its separate validation is identified below rather than relabeling older
executable measurements as observations of this test-only commit. The earlier
qualified implementation `4d2b538467994d76a70aaad8a3c163b0ecc55b16` and its
negative performance observations are retained separately below.
The branch started at main `19764052487c941cb88e8de391471daeffe39f05`.
The pre-F80 refreshed main baseline is `5863eeda331dacaa1371e1fe9ca1456e9d0039ca`.
IR, SSA, interpreter, Tier 0, `main.c` and `build.sh` are unchanged between
these two baseline revisions; intervening frontend/performance changes are
included in that refreshed executable. The pre-F80 paired comparison uses that
refreshed executable. Earlier `base-*` measurements retain the original baseline.

The host is the approved Ryzen 7 9700X (`benchpress`), Clang 23.1.1. Every
build, test and benchmark acquired the existing `exclusive.sh` lock separately.
Single-thread measurements use CPU 2. Other jobs run between acquisitions;
there is no campaign-wide lock, overlapping CI measurement, frequency-policy
change or new dependency. `delivery-identities.txt` records the initial tools,
CPU and binary identities; `qualified-identities.txt` pins the measured optimized,
sanitizer and same-harness baseline executables. Initial source manifests cover
`src/` and `build.sh`; the qualified manifest also covers `tests/ir/`. Both
qualified trees passed that manifest before the sanitizer build. Both contain
the strengthened handle-phi fixture and diagnostic-priority/invalid-class cases.

The optimized build is the normal `BUSTER_DEBUG_INFO=0 ./build.sh` build:
`-O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror`.
`sanitizer-clang.c` runs the existing build unchanged through a private compiler
path, replacing `-O3` with `-O1`, adding ASan/UBSan and frame pointers, and
excluding Clang's `function` check. Native JIT entry points lack that check's
eight-byte metadata prefix. An initial run at `5d8db1d` with the check enabled passed 19 of
21 suites and faulted in two existing JIT harnesses at the metadata read before
entry; `function-sanitizer-boundary.txt` shows the `0xc105cafe` probe. The final
run retains ASan, the remaining UBSan checks and leak detection, and passes all
21 suites. Initial failed receipts are retained separately.

At implementation revision `d2e4bfe`, the same `relevant-tests.txt` runs through
the repository's `parallel` command:
21/21 pass optimized (8 workers, 8.0 s) and under sanitizers (4 workers, 16.5 s). Sanitizer
execution uses `ASAN_OPTIONS=detect_leaks=1:halt_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`. The full call-graph capture
checks 42 translation units, 25,632 functions and 150,570 calls, with zero
unapproved cycles and the three existing allowed components.

| Suite | Result |
| --- | ---: |
| IR core, `--count 1024` | 64,323 checks, zero failures |
| Typed-to-IR lowering | 16,292 checks, zero failures |
| New dynamic contracts/consumers | 792 checks plus 84 lifetime-helper checks |
| Canonical IR parser | 5,773 checks, 10 functions, zero failures |
| Typed interpreter / IR interpreter | 564 / 663 checks, zero failures |
| SSA core / shared-IR adapter | 2,871 / 3,730 checks, zero failures |
| SCCP/DCE/CFG, GVN, LICM, SROA, inlining | All pass; see receipts |
| Tier 1 ordinary pipeline | 3,514 checks; 1,024 native and 512 Clang results |
| Tier 0, including Clang cross-checks | 113,011 checks, zero failures |
| Tier 0 incoming variadic frame | 5,149 checks, 48 native calls |

The lowering suite compares all scalar/vector columns and sparse metadata for
768 generated functions (302,467 typed entries, 659,024 IR instructions), and
verifies both SSA promotions. The strict dynamic category comprises 256
functions and includes 426 allocations, 144 saves and 149 restores statically;
entry results/global bytes agree with the independent typed reference and Tier 0
native execution. Handwritten fixtures execute real SSA and optimizer chains,
including nested/conditional lifetimes, loops, captures crossing expression
edges and handle phis, early callee returns, ordinary fixed objects, floating
memory, invalid widths/handles, zero/large sizes, overflow and allocation rollback.

The test-only head `618d734a805e033e904bb942be5dcea19183b88c` was then
rebuilt on the same approved host (42 sources: optimized 39.4 s, sanitized
86.4 s), with each build and suite run acquiring its own lock. All 21 suites
pass again: optimized 8.0 s at 8 workers, ASan/UBSan/leak checks 16.5 s at
4 workers. Lowering now reports **16,439 checks**, including **939 dynamic
consumer/contract checks**, plus the same 84 lifetime-helper checks. The other
suite/generator totals above are unchanged. The exact positive allocation,
store 42, zero allocation and load case succeeds through both interpreter
fronts and transformed IR while empty-zero memory access remains invalid.
`logs/zero-alias-{build,tests,asan-build,asan-tests}.log` retains these results;
`source-zero-alias-SHA256SUMS` matches both final source trees, and
`zero-alias-identities.txt` pins the new executables. These results close the
regression request in [review comment 4370466342](https://github.com/buster14a/buster/pull/420#discussion_r4370466342).

## Refreshed-main production comparison

Main's F80 integration changes common typed validation, so this final A/B
rebuilds **main `2a76514a`** and **integration head `c59c70df`** with identical
final benchmark files. Their executable and harness hashes are in
`composed-final-identities.txt`; `source-composed-c59c70d-SHA256SUMS` matches
both integration-head trees. Three independent pairs alternate separate lock
acquisitions, CPU 2, seed 1, 21 rotating passes, at least 2 ms per sample.
Each cell is the median of the three process medians; brackets show their
minimum and maximum, not confidence intervals. The baseline uses `--ordinary`;
the head also measures the four new dynamic categories.

| Ordinary workload | Path | Main ns/typed entry | Integration ns/typed entry |
| --- | --- | ---: | ---: |
| Small mixed | scalar | 35.897 [35.741, 36.115] | 34.026 [33.954, 34.320] |
| Small mixed | vector | 32.473 [32.325, 32.523] | 30.861 [30.844, 31.365] |
| Larger mixed | scalar | 87.229 [86.947, 87.313] | 81.735 [81.209, 82.093] |
| Larger mixed | vector | 78.252 [78.002, 78.306] | 73.429 [73.275, 73.452] |
| Larger object | scalar | 68.429 [68.246, 68.630] | 64.583 [64.333, 64.651] |
| Larger object | vector | 61.901 [61.860, 61.948] | 58.646 [58.354, 58.792] |

All ranges are disjoint: 5.0-6.3% lower lowering time for these shapes. This is
not a whole-compiler or source-corpus claim. Ordinary retained IR bytes,
instruction counts and scratch minima match baseline, including each workload
individually. `logs/composed-{base,head}-plain-{1,2,3}.log` retains every result.
Current-head CI covers isolated and after-scalar modes; the separate repeated
pre-F80 mode comparisons below retain their own exact revisions and are not
relabeled as refreshed-main observations. No extra isolated/conditioned manual
refresh is claimed.

| Dynamic category | Scalar | Vector |
| --- | ---: | ---: |
| Integer VLA, ns/typed entry | 74.991 [74.759, 75.054] | 67.560 [67.228, 67.579] |
| ALLOCA, ns/target | 40.655 [40.335, 41.457] | 37.619 [37.509, 37.967] |
| STACK_SAVE, ns/target | 17.775 [17.728, 18.073] | 14.219 [14.135, 14.284] |
| STACK_RESTORE, ns/target | 20.198 [19.939, 20.377] | 18.626 [18.624, 18.777] |

The per-target rows charge the complete pipeline and the operand setup
described below, not intrinsic latency. The baseline intentionally refuses
these dynamic streams; they have no valid baseline speedup ratio. Their IR
counts, retained memory and minimum scratch match the later memory table:
VLA 60,577 instructions / 1,196,256 retained bytes / 43,480 scratch bytes;
isolated ALLOCA 1,539 / 33,280 / 43,532; SAVE 515 / 8,656 / 27,148;
RESTORE 516 / 8,656 / 27,212. Both lowering paths agree exactly.

A further 21-pass process checks final test/comment head `90903de` with unchanged
production C tokens: small scalar/vector 34.361 / 31.075, larger mixed
81.998 / 73.769, object 64.610 / 58.696 ns/typed entry. Every value is below
all three refreshed baseline process medians. This one-process corroboration
is retained as `logs/final-head-benchmark.log`; the three-pair observations above
remain attributed to `c59c70df`.

The integration executable has text/data/BSS sizes
24,545,933 / 10,902,124 / 238,964,153 bytes; baseline
24,510,409 / 10,901,996 / 238,962,937. Final test/comment head has
24,548,430 / 10,902,124 / 238,961,657. These host-executable figures include
new test helpers and code-layout changes, not generated native dynamic-function
sizes. The native Tier1 generated-code size/runtime boundary remains N/A.

## Method and pre-F80 investigation

Performance uses the repository's `benchmark-ir-lowering`, seed 1, 21 rotating
passes per process, samples calibrated to at least 2 ms. The initial collection
has three independent plain pairs and one pair each in isolated scalar, isolated
vector and vector-after-200-ms-scalar states. The timed interval includes typed
validation, block/stack planning, classification, exact counting/allocation/
emission and IR verification. Generation, ABI setup and minimum-scratch probing
are outside it. TSC ticks are reported independently from elapsed nanoseconds;
they are not core cycles.

Ordinary small, larger mixed and object workloads are reported separately.
Their IR instruction counts and retained arena bytes are unchanged. The new
integer VLA workload and three 512-target-operation streams report their own
throughput, IR size and scratch capacity. Allocation includes constant operand
setup/discards; save includes discards; restore includes one helper save and
repeated DUP/restore pairs. A per-target figure charges the complete lowering
pipeline and that stated setup. It is not generated-code instruction latency.

The initial plain comparison detected regressions, rather than establishing
neutrality. Each number below is the median of the three process medians; each
process uses 21 rotating passes. `current-paired-{1,2,3}.log` and
`final-paired-{1,2,3}.log` retain the observations. These two older harnesses
differ in the untimed scratch-capacity search before samples, so subsequent
diagnostics use identical harnesses and move that search after samples.

| Ordinary workload | Path | Main 5863eed ns/typed entry | Head 4d2b538 ns/typed entry | Change |
| --- | --- | ---: | ---: | ---: |
| Small mixed | scalar | 34.513 | 35.447 | +2.71% |
| Small mixed | vector | 31.345 | 31.917 | +1.82% |
| Larger mixed | scalar | 86.794 | 87.609 | +0.94% |
| Larger mixed | vector | 78.812 | 79.003 | +0.24% |
| Larger object | scalar | 67.739 | 68.445 | +1.04% |
| Larger object | vector | 62.098 | 62.282 | +0.30% |

The first attempted producer change outlines only the three new emission cases
into a cold helper. Its `outline-paired-{1,2,3}.log` records do not consistently
repair the ordinary regressions, so this experiment is not sufficient for
adoption by itself. `harness/rejected-outline.patch` preserves that original
candidate and the emitter disassembly records its reduced compiler stack frame.

Final identical-harness diagnostics and qualified measurement tables follow
below. Hardware-counter instrumentation is retained as C
sources under `harness/`; copy both benchmark files into either source revision
and use `--ordinary`. A failed hardware-counter read terminates the diagnostic
rather than presenting zero as a valid reading. These diagnostics do not modify
production lowering or the source generator.

The identical-harness diagnostics confirm that the original new rule dispatch
adds about one executed instruction per ordinary scalar IR row. For larger mixed
programs the initial head executes 1,038.031 instructions/typed entry, versus
1,035.409 at the baseline; a checked scalar-switch default for the new rule
reduces that to 1,035.723. A combined cold-emission/default candidate reduces it
to 1,034.316, but elapsed time still does not recover the baseline. These are
diagnostic candidates, not accepted improvements. In each group the instruction
readings repeat across three processes.

| Same-harness ordinary workload | Path | Baseline ns/entry | Initial head | Checked default | Cold + default |
| --- | --- | ---: | ---: | ---: | ---: |
| Small mixed | scalar | 34.602 | 36.254 | 34.624 | 35.706 |
| Small mixed | vector | 31.138 | 32.913 | 31.596 | 32.397 |
| Larger mixed | scalar | 85.419 | 87.191 | 86.647 | 87.057 |
| Larger mixed | vector | 77.608 | 79.282 | 79.020 | 79.189 |
| Larger object | scalar | 66.939 | 68.378 | 67.754 | 67.931 |
| Larger object | vector | 61.201 | 62.487 | 62.425 | 62.362 |

Each cell is the median of three 21-pass process medians. The logs also retain
TSC ticks, actual core cycles and all three observations. `probe-identities.txt`
pins the baseline and initial-head executables and confirms identical diagnostic
benchmark source hashes. Later candidates apply the recorded source patches.
One rejected producer candidate forces the existing count/fill replay into its
caller with
`always_inline`, preserving one C algorithm; its combined replay/caller grows
from 15,087 to 24,179 bytes, and total compiler text grows about 11 KB. Its
three runs regress (larger mixed scalar median 88.125 ns/entry; 1,050.205
instructions/entry), so it is rejected. The larger replay-separation candidates
also emit out-of-line address/COPY helpers and do not recover the baseline;
`inline-decisions.txt` and the source patches retain that evidence. The minimal
type/class/leaf-inlining candidate alone is insufficient too. These observations
support investigating compiler inlining decisions; they do not make an
unmeasured improvement claim.

## Accepted shared count/fill replay

The accepted implementation writes the replay once in `ir_lower_emit.c`,
instantiates it for counting (output fixed null) and filling (the successfully
created non-null local function), and keeps constructor helpers inline. It adds
no input pass, IR column or arena storage. Both lowering paths use both
instantiations; the established allocation, verifier and rollback gates remain.
The fixed-width stack rule is checked outside the established explicit scalar
semantic-rule cases. `harness/shared-count-fill.patch` reconstructs the production
change from `4d2b538`; the diagnostic benchmark sources are copied identically
into baseline and candidate.

Three locked diagnostic processes show fewer instructions and lower elapsed
time in every ordinary shape. Each figure below is the median of three 21-pass
process medians. The final uninstrumented measurements are reported separately;
these diagnostic results are not relabeled as their observations.

| Ordinary workload | Path | Baseline ns/entry | Shared replay ns/entry | Baseline instructions/entry | Shared replay instructions/entry |
| --- | --- | ---: | ---: | ---: | ---: |
| Small mixed | scalar | 34.602 | 32.926 | 918.938 | 896.879 |
| Small mixed | vector | 31.138 | 29.739 | 770.945 | 749.467 |
| Larger mixed | scalar | 85.419 | 82.610 | 1,035.409 | 1,003.324 |
| Larger mixed | vector | 77.608 | 74.514 | 800.210 | 769.589 |
| Larger object | scalar | 66.939 | 65.016 | 901.642 | 877.724 |
| Larger object | vector | 61.201 | 59.335 | 712.369 | 689.500 |

`probe-count-{1,2,3}.log` preserves all observations. The combined lowering caller
is 16,871 bytes, versus 15,087 for caller plus replay at the initial feature
head. Total diagnostic compiler text increases by 1,981 bytes over that head
(1,917 over the checked-default candidate). These are host-compiler sizes;
they are not generated native Tier 1 dynamic-function sizes.

## Qualified production measurements before F80 integration

The following measurements use the final optimized production executable, with
no hardware-counter instrumentation, and main `5863eeda` rebuilt with the
identical final benchmark files, retained under `harness/production/`.
`qualified-identities.txt` confirms those two
harness hashes and pins both executables. Three independent processes per
revision alternate separate lock acquisitions. Each process reports 21-pass
medians with at least 2 ms per sample, seed 1, CPU 2. Brackets give the minimum
and maximum of the three process medians; they are not confidence intervals.

| Ordinary workload | Path | Baseline ns/typed entry | Final ns/typed entry |
| --- | --- | ---: | ---: |
| Small mixed | scalar | 34.611 [34.596, 34.641] | 32.552 [32.485, 32.964] |
| Small mixed | vector | 31.474 [31.238, 31.607] | 29.445 [29.393, 29.575] |
| Larger mixed | scalar | 85.241 [85.228, 85.521] | 82.504 [82.299, 82.686] |
| Larger mixed | vector | 77.438 [77.398, 77.478] | 74.255 [74.080, 74.361] |
| Larger object | scalar | 66.808 [66.478, 66.910] | 65.034 [64.790, 65.134] |
| Larger object | vector | 61.101 [60.873, 61.206] | 59.300 [58.979, 59.380] |

Every final ordinary range is below its baseline range. These are approximately
2.7–6.5% reductions in lowering time on these generated shapes; there is no
whole-compiler or source-corpus throughput claim. The first three shapes have
identical IR instruction counts, retained bytes and scratch minima at baseline
and final. `qualified-{base,head}-plain-{1,2,3}.log` retain every observation.

Separate `--only scalar` and `--only vector` processes provide the following
entry-state checks. These rows have one 21-pass process per revision/path,
so no between-process range is inferred for them.

| Ordinary workload | Isolated path | Baseline ns/entry | Final ns/entry |
| --- | --- | ---: | ---: |
| Small mixed | scalar | 34.193 | 33.276 |
| Larger mixed | scalar | 84.275 | 81.905 |
| Larger object | scalar | 65.920 | 64.961 |
| Small mixed | vector | 31.190 | 29.451 |
| Larger mixed | vector | 76.718 | 73.738 |
| Larger object | vector | 60.071 | 58.513 |

Three further alternating pairs exercise vector lowering after 200 ms of
scalar lowering in the same process (`--only vector --after-scalar 200`).
They use the same frozen executables, inputs, 21-pass samples and individual
host-lock acquisitions. All three candidate ranges remain below baseline.

| Ordinary workload | Baseline vector ns/entry | Final vector ns/entry |
| --- | ---: | ---: |
| Small mixed | 31.284 [31.146, 31.314] | 29.849 [29.554, 30.135] |
| Larger mixed | 77.673 [77.571, 77.834] | 74.173 [74.166, 74.784] |
| Larger object | 61.257 [61.222, 61.283] | 59.200 [59.088, 59.289] |

`qualified-{base,head}-conditioned-{1,2,3}.log` records each process.
Together with the plain and isolated measurements, these support preservation
of ordinary lowering throughput for the measured shapes; they do not establish
a whole-compiler or source-corpus speedup.

The integer VLA shape has 64 functions, 27,563 typed entries, 60,577 IR
instructions and 203 static stack operations. Final scalar lowering is 75.610
[75.216, 75.798] ns/typed entry; vector is 68.500 [67.969, 68.648]. The older
baseline deliberately refuses this category, so no valid baseline throughput
ratio exists for it.

| Isolated target | Scalar ns/target | Vector ns/target | Operand setup included |
| --- | ---: | ---: | --- |
| ALLOCA | 39.132 [39.044, 39.244] | 36.523 [36.395, 36.680] | Constant size 16 and discards |
| STACK_SAVE | 17.044 [17.011, 17.311] | 13.680 [13.613, 13.863] | Discards |
| STACK_RESTORE | 19.184 [19.064, 19.545] | 17.981 [17.920, 18.368] | One helper save, DUP/restore pairs |

Each isolated stream contains 512 target operations. These per-target costs
charge the entire validation/planning/classification/count/fill/verifier
pipeline and the stated setup. They are not marginal intrinsic latency, IR
interpreter runtime, or native allocation runtime. Dynamic allocation contributes
two IR instructions (alloca plus ptrtoint); save and restore contribute one each.

| Shape | Typed entries | IR instructions | Retained IR bytes, sum | Peak IR bytes/function | Minimum scratch, scalar/vector |
| --- | ---: | ---: | ---: | ---: | ---: |
| Small mixed | 136 | 255 | 7,316 | 2,947 | 2,724 / 2,724 |
| Larger mixed | 20,617 | 47,783 | 944,733 | 43,779 | 38,548 / 38,548 |
| Larger object | 29,343 | 59,740 | 1,179,729 | 40,906 | 38,940 / 38,940 |
| Integer VLA | 27,563 | 60,577 | 1,196,256 | 48,963 | 43,480 / 43,480 |
| ALLOCA isolated | 1,537 | 1,539 | 33,280 | 33,280 | 43,532 / 43,532 |
| STACK_SAVE isolated | 1,025 | 515 | 8,656 | 8,656 | 27,148 / 27,148 |
| STACK_RESTORE isolated | 1,027 | 516 | 8,656 | 8,656 | 27,212 / 27,212 |

Retained bytes include the constructor's alignment gaps. Scratch is the minimum
usable capacity determined by untimed post-sample searches, including temporary
core-verifier storage; it is not process RSS. The measured host compiler has
24,105,694 text bytes, 10,897,964 data bytes and 238,095,561 BSS bytes. The
same-harness baseline has 24,127,720 / 10,898,044 / 238,111,449 respectively;
whole-executable differences also include changed test helpers, so they are
not attributed solely to replay specialization.

## Main composition and protected integration

Integration commit `c59c70df4d1a9d09302199617303f7aebdb912ac` has parents
`618d734a805e033e904bb942be5dcea19183b88c` and main
`2a76514a025f2778f1b4994d794fb20a618fb96d`. Conflict resolution follows the
contracts published on #423/#434: retain F80 local/argument guards and its typed
lowering refusal, permit all named typed dynamic kinds, reject interpreter
classes at or above F80. No F80 or Tier0 implementation is taken over.

Fresh manual optimized/sanitized builds compile 42 sources in 40.5 / 89.6 s.
Both run the complete 21-suite list successfully: 8.0 s at 8 workers and
17.0 s at 4 workers respectively. Lowering still passes 16,439 checks, including
939 dynamic consumer checks; Tier0 now passes 120,075 checks including the
new main F80 tests. The corresponding `composed-*` receipts identify this
integration separately from the earlier feature head. The full manual call
graph agrees with CI: 42 units, 25,965 functions, 152,989 calls, zero
unapproved cycles and three allowed components.

[Protected run 40202696375](https://github.com/buster14a/buster/actions/runs/40202696375),
job `121197059222`, passes **75/75 commands** in 47.6 s, plus all selected
IR/lowering/optimizer measurements. Its synthetic merge is
`ef77c57dc8b7a8eb0e6b55b2e28caa5d0d39c3f3`, parents
`4f4a0bfa815f1bdbf2330f4e708cf8bc2e9934fa` and `c59c70df`, tree
`50b20f3784938eb30d6c79153e6e911862cea019`. The exact commit was fetched;
all `src/`, `tests/ir/` and `build.sh` match the integration head, with later
main documentation/tool changes outside those inputs. Its call graph covers
42 translation units, 25,965 functions and 152,989 calls, zero unapproved cycles
and three allowed components. `logs/ci-40202696375.log` retains the receipt.

### Final review regression head

Final head `90903dedebfcf4574cfed05c90b358ae5c37cfd0` adds the valid F80
acceptance-boundary fixture recommended by independent review, plus two comment
corrections. The positive prefix executes SAVE/CONST16/ALLOCA/DISCARD/RESTORE;
the extension supplies valid x87 metadata, fails at F80 entry 5, and checks
typed cleanup and both lowerers' exact TYPE diagnostic and transactional
preservation. Production C tokens are unchanged from `c59c70df`.

Fresh 42-source optimized/sanitized builds take 41.1 / 86.1 s. Both complete the
same 21-suite list: **21/21**, optimized 8.0 s at 8 workers and ASan/UBSan/leak
checks 16.4 s at 4 workers. Lowering now passes **16,448 checks**, including
**948 dynamic consumer/contract checks** plus 84 lifetime-helper checks. Tier0
still passes 120,075 checks. `logs/final-{head,asan}-{build,tests}.log` retains
these exact results; `source-final-SHA256SUMS` matches both final source trees.
`composed-final-identities.txt` pins all five integration/baseline/final binaries
and confirms identical benchmark-file hashes in the refreshed A/B trees.

[Final protected run 40203615082](https://github.com/buster14a/buster/actions/runs/40203615082),
job `121199818875`, passes **75/75 commands** in 46.9 s and the selected plain,
isolated and after-scalar benchmarks. Its synthetic merge is
`ec5cafb202381f3054ce6d435089b8cc4139ada5`, parents
`4f4a0bfa815f1bdbf2330f4e708cf8bc2e9934fa` and the final head, tree
`57ab85b9c10ea8c6cb8e50937cf7825a80a46997`. The exact commit was fetched;
all `src/`, `tests/ir/` and `build.sh` match the final head. Its call graph covers
42 units, **25,966 functions / 153,007 calls**, zero unapproved cycles and three
allowed components. `logs/ci-40203615082.log` retains the receipt. The source PR
remains unmerged and has no auto-merge enabled.

## Earlier production implementation protected receipt

[Run 40193938230](https://github.com/buster14a/buster/actions/runs/40193938230),
job `121170984793`, passes all 74 test commands (46.7 s, 8 workers) and the
selected plain, isolated and after-scalar IR/lowering/optimization benchmarks.
The checked-out synthetic merge is
`23defc00c1586c512fe55f0ab3191756186ccbd1`, parents
`d748ca959b3726593897fe7678169d1b2f91351c` and
`9f1d3caf76ca9dcb7bfcf4851008065669a1d545`, tree
`408e559a7c6842c76e01ccbe9cfcf91d97a90fee`. This was fetched and checked
independently of the workflow label. IR, SSA, interpreter, Tier 0, Tier 1,
`tests/ir/`, `main.c` and `build.sh` match the PR head; other frontend/assembler
changes come from main. The protected call graph checks 42 translation units,
25,711 functions and 151,037 calls, zero unapproved cycles and three allowed
components. The final source-pattern fix enables conditioned measurements for a
future change confined to `ir_lower_emit.c`. The PR remains unmerged.

`logs/ci-40193938230.log` retains the source checkout, build, test and measurement
outputs. Runner setup is omitted to exclude unrelated lock-owner context.

### Earlier qualified implementation

[Protected run 40183433993](https://github.com/buster14a/buster/actions/runs/40183433993)
passed all 74 test commands for head `4d2b538467994d76a70aaad8a3c163b0ecc55b16`.
It checked out synthetic merge `d6a3ed14a485e8e96f15e93b6f2b0e4fd0b20e04`,
parents `5863eeda331dacaa1371e1fe9ca1456e9d0039ca` and the implementation head,
tree `93b19520d851f8031543c4ba054c0b1b706aa816`. Its call graph covers 42
translation units, 25,675 functions and 150,678 calls, zero unapproved cycles
and three allowed components. The IR/lowering/interpreter/SSA/Tier 0 inputs
are identical to the implementation head; frontend changes came from main.
`logs/ci-40183433993.log` retains the receipt.

IR-level verification and interpreter execution are established for these
fixtures and streams. Native Tier 1 selection explicitly refuses all three
dynamic operations transactionally because its emitter uses a fixed rsp-relative
frame. No Tier 1 dynamic code-size/runtime result exists. Tier 0 remains
unchanged and supplies an independent native oracle. Full source-corpus/SQLite
and general Tier 1 execution acceptance remain separate.

A mixed object/COPY/VLA run at Buster `31c55f3` (seed 131) exposes an existing
representation-copy consumer gap. Function 3's `%353 = load.i64 %352 align=1`
reads the second eight-byte piece of ordinary fixed slot $9 (16 bytes), through
`%352 = address.ptr %349 offset=8`. The source object's padding is undefined.
The older COPY expansion uses value loads; the production interpreter therefore
diagnoses the padding, while the zero-initializing test executors and native
observable-field checks agree. The exact failed IR/receipts are retained.
Strict generated VLA execution keeps undefined checks on and excludes that
representation-copy and the documented FP/CVTT oracle boundary. Independent
fixed-object and floating-memory fixtures remain enabled. Neither gap is
claimed repaired by this slice.

Independent read-only agent review identified zero-size address identity across
save bookkeeping; logical-position tracking and regression tests address it.
A later review requested observable handle-phi depth; the final fixture reads
surviving outer storage on the inner-save arm. Final review at the exact head
also found the replay-only conditioned-CI trigger gap, fixed in `9f1d3ca`.
The shared count/fill replay, inline constructors, non-null fill precondition,
macro cleanup, diagnostics and rollback were reviewed again at that final head;
no actionable issue remains. The reviewer subsequently checked the exact
zero-alias test-only diff committed as `618d734a`, with no further finding.
The formal GitHub alias-contract comment is resolved with the explicit native
contract and newly passing regressions. `independent-review.txt` records scope,
findings and disposition. The reviewer performed no builds or measurements;
human/GitHub approval remains pending.

All fixture/code changes and the C build adapter are original project material.
Repository generators supply original inputs; Clang is an external oracle.
No external implementation, fixture corpus or dependency was incorporated.
Lock-owner prefixes and CI runner-setup context are omitted from published logs
to exclude unrelated sessions. Numerical build/test/measurement outputs and
their diagnostics are preserved. The original CI receipts remain available at
the linked workflow runs.

## Reproduction

Use a separate Buster checkout at the named source revision. Keep build and
sanitizer executables in separate trees. The following commands run from that
checkout on the approved host; `stack_evidence` names this evidence directory.

```sh
export EXCLUSIVE_OWNER=codex-131-reproduction
export EXCLUSIVE_TITLE='Dynamic-stack IR reproduction'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/420
stack_evidence=/path/to/buster-performance/docs/measurements/dynamic-stack-ir-131-2026-10-25
~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh
~/buster-fast-bench/exclusive.sh ./build/compiler parallel --jobs 8 "$stack_evidence/relevant-tests.txt"
~/buster-fast-bench/exclusive.sh ./build.sh check-call-graph
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-ir-lowering --seed 1 --passes 21
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-ir-lowering --seed 1 --passes 21 --only scalar
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-ir-lowering --seed 1 --passes 21 --only vector
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-ir-lowering --seed 1 --passes 21 --only vector --after-scalar 200
```

For the refreshed-main production A/B, use baseline `2a76514a` and integration
head `c59c70df`. Copy both files under `harness/production/` into
`src/buster/compiler/` in the baseline checkout and rebuild. The head already
contains those exact files. Add `--ordinary` when running the baseline.
Alternate one baseline ordinary run and one head full seven-shape run, three
times, with separate locks as shown above. The earlier pre-F80 production A/B
uses the same procedure at baseline `5863eeda` and head `d2e4bfe`.

For the diagnostic A/B, copy `harness/ir_benchmark.c` and
`harness/ir_lower_benchmark.c` into `src/buster/compiler/` at both frozen source
revisions, rebuild separately under the lock, and add `--ordinary`. This avoids
asking the older producer to lower the intentionally unsupported dynamic cases.
For dispatch, cold and specialization candidates, apply the corresponding
portable unified patch after that copy. Repeat each command in a new process
three times, alternating baseline and candidate acquisitions; never hold the
host lock across a campaign or change the host's clock policy.

For sanitizers, compile `harness/sanitizer-clang.c` under the same lock as
`bin/clang` in the sanitizer checkout. Prepend that checkout's absolute `bin/`
directory to PATH for the existing build. Execute the same test list with four
workers and the ASan/UBSan environment above. The adapter executes the installed
`/usr/bin/clang`; it does not replace the system compiler.
