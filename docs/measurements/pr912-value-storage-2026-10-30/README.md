# PR #912: floating payload qualification on Ryzen 7 9700X

The intended payload-construction change is visible in both the optimized
assembly and sampled execution. The observed whole-compile improvement is small
and placement-sensitive. This evidence compares the exact PR source with its
direct parent; it is not a corpus-wide throughput result or a merge decision.

| Source | Commit |
| --- | --- |
| Baseline | `e693d878309ed3c3be05f2f550574d59217deceb` |
| PR #912 | `ce7cb0948097b86b8839f8d9f8de315355aeb6f6` |

All builds and target executions ran on the shared AMD Ryzen 7 9700X through
its existing `exclusive.sh` lock, released between bounded logical runs.
Measurements were pinned to CPU 2. Clang is the official 23.1.4 release; host
ISA is `znver5`, optimization `-O3`, debug information disabled, and the
unchanged build retains `-fwrapv -funsigned-char -fno-strict-aliasing -Wall
-Werror`. Exact tool identities, expanded flags, source-archive identities and corpus
manifest identities accompany the logs and [provenance](PROVENANCE.md).

## Whole driver

The unchanged C `time-runs` tool interleaves both builds, three proved hot-code
placements (0, 64 and 512 bytes) and two fresh executable copies per placement.
Each of three independent processes uses two warm-up rounds and eleven measured
rounds. Both object compilation and syntax checking use the frozen SQLite input
and exact options in `scripts/environment.sh`. Every one of the 792 measured
invocations returned zero; the timing gate checks the complete unique slot grid.

| Independent process | `-c` baseline, ms | `-c` PR, ms | Change | `-fsyntax-only` change |
| --- | ---: | ---: | ---: | ---: |
| 1 | 129.698 | 129.433 | -0.20% | -0.04% |
| 2 | 129.573 | 129.287 | -0.22% | -0.19% |
| 3 | 129.853 | 129.654 | -0.15% | -0.21% |

These are medians over all placement/copy observations within each process.
All-pair placement/copy comparisons range from -0.99% to +0.34% for `-c`
wall time across the three processes. User-cycle medians change by -0.31%,
-0.15% and -0.16%; their placement/copy comparisons range from -0.95% to
+0.38%. Individual positive comparisons are retained. The small median change
does not resolve a placement-independent throughput benefit or prove an exact
zero slowdown bound. See `results/time-{1,2,3}.log` for every observation,
per-placement/per-copy medians and ranges.

Separate eleven-run `measure-compile` attribution processes pass their object
and complete-report checks. Their `check-input` stage medians are 57.426 and
56.904 ms; expression-checking medians are 11.724 and 11.807 ms. These probes use
the normal baseline/candidate paths, with unequal `argv[0]` lengths, and are
attribution observations rather than placement-controlled timing acceptance.

## Assembly and IBS

Optimized full function bodies contain 23 x87 instruction sites in baseline
`check_input_expressions` plus `check_literal_value`, and zero in the candidate.
The bodies, including all their branches, are retained in the two assembly
files. Other genuine floating arithmetic in the compiler remains outside this
specific payload-construction claim.

Each normal binary compiled SQLite thirty times under one user-task IBS op
recording, `ibs_op/cnt_ctl=1,period=100003/`, on CPU 2. Both raw decodes contain
zero lost records. Sampled instruction addresses are matched to the retained
disassembly, classifying the `f*` instruction mnemonics in those two functions.

| Profile | All samples | Target-function samples | Target x87 samples |
| --- | ---: | ---: | ---: |
| Baseline | 255,976 | 29,336 | 1,238 |
| Candidate | 255,530 | 28,392 | 0 |

The profile contains positive candidate coverage of the target functions, and
the static assembly independently confirms that those functions have no x87
instruction sites. Counts, retained target samples, decoder stderr, loss gates
and compressed raw profiles accompany the result. The baseline x87 samples
are approximately 0.48% of all sampled ops, 4.22% of target-function samples.

