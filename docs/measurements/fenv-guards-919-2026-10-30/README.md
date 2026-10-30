# FENV_ACCESS call-guard qualification, Buster #919

This record qualifies only the two FENV_ACCESS call-site guards in
[buster#919](https://github.com/buster14a/buster/pull/919). The stack-protector
policy discussed in [#916](https://github.com/buster14a/buster/issues/916) is
unchanged and remains a separate decision.

## Frozen comparison

| Role | Buster source | Ordinary executable SHA-256 |
|---|---|---|
| Baseline | `aca7ee0e1581d93d052482a045e8efd5381eebc9` | `1b00eebec4ad080e601d257a56ba5c12b4b1a2957a7d3ebf965253057562818a` |
| Candidate | `68cbb0abf1f801d5c6ee52134270af61c54a4372` | `baefd653b210689927b757655fc962768a09f07ae23e193aaed9cfcb8576da52` |

The candidate additively integrates original head
`ba1d45eed94913dc12b0782a2c7cddc495805a2f` with the pinned baseline. Its owned
diff remains three files, 62 additions and two deletions; all other baseline
entries are unchanged. Later main composition is a separate static check and
does not change the measured source pins.

Both primary builds use the unmodified official LLVM 23.1.4 release, commit
`7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`, compiler SHA-256
`c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67`.
The exact commands retain `-O3 -march=znver5`, no debug information, the normal
integer/aliasing flags, the release driver's `x86_64-unknown-linux-gnu`
default target, and the same local Wild 0.11.0 linker. No stack-protection flag
is added or removed. Compile commands, flags, source identities and actual
tool hashes are retained under `source/` and `placements/`.

## What the production assembly establishes

The official baseline already tests ACCESS and returns before any callee
frame setup. Both primary executables contain zero `__stack_chk_fail` calls
and zero `fs:0x28` references. Therefore the primary mechanism is skipped
calls and caller setup, **not** frame/canary removal.

Object-qualified disassembly in `disassembly/` shows the original unconditional
calls in both production callers. In the candidate, the test/branch in
`check_action_compute` jumps past its call, and the corresponding test/branch
in `check_graph_scalar_node` jumps past its builtin-path call. ACCESS-on still
enters the unchanged environment classifier and diagnostic guard. The guard
does not clear inherited result flags.

The installed host-default Clang 23.1.4 is a distinct compiler, SHA
`b5389000…`, with stack protection enabled by default. Its separate baseline
build has 3,498 `__stack_chk_fail` calls and 8,246 `fs:0x28` references. These
are whole-executable instruction-reference counts, not protected-function
counts. That supplemental cohort is never a primary timing input; its effects
are not attributed to the official CI defaults.

## Placement and execution protocol

Primary whole-process measurements use checker hot-section shifts 0, 64 and
256 bytes, with two freshly created executable copies per build in each run.
The three process invocations rotate the placement order; process 2 reverses
the build order. First-party `time-runs` rotates measured slots internally.
Each process/placement contains 21 measured runs after two warm-ups for each
build, copy and input: SQLite, the small ACCESS-off control and its otherwise
identical ACCESS-on control. This is 2,268 measured processes in 9 files.

Each actual checker contribution is translated inside `.text.buster_checker`;
ordinary `.text` padding is not substituted for a real hot-code movement.
Proofs check every hot symbol and instruction, relocations, unwind records,
and final linked addresses. Entire zero checker objects and complete zero
images equal their ordinary production counterparts byte for byte.
`placements/` also retains the additional shared-baseline offsets used by the
independent #920 campaign; #919's primary timing grid uses only 0/64/256.

The baseline assembly was produced ordinarily on the build machine. A bounded
remote code-generation route from locally preprocessed input reproduced that
entire baseline assembly byte for byte. The candidate's independently checked
zero object/image gates also pass. Preprocessed files containing system
headers remain private; public commands, hashes and original adapters describe
reproduction. One scoped x87 assembly-printing ambiguity is normalized by the
retained original C tool; whole-object equality is mandatory afterward.
All accepted links use the unchanged production linker arguments. Explicit
linker thread-option experiments failed the full-image gate and were rejected.

Every hardware run takes the shared Benchpress lock separately and pins the
measured compiler to CPU 2. At most one request is pending for this campaign.
The caller uses a minimal explicit environment and the official toolchain
path. Runtime/tool and complete corpus/header ledgers are checked before and
after the campaign. Producer output, lock diagnostics and execution/hash
sidecars are separate files.

The independent first-party `measure-compile` grid runs both roles across the
same three placements and three process invocations. Each of its 18 files has
21 samples per default/staged/reference role. Its default/staged object checks
are distinct from the separate baseline/candidate/scalar/vector object checks.
Stage clocks are diagnostic elapsed times with their own overhead; they are
not exact guard-function costs or hardware cycle attribution.

## Correctness, counts and analysis controls

The current shipping candidate passed the locked-9700X checker suite:
**695,065 checks, zero failures**. Unsupported target ISA execution is
explicitly skipped while compile/link controls remain enabled. Fresh exact-head
[hosted and native CI](https://github.com/buster14a/buster/actions/runs/41088352987)
also passed, including the required gate. Original-head certification is
[recorded separately](https://github.com/buster14a/buster/pull/919#issuecomment-6526778732);
the integration has its prospective signed trailer.

The untimed counter adapter changes only copied source and rebuilds the checker
object against the other 40 same-role retained objects. It records helper entries by
ACCESS state, diagnostic state and production route. Shipping assembly is the
independent evidence for actual call elimination: counter insertion can change
inlining and layout. Instrumented compiler timings are never measured.
Unmodified split controls must equal the entire ordinary object and image;
literal caller-bound manifests check remote scripts, argv, inputs and compiler
before and after code generation.

Control fixtures cover ACCESS off/on, nested scopes, malformed actions, both
scalar/vector paths, and actual upward rounding/inexact behavior with an
external Clang oracle. Successful outputs and diagnostics must match shipping
and probe builds; expected failures must produce the same diagnostics/status
and no object. SQLite count runs bind all frozen headers and require exact
shipping/probe output parity.

The timing reader requires all 9 canonical files, 2,268 unique status-zero
samples and positive wall/cycle/instruction counts. The stage reader requires
all 18 files and complete successful producer reports. No partial grid emits
CSV. Source/compiler/binary/input hashes precede final analysis execution and
are checked unchanged afterward. The timing reader's 25 fixture modes pass
optimized and ASan/UBSan builds; its genuine reversed-order producer control
is explicitly FORMAT evidence, separate from primary measurements.

Pooled timing medians use the arithmetic mean of the two central values among
42 samples. Individual 21-sample copy medians are also retained. This differs
from first-party `time-runs`' upper-middle pooled display. Wall values preserve
the producer's printed one-microsecond precision.

## Observed result and limits

All planned primary samples and stage reports passed the strict readers and
execution bindings. All 12 baseline/candidate × placement × scalar/vector
validation tuples produced the same object bytes for each corresponding input.
The full 785-file corpus/header and 332-file runtime/tool/resource ledgers
remained unchanged.

The untimed vector-compilation receipts show:

| Input | ACCESS-off entries, base → head | ACCESS-on entries, base → head |
|---|---:|---:|
| Frozen SQLite | 191,930 → 0 | 0 → 0 |
| Small ACCESS-off control | 23 → 0 | 0 → 0 |
| Small ACCESS-on control | 2 → 0 | 21 → 21 |

SQLite's baseline entries comprise 191,929 ordinary-action calls and one builtin
call. All 13 recorded count results reproduce from their retained stderr
receipts. These are diagnostic-adapter counts with shipping/probe output
parity, not timings of the instrumented compiler. Shipping disassembly supplies
the independent evidence that ACCESS-off cannot reach either candidate call.
The scoped/error controls also pass. All 24 shipping/probe parity cases and
16 linked shipping-object executions pass, including all four strict
upward-rounding/inexact executions. Four invalid-input base/head diagnostic
pairs were additionally compared directly and are byte-identical.

The following ranges cover the nine process/placement cells, each using two
copies and 42 measured samples per build. Positive values mean an increase.

| Input | Whole wall change | User-cycle change | Instruction change |
|---|---:|---:|---:|
| SQLite | −0.3839% to +0.3806% | −0.4613% to +0.5193% | −0.046700% to −0.046695% |
| Small ACCESS off | −22.85% to +28.50% | −5.078% to +4.802% | +0.001694% to +0.001901% |
| Small ACCESS on | −2.460% to +2.649% | −2.740% to +2.466% | +0.003113% to +0.003129% |

SQLite removes about 622,580–622,641 instructions from approximately 1.333
billion. Its pooled wall medians are 129.36–129.97 ms at baseline and
129.45–130.04 ms for the candidate; differences range from −0.499 to +0.493 ms.
The whole wall/cycle results cross zero and establish no general throughput
gain. The tiny controls have small, consistent instruction increases
(217–243.5 instructions off; 399–401 on), which are retained rather than
described as zero overhead.

Tiny process times are particularly sensitive to startup and physical copies.
ACCESS-off pooled medians range around 1.79–2.33 ms; all cross-copy comparisons
span −39.9% to +67.1% wall, wider than the pooled table. SQLite's corresponding
cross-copy ranges are −0.876% to +0.932% wall and −0.611% to +0.985% cycles;
its instruction reduction remains stable. `analysis/whole-medians.csv` retains
every copy median, and `analysis/whole-samples.csv` retains every measured row.
These limited controls do not establish absence of regression on other inputs.

The separate stage-clock comparison is also mixed: `check-input` changes
−0.7155% to +0.6804%, and `check-expressions` −1.6303% to +0.2197%.
`analysis/stages.csv` retains each paired cell. Those elapsed-clock diagnostics
do not turn the small instruction reduction into a shipping latency claim.

This completes the bounded call-guard acceptance: unnecessary ACCESS-off calls
are removed, ACCESS-on semantics/calls are retained, and the requested exact
toolchain, output, placement, instruction and time evidence is present. It
does not resolve #916's separate hardening-policy choice.

The exact six shipping images, two untimed diagnostic images and complete
Buster component notices are distributed as a separate
[release asset](https://github.com/buster14a/buster-performance/releases/tag/fenv-guards-919-2026-10-30-68cbb0ab).
`release-assets.sha256` identifies the explicit archive; no binary is added to
this Git evidence tree.

## Provenance

New C readers, source adapters, controls and orchestration are original work
for this qualification under Apache-2.0 WITH LLVM-exception. Placement proof
tools and the x87 normalizer are unchanged first-party snapshots from the
earlier #914/#917 evidence; their exact hashes are retained. Clang, Wild,
system libc/libm and the frozen SQLite/header corpus are external tools/inputs.
No compiler implementation, system ELF or preprocessed header corpus is imported
into this evidence tree. Binary distribution assets retain Buster's complete
license and component notices.
