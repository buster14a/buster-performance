# #451 page-line fusion: rejected experiment

**Do not integrate this prototype or count #451 as solved.** It saves about
46 µs in the directive interval, adds about 27 µs to lexing, and leaves complete
preparation neutral on the pinned SQLite workload. Whole-process differences
are within the identical-code controls; real compilation also adds about
2.1 MiB peak RSS. The added producer variants, scratch and interface complexity
are not justified by these results. The coordinator retains the follow-up open
and handles its scoped handoff. No PR, push or GitHub comment was made here.

The scope is only the page-line fusion follow-up in issue comment
`6452207581`, claimed by the coordinator in comment `6469199014`. The original
parts remain credited to their merged PRs #462 and #486.

## Frozen implementation

- Baseline: `4165454ebadf9b96c2b40ab99c55f4c0b28ba975`.
- Prototype: `d6b3f5c37217cad5cb5c5ab3ef3aaa14f32c4f5d`.
- Preserved final branch: `codex/perf-451`,
  `68e113ee445af2a80296412a2b8791d3bf9098a6`. Its extra guard delegates to
  #678's scalar-host lexer and publishes unknown facts there. The two native
  builds are **byte-identical**.
- Native baseline SHA-256:
  `46bec1e120ca54b1ae99502136988cea0890e96f4af8eb704cdcd2b6cef748ed`.
- Native prototype/final SHA-256:
  `580126a2bf8b88815987d18799c3ddbaa9c94610c1d0bd18efa70bed5549faad`.

`experiment-68e113ee.patch` preserves the complete proposed change against
the baseline. Both local commits carry the repository's opted-in sign-off.
The compiler worktree is clean. Exact source archives are retained locally;
the review package needs only the patch and source identities.

The counted C loops, including GNU raw-string mode, retain physical newline
facts before token analysis removes comments, strings or splices. A counted
property table distinguishes CR using overlapping property bits, avoiding an
extra raw comparison per 64 bytes. A complete block without CR publishes one
count byte, 0–64. CR, shared/tail, skipped/scalar, unsupported-mode and unaligned
blocks remain unknown. `pp_count_page_lines_facts` reduces up to a page of
these bytes with SIMD and uses the unchanged block counter for unknowns.
Reclassification overwrites facts, so discarded window tails and scalar
restarts do not accumulate them. `pp_count_page_lines` remains the independent
oracle and allocation fallback. Scratch capacity is one byte per 64 file
bytes, about 149 KB for SQLite.

## Correctness

All final native commands succeed:

- `test-preprocessor`: 0/1,368 direct lexer/block/page checks fail;
  0/240 generated sources differ across 1,798 windowed preparations;
  0/119,625 window-cut and 0/976 directive-place checks fail;
  0/24 unit sources differ across 93 windowed units and 127,851 `__LINE__`
  outputs. Existing directive, fuzz, argument and allocation checks are clean.
- `test-lexer`: all reported cases agree, including its scalar fallbacks.
- `test-refinement src`: 506 files / 25,895,805 bytes; spelling, random and
  guarded-page checks agree.
- `test-files`: passes, including records, line pages, every tested lane count
  and allocation failures.
- Native preflight preprocessing output is byte-identical:
  `a984f9ca66a1bb2f97f0de70803ea794148fe9cc1dafb615f7b814005342c35d`.
- Native real objects are byte-identical:
  `cb578161715c2ecf83659069957077739447d8eccb7be54953faeb30990d9755`.

Direct fact tests cover empty/tiny inputs, 64/512-byte and page boundaries,
all-LF blocks (64 line ends), CRLF, comments, literals, splices, mode changes,
unaligned input, range partitions inside shared blocks, and independently
guarded source/fact tails. Generated window inputs are explicitly aligned to
exercise the fused path. Raw logs are retained. Scalar-host compatibility
beyond the guarded delegation was not runtime-qualified in this private
experiment; the prototype is rejected independently of that pending gate.

## Native method and results

Ryzen 7 9700X, Clang 23.1.1, release `BUSTER_DEBUG_INFO=0`, normal repository
O3/native flags. All builds, tests, timed processes and target packaging use
the existing shared `exclusive.sh`; timing is pinned to CPU 2, and the
file-lane correctness check uses CPUs 0–7. Machine settings are unchanged.
The shared pure-416 baseline is reused rather than rebuilt for each probe.