## Counter protocol

`results/counter-summary.txt` records the complete eleven-round, two-build,
three-mode grid. Each invocation groups user-mode instructions, cycles,
`ex_ret_ucode_ops` and `ex_ret_ucode_instr`. The C validator requires all 66
files, all four unique numeric events, matching positive event runtime, and
100.00% scheduling at perf CSV precision before reporting a comparison.

The derived ratio is the charged `-fsyntax-only` minus `-E` proxy used by #879:

```
1000 * (ucode_ops_syntax - ucode_ops_E)
     / (instructions_syntax - instructions_E)
```

It is computed per paired round before taking the median. It subtracts `-E`'s
token printing/output work as well as preprocessing, so it is not a directly
isolated checker counter span. The summary's `check-phase` labels denote only
this proxy. Raw modes are also reported independently. Counter and IBS probes
use normal paths and serve attribution, while the equalized-copy measurements
above supply whole-driver timing evidence.

The median proxy falls from **8.911232 to 1.470412 microcoded ops per 1,000
instructions, an 83.50% reduction**. The un-subtracted syntax-only mode has
median `ex_ret_ucode_ops` counts 6,796,751 and 1,479,287; preprocessing has
445,190 and 433,141. The normalized result is a median of per-round ratios,
not a ratio formed from these independently summarized medians. All 66 files
pass the scheduling/event/grid gate.

## Correctness and placement gates

The [normal PR CI run](https://github.com/buster14a/buster/actions/runs/41046864498)
associated with the candidate head passed both hosted O3 correctness jobs,
complete native-vector correctness on the 9700X and the final qualification
gate. Measurement storage passed; plain-PR libFuzzer was skipped as expected.
This is ordinary CI evidence, not a new sanitizer/fuzz acceptance claim.

The additional qualification preflight passes frozen SQLite object-byte and
accepted/rejected diagnostic equality across both builds, both scalar/vector
paths and all normal/zero/+64/+512 variants: sixteen combinations. The rejected
input is a small original diagnostic control, not an external corpus. The
object and diagnostic SHA-256 values are in `results/preflight.log`.

Both zero-padding controls are byte-identical to their normal executables.
Only the actual owner, `main_unit_checker.c.o`, receives nonzero padding in
`.text.buster_checker`; every other translation-unit object is byte-identical.
The structural proof checks section bytes, symbols, relocation sites/targets
and other sections. The linked proof checks every owned function's actual
translation, unchanged nonrelocation bytes and actual local PLT32 signed-32-bit
S+A-P resolution. Required symbols include both payload functions and their
program/lowering callers. All four nonzero controls pass before timing.

Ordinary `build.sh shifts` controls were found to move `main` but leave the hot
checker addresses unchanged, and were excluded. Earlier unconditional padding
controls were also excluded. The initial old proof's PLT32 refusal is retained;
the reviewed shared proof extension handles the actual local relocation form.
Wrong-shift object and linked controls must fail. Timing acceptance controls
reject a missing slot or a nonzero compile status; counter controls reject a
reported 99.00% scheduling fraction.

## Reproduction and remaining review

Prepare fresh directories from the two pinned Git archives, preserve the corpus
manifests, and adjust only task-local paths in `scripts/environment.sh` as
needed. `build.sh`, `placement-build.sh`, `proofs.sh`, `preflight.sh`, each
`stages.sh`, and each `ibs.sh` invocation use the ordinary shared host lock with
owner/title/PR metadata. `assembly.sh` extracts all matching function bodies.
After the proofs and parity gate pass, `collect.sh` queues only one request at a
time and releases the lock between each timing/profile-analysis/counter run.
The new counter summary builds with the supported compiler. It is correctness
glue for the captured data, not a measured compiler change.

The source PR remains draft. The original bot-authored implementation is
unsigned and still needs authentic maintainer certification. This record
does not add that certification, mark the PR ready or merge it. The small
placement-sensitive timing observation should remain distinct from the clear
elimination of payload-construction x87 work.
