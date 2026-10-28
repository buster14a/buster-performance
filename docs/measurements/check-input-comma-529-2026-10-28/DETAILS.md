# #529 residual: bounded comma-context qualification

Local source freeze: `b8ee29009260785aadc2659472daac30d44c081a`, parent
`e7f89091648f68940b595aadd648841c1ffc3ec5`. The parent accepted this bounded
slice after three six-placement SQLite cohorts: whole-process wall improves
1.16–1.31%, instructions 1.1688%, pooled RSS rises 22–56KiB. Tiny startup cost
remains unresolved within the broad A/A/copy range. No every-copy, corpus-wide
or current-main speedup is claimed. Stage1 attribution and local screens remain
separate from the final native layout controls. Current-main composition gates
are separate.

## Scope and attribution

Current main already contains #703's default postorder/batch graph evaluation,
#646's sparse reader walks, #640's traversal derivation and the merged trusted
graph facts. This prototype changes only the reverse expression-comma context
pass. General literal preparation and broader graph construction remain residual
work; compact integer tables (#658), parser retention (#628) and post-check
metadata (#641) are separately owned changes and are not counted again.

The original reverse-postorder loop is retained byte-for-byte as the scalar
oracle. The native path classifies 64 contiguous roles, then visits separators
and terminators sparsely. Reverse source order resolves later parents before
their children; an earlier non-separator parent has a directly computable
context. An earlier separator parent triggers full replay of the original
dependency-order pass. There is no new retained column, allocation, recursion
or unbounded parent walk. Masked tails touch only logical elements.

The loop bound remains `parser->tokens.count`, the exact original constant.
Prefix views own `end` tokens and a complete postorder permutation of those
tokens; repair views own `total` tokens, including synthetic closers. Their
`original_end` bounds publication, not this preparation pass. Permanent tests
compare every byte of the actual READY views, including synthetic closers, and
verify their traversal permutations. Synthetic nonidentity/shuffled dependency
orders and backward separator chains exercise the fallback.

`BUSTER_SCALAR_PATH` forces the original pass on a generic host. Both a real
41-unit generic compiler and a generic sanitized adapter build and execute.
`generic-production-dispatch.txt` disassembles the actual generic compiler's
production wrapper: it contains the original scalar loop and no SIMD kernel
call. Direct vector oracle tests use the current scalar intrinsic emulation.

## Build and correctness receipts

All local builds use Clang 23.1.4, `BUSTER_DEBUG_INFO=0`. Multicore runs use
`cores -n 2`; long single-thread tests/benchmarks use `cores -n 1`. The generic
and native outputs have separate work directories. No system settings changed.

| Frozen b8ee build | SHA256 |
| --- | --- |
| Native | `68eeda17b3eb9ccc75e93984e629a53bef0f750e6e0809ce778415ffafbede14` |
| Generic `BUSTER_HOST_ARCH=x86-64` | `7c59f7d2de2814b378138d8f24f6d4b47181618d69b62c295c5d4cf1ce1040ad` |
| Pure e7 local baseline | `523ceb8df0435c089e10ba78dbc8e08be8062d7a2f10d96f4c3bbd734006865a` |

| Check | Result | Receipt |
| --- | --- | --- |
| Native final 41-unit build | passed | `build-b8ee-native.log` |
| Generic final 41-unit build | passed | `build-b8ee-generic.log` |
| Native full checker | 498,775 checks / 0 failures | `checker-b8ee-native.log` |
| Generic full checker | 501,558 / 0 | `checker-b8ee-generic.log` |
| Native deferred reader | 80 fixtures, 1,423 checks / 0 | `deferred-b8ee-native.log` |
| Generic deferred reader | 80 fixtures, 1,423 checks / 0 | `deferred-b8ee-generic.log` |
| Guarded comma + actual prefix/repair ASan/UBSan, native | 5,891 / 0 | `comma-oracles-view-native.log` |
| Same generic x86-64 | 5,891 / 0 | `comma-oracles-view-generic.log` |
| Driver (initial production-identical build) | 21,660 / 0 | `driver.log` |
| Pinned c-testsuite | 220 / 220 passed | `c-testsuite-b8ee-native.log` |
| Native original body/runtime control | 6 / 6 object+stdout+stderr pairs identical; 12 / 12 runtime outputs equal Clang | `byte-controls-native.log` |
| Generic original body/runtime control | same | `byte-controls-generic.log` |

The c-testsuite read-only checkout is pinned to
`5c7275656d751de0e68b2d340a95b5681858ed07`. The body controls cover grouping,
call-argument separators, for comma expressions, ternary branches, unevaluated
`sizeof` commas, and subscript commas. Both default and requested scalar modes
are compared against the unchanged baseline at identical source paths. The
source generator and all receipt helpers are original C.

Independent peer review by triage_recent found no concrete source correctness
or maintenance blocker at b8ee. That review did not perform performance or
memory acceptance. The source no-recursion check passes 41 units / 25,595
functions / 152,182 calls, 0 bad cycles and 0 split variables
(`callgraph-b8ee-native.log`).

`comma-pages.log` observes the actual production `check_input_compile` reader
after parsing with `tree_only=true`, with its derived postorder rather than a
retained parser traversal. SQLite's 716,157 entries form a complete unique
permutation and both passes write exactly the same 176 output pages. Tiny
10-token and comma-heavy 115,775-token inputs similarly write 1 and 29 pages.
All context bytes match. These are logical write-page sets derived from the
real output address, actual postorder and actual masked-store ranges, not a
measurement of anonymous RSS or an explanation of process-memory differences.

## Local attribution and controls

The pinned SQLite file is 9,507,037 bytes, SHA256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`,
716,157 preprocessed tokens under the flags in `run-local-screen.sh`.
The corpus is the frozen local `2026-10-27/exp/work/corpus` copy; no corpus was
vendored into the compiler repository. Both roles receive identical absolute
input paths. The local cohort helper respects the inherited cores affinity;
it cannot escape to the target campaign's hardcoded CPU2.

Baseline `perf` attribution (`base-reader-perf-report.txt`) has 208K samples,
zero lost, for `benchmark-checker-bindings --only direct --passes 11`.
The enclosing `check_input_run` accounts for 10.09% of samples, while expression
and resolver walks account for 19.54% and 11.01%. General literal preparation
is present (`check_input_literal` 1.83%, `check_literal_integer` 0.70%) but is
outside this slice. These are local sampled shares, not a source speedup claim.

`comma-probe-sqlite-context.log` measures just the preparation kernel after
preprocessing, parsing and allocations, with explicit lane-count-one TLS and
1,000 alternating pairs. Every output byte matches. There are 44,483 separators,
57,646 terminators and no backward separator-parent dependencies. Original
scalar mean is 2.434 ms; vector mean is 0.303 ms. This roughly 2.13 ms saving is
kernel attribution only, not a whole-reader or whole-compiler result.

The first compiler prototype (SHA256
`cc5c07ffbf453f2a22a5821f7e2307633e5b1069f817ee58a614f87289400dce`)
already has the final production algorithm, but precedes the additional
actual-view test calls and documentation. Its local SQLite and reader screen
results are retained as such; they are not exact-final-b8ee timings.

| Local screen | Samples, after declared warm-up | Result / limit |
| --- | --- | --- |
| SQLite full fresh `-c`, first prototype | 11 rotated pairs, 2 sequential processes / role / pair | median paired throughput +5.36%, CPU cost -4.23%; base/head wall ranges 203.6–341.0 / 193.3–418.6 ms per task. Too noisy for a throughput claim. |
| SQLite baseline against itself | same | median paired throughput -1.21%, CPU cost +1.17%; broad wall range remains. |
| Whole direct reader, first prototype | 4 measured fresh-process pairs, 11 internal passes; pair0 is warm-up | median reader 72.048 / 67.714 ms; paired time ratio 0.9438. Pairwise ratios span 0.8195–0.9968; no stable enclosing-stage claim. |
| Tiny fresh `-c`, final b8ee | 11 rotated pairs, 20 processes / role / pair | noisy startup screen; 1 base and 4 head measured major faults. No startup gain claim. |
| Function-body commas, final b8ee | 11 rotated pairs, 2 processes / role / pair | median paired throughput +0.91%, CPU cost -0.89%; this is a small local signal. |

All 24 SQLite object/diagnostic pairs, 240 tiny pairs and 24 body-control pairs
are byte-identical, including the declared warm-ups. All compiler subprocesses
exit 0. The direct reader reports identical retained bytes (241,904,072), output
written bytes (63,021,928), scratch written bytes (61,550,580), resolver visits
(263,298) and expression visits (515,457) in all pairs. The reader warm-up has
one head major fault; all four measured reader pairs have no major faults.

Memory is not waived: observed peak RSS rises about 1.06 MiB for SQLite,
0.55 MiB for the reader benchmark, 2.05 MiB for the tiny control and 1.87 MiB
for the function-body control. Retained-byte metrics and allocation structure
are unchanged; the cause of the process-RSS difference is not established.
The final native executable has 5,664 more text bytes and 592 more BSS bytes
than pure e7. This makes matched build/placement/copy and memory controls part
of required target qualification rather than grounds to dismiss the cost.

Raw fresh-process JSON/rusage, per-child TSVs, stderr and objects are retained
in the corresponding `*-local/` directories. Summaries are generated by the
original `summarize.c` and `summarize-reader.c`, with warm-up rows retained and
explicitly excluded from measured summaries.

## Retained failed preliminary harness attempts

These are not qualifying receipts: the first standalone probe lacked the
diagnostic counter; the next lacked the frontend TLS definition; one pre-build
launch exited 127; the first linked probe left the unused parser-path TLS lane
count zero. The explicit-context probe above replaces those results. The first
reader screen tried an absent `/usr/bin/time` and exited 127 before executing
the compiler (`reader-ab-local/r0-role0.err`). It was replaced with the original
bounded `wait4` receipt helper in `reader-ab-local-valid/`. Logs remain intact.

## Stage1 native screen

The parent approved one official Clang23.1.4/native/debug1 build and the
bounded initial screen. Target image:
`3f162da86b82260fe26c443932cbcb0f9ea5d308641fef9eae01639edb044ec7`.
Shared pure e7 baseline:
`06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e`.
All 689 source-file SHA256 entries match before/after the 30.1s build; the
baseline hash remains unchanged. Build bound was 180s. An external copy of
`build.sh` adds only three statements after the ordinary link to retain its
temporary objects before ordinary cleanup. All 41 `.o`/`.json` files, original
script, diff and actual traced compile/link commands are retained. Every unit
uses `-g -march=native` and the ordinary source/link order. Target source and
artifacts are in `issue-529-b8ee-clang2314` under the parent campaign root.

Candidate native checker passes 498,771 checks / 0 failures; driver21,660/0;
deferred80 fixtures / 1,423 checks / 0. Target byte/runtime gate passes 7/7
base/head object/stdout/stderr pairs (including SQLite and default/scalar
generated controls), and all 12 generated runtimes equal Clang. Each test and
build takes its own shared target lock; no settings changed.

Whole-process screens use CPU2 and the existing `time-runs` implementation:
11 measured runs after one declared warm-up, two fresh executable copies,
three rotating roles (base, head, base-again). Its successful warm-up resource
values are not printed; every measured row is retained, with no fault-based
exclusion. All 198 measured executions return0 with fully scheduled user-cycle
and instruction counters. The independent summary validates exactly 66 rows
per workload, all role/copy/run slots unique, all statuses0, positive counters
and the runner's zero-failure completion. Medians in the following table use
the average of the two middle values across each role's 22 measured processes.

| Native one-placement screen | Base → head | A/A change | Head/base memory |
| --- | --- | --- | --- |
| SQLite whole wall | 124.548 → 123.138ms, -1.13% | +0.09% | 377,064 → 377,208KiB, +144KiB |
| SQLite user cycles | 581.631 → 574.452M, -1.23% | +0.30% | as above |
| SQLite instructions | 1,228.758 → 1,214.398M, -1.169% | effectively0 | as above |
| Tiny whole wall | 1.303 → 1.310ms, +0.50% | -0.04% | 22,032 → 21,882KiB |
| Tiny user cycles | 3.898 → 3.949M, +1.32% | +0.74% | as above |
| Comma-heavy whole wall | 17.588 → 17.482ms, -0.60% | -0.33% | 108,188 → 108,176KiB |
| Comma-heavy instructions | 212.308 → 210.007M, -1.084% | effectively0 | as above |

Tiny timing is unresolved within copy/A/A spreads; its extra 35 instructions
are retained. Comma-heavy wall time is a modest signal beside its control.
The whole SQLite wall/cycle signal exceeds this screen's A/A/copy floor, with
a small retained RSS cost. All measured whole-process rows have zero majors.
See `target/whole-{sql,tiny,comma}.log` and `*-summary.txt` for all distributions.

The direct reader uses five rotating base/head/base-again triples, first
triple declared warm-up, 11 internal passes per process, fresh equal-length
copy paths on tmpfs. The original `time-command-counters.c` helper captures
exact-child wait4 usage and user cycles/instructions enabled on exec; both
local and target exit0/exit1 controls pass. All 15 real reader processes return0
with `counted=1`; all four measured triples have zero majors. Reader medians:
49.634 → 47.964ms; median paired time ratio0.966525 (-3.35%), A/A ratio1.000141
(+0.014%). Head improves in all four measured triples. Retained/written-byte
metrics and visit counts match; median process RSS1,063,856 → 1,063,842KiB.
Reader-process counters include preprocessing/parsing, reference checks and
repeated passes; they are not isolated reader counters. Raw internal stage
clocks and outer receipts are retained in `target/receipts/reader/`.

## Stage2: final bounded layout controls

One object-capture rebuild from the same baseline source directory reproduced
the immutable `06132c96…` ELF byte-for-byte. Ordinary frontend `.text` padding
was rejected before timing: it did not move the reader's separate hot section.
Both rejected sets remain retained. The actual owner is checker object8, in
`.text.buster_checker` (4KiB alignment). One assembly capture per role and the
other 40 original objects provide relink controls without twelve full builds.

The first zero relinks exposed one cold-test x87 alias encoding difference
(`DC C0` versus `D8 C0`) from direct object generation versus assembly parsing.
The uncorrected artifacts and failed-closed build-ID/byte audits are retained.
One count-checked assembly-line replacement restores the original `DC C0` bytes
inside `check_test_action_constraints`. The corrected zero controls match all
26 allocated section layouts/bytes, ELF and program headers, and defined
symbols/addresses/sizes. Only named nonallocated `.debug_info`/`.debug_line`
content and resulting nonallocated file offsets differ. No production source
is patched by this control method.

Nonexecuted section-start padding shifts both `check_input_run` and
`check_input_expressions` by exactly 0, 704, 1408, 2112, 2752 or 3456 bytes in
both roles. All 24 address checks pass. All 84 independent placement object,
stdout and stderr comparisons match the original baseline; all 72 generated
runtimes match Clang. These byte/runtime gates precede the timing runs.

Each cohort uses the unchanged baseline `time-runs`, CPU2, three roles
(base/head/base-again), six actual placements, three fresh regular executable
copies per placement, three measured runs and one declared warm-up. Each has
162 measured processes and 54 warm-ups. The three SQL cohorts plus one tiny
cohort therefore retain **648 measured processes and 216 warm-ups**. No rows
were dropped. All measured statuses are zero, user cycles/instructions are
fully scheduled, and major faults are zero. Successful warm-up resource values
are not printed by the runner. The independent C validator checks every unique
role/placement/copy/run slot and uses the average of two middle values for a
54-sample pooled median; the runner's upper-middle convention can round slightly
differently.

| Cohort | Wall base → head, ms | Wall change | A/A wall | Cycles change | RSS base → head, KiB |
| --- | --- | --- | --- | --- | --- |
| SQLite 1 | 124.7185 → 123.0955 | -1.3013% | -0.1459% | -1.4639% | 377150 → 377206 |
| SQLite 2 | 124.4115 → 122.7755 | -1.3150% | -0.1435% | -1.5026% | 377180 → 377202 |
| SQLite 3 | 124.0540 → 122.6095 | -1.1644% | +0.0641% | -1.4512% | 377148 → 377204 |
| Tiny 1 | 1.3700 → 1.3710 | +0.0730% | -0.2555% | +1.2823% | 22052 → 21906 |

SQLite instructions fall 1.1688% in each cohort; CPU falls 1.17–1.30%. Every
placement-pooled SQLite wall median improves, but individual copy tails remain:
first-cohort wall ranges -2.51% to +0.93%, cycles -2.89% to +0.11%, beside A/A
wall -0.92% to +2.08% and cycles -1.38% to +1.68%. There is no every-copy claim.
Pooled RSS rises only 22–56KiB in these final controls, with overlapping ranges;
the larger local debug0 RSS costs remain retained above rather than attributed
away. Actual old/new production context writes touch the same page sets.

Tiny is unresolved: its A/A cycles are +0.823%, and copy cycle changes span
-1.32% to +3.21% beside A/A -1.59% to +2.66%. Placement wall ranges are broader
still (head/base -8.85% to +12.10%; A/A -9.26% to +10.69%). Its negligible
instruction difference changes sign from Stage1. No narrow equivalence,
neutrality, fixed-overhead or startup improvement is claimed.

All four final timing output objects and three Stage1 final output objects
equal the independently gated originals at closure. The output path is reused,
so this does not individually audit every timed output; the 84 variant byte
gates and all timing exit statuses are distinct evidence. Full source, frozen
headers, immutable original images and every variant hash pass closure checks.
No further reader/comma/corpus expansion or eight-worker claim was made.