The frozen input has SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`;
pinned GNU17 predefines have SHA-256
`a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.
`REPRODUCE.md` records commands, flags and helper builds.

`lexer_facts_bench.c` measures the plain/counting/plain-again producers in one
executable, eight calls per sample and 24 samples per role. Count output
allocation precedes timing, while initialization and production are included.
Role order uses six permutations. Steady-state counted lexer time changes by
+0.2473%; plain-again differs by -0.4830%. After 100 ms of scalar conditioning,
counted changes by +0.0372% and plain-again by -0.5664%. These are fixed-layout
cost screens; the same-source role gap exceeds the counted-loop difference.

Seven alternating process pairs run `benchmark-preprocessor --only vectorized`
with its own warmup and 21 passes. Paired executable paths have equal lengths.
An independent seven-pair A/A series uses two baseline copies. Medians of the
seven process medians, in milliseconds:

| Interval | Baseline | Prototype | A/B time change | A/A time change |
| --- | ---: | ---: | ---: | ---: |
| Preprocessing total | 10.000 | 10.000 | 0.0000% | +0.2999% |
| Lex | 2.314 | 2.341 | +1.1668% | -0.2587% |
| Refine | 1.363 | 1.371 | +0.5869% | -0.0733% |
| Directive tables, including page lines | 0.309 | 0.263 | -14.8867% | -0.3226% |
| Main loop/setup | 5.276 | 5.298 | +0.4170% | +0.4357% |
| Release, separately timed | 0.403 | 0.402 | -0.2481% | -0.4963% |

Independent phase medians need not sum. The preprocessing total includes the
producer, handoff, consumer and their effect on other preparation work.

Whole processes use three rounds, a fresh equal-length executable copy per
role in each round, two warmups and 21 timed processes per role per round.
Each homogeneous input/configuration uses two-role A/B then B/A order; no
mixed tiny/large workload or multi-role global-rotation matrix is used.
The built-in `ab` acquires the lock per `time-runs` run. Medians of the three
round medians:

| Whole process | Baseline → prototype | A/B time change | A/A time change | Peak RSS KiB, baseline → prototype |
| --- | ---: | ---: | ---: | ---: |
| `-E -o /dev/null` | 18.183 → 18.147 ms | -0.1980% | -0.1100% | 57,828 → 57,588 |
| `--lanes 1 -c`, real object | 129.320 → 129.498 ms | +0.1376% | -0.1474% | 393,248 → 395,436 |

All **504** valid timed whole processes exit zero; every major-fault count is
zero. Raw minor faults, RSS, times and outliers remain retained. No layout
independence or broad throughput improvement is claimed; the neutral result
does not justify a larger placement campaign for this prototype. The report
uses wall time/rusage; raw PMU fields are not used for an attribution claim.

## Preserved corrections and negative refinements

- The first local preparation probe accidentally left GNU raw-string mode on
  the unknown-facts fallback. That probe cannot assess fusion; its logs remain
  retained. The final prototype adds actual counted raw-mode loops.
- A local candidate benchmark waited until a concurrent rebuild had removed
  its compiler executable and failed to start. Its failed receipt and explicit
  retry are retained; it is not a performance sample.
- Initial whole-process logs named `target-whole-preprocess-*` put `--lanes`
  before `-E`, selecting the ordinary driver instead of preprocessing. They
  are retained as misrouted probes and excluded from the `-E` result. Correct
  preprocessing logs are `target-whole-E-*`, with `-E` first.
- `proved-alias.patch` tried the documented disjoint fact output as `restrict`.
  Normalized counted-loop assembly is identical before/after, SHA-256
  `289e2aec717ab5ca5c8337798488b234c22bfe172a7364453fbd037568ec2e81`.
  Its local screen and assembly remain retained; the change was reverted.
- Original C readers check complete seven-pair phase and three-round whole
  records, finite metrics, consistent token counts and 126 successful process
  rows per whole series. Truncated-log negative controls are rejected.
- The first locked provenance command found no `rg` on the target and stopped;
  its receipt remains retained. The successful retry uses `grep -E` and is
  also under the shared lock.

Native assembly, identities and original helper source are preserved in the
95,934-byte locked archive `451-qa-provenance.tar.gz`, SHA-256
`e8f91f760ed1a0e86f1c42dbcc2385910e6473801158174d43c0dfe2ce51fe64`.
The local transferred SHA matches. No corpus symlink or generated objects are
included. The accepted performance batch must omit this experiment.
