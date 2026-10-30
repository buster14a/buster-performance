# Intrinsic catalog filter qualification for Buster #914

This packet follows up the unanswered qualification review on
[Buster #914](https://github.com/buster14a/buster/pull/914), for
[#893](https://github.com/buster14a/buster/issues/893). It records a real
code-generation correction, exact source and executable identities, counted
production lookup inputs, separate diagnostic costs, and locked Ryzen 7 9700X
measurements. It does not certify the original two source commits or authorize
a merge.

## Sources and the assembly correction

| Role | Buster source |
| --- | --- |
| Independent unfiltered base | `e693d878309ed3c3be05f2f550574d59217deceb` |
| Originally reviewed filter | `6f5c0645096b01831f58cde3cec5449cbf2454ad` |
| Corrected filter measured here | `60429e6479ee5f9ccbfb790dc86581a36c1279d2` |

Clang 23.1.4 at the production `-O3 -march=znver5` settings turned the
source-level scalar bitmap-probe loop into `VPGATHERDQ` in the real
`check_input_intrinsic_lookup`. This contradicted the intended no-gather
design. The three-line correction disables loop vectorization and
interleaving only for those bounded probes. The explicit eight-key SIMD mixing
remains. Independent reviews found no correctness issue in this correction.
The retained before/after production disassembly shows the gathers disappear
from both the lookup and filter functions, while SIMD multiplication remains.

The corrected supported-toolchain full build passed locally. Its existing
`test-builtin-intrinsic-catalog` controls passed **77,814 checks, zero failures**,
including scalar/vector identity, all catalog hits, deliberate collisions,
tails and protected pages. `pr914-catalog.log` records the command's output.
Corrected head `60429e64` passed
[run 41059311626](https://github.com/buster14a/buster/actions/runs/41059311626):
both hosted Clang 23.1.4 O3 complete-correctness configurations, baseline
emulation, complete native-vector correctness on Ryzen 7 9700X, and the final
qualification gate. Storage policy also passed. Plain-PR libFuzzer is skipped
by design. `raw/ci-corrected-head.json` records the exact head and completed
jobs. No older-head result is promoted to qualify this changed source.

## Build and placement controls

Both source trees were compiled on the same Ryzen 9 7940HS build machine with
Clang 23.1.4, `-O3 -march=znver5 -fwrapv -funsigned-char
-fno-strict-aliasing`, no debug information, and the ordinary 41-source build.
They use the same host libc 2.44. Binaries were transferred unchanged to the
Ryzen 7 9700X for measurements. The retained exact checker compile arguments,
binary hashes and proof receipts are under `placements/`.

The ordinary `build.sh shifts` mechanism moved the ordinary `.text` but left
the active checker contribution unchanged. Those ineffective variants are not
used for placement acceptance. Instead, the final 0/64/256-byte variants insert
padding inside the page-aligned `.text.buster_checker` contribution. All six
object-translation and final-linked gates pass. The zero objects and complete
zero images are byte-identical to the corresponding ordinary builds. The
proofs check preserved code, symbols, relocation sites and addends, unwind
bytes, and 1,445 actual wild-linked local section PLT32 targets per image.

The baseline lookup is inlined into `check_input_intrinsic_initialize`; that
function moves exactly 64/256 bytes. The corrected source emits both the
initializer and a standalone lookup, and both move exactly 64/256 bytes.
This moves the whole checker contribution, not the intrinsic functions alone.
`placements/provenance.txt` discloses the bounded x87 assembly-roundtrip
normalizer and the shared first-party proof-tool snapshots. `rejected/`
receipts preserve early fail-closed attempts; only the final `*-v3.json`
object/linked receipts establish these gates.

## Counted production names and costs

A separate untimed GDB run breaks at the unmodified production lookup entry
and dumps the original 32-bit length plus exactly that many bytes for each
name. It performs no calls inside the inferior. The capture uses the verified
Linux/x86-64 SysV signature (`names` in RSI, lane count in ECX; pointer offset
0, length offset 8, record stride 16). Its budgets are one million names and
one MiB per name. This is a trusted measurement input, not an adversarial
parser-scale robustness claim.

The frozen SQLite compile captured 11,159 names in 1,395 batches. The source
producer flushes only full eight-name batches and the final nonempty tail;
this single successful translation-unit invocation has one final seven-name
batch. The small builtin input has one six-name batch. A second small input
uses ordinary identifiers only and has one three-name batch. The final
diagnostic logs record original batch indices and lane counts explicitly:
SQLite's sole partial batch is index 1,394 with seven lanes, followed
immediately by normal exit. The replay preserves counted
spellings/order and rebuilds those batches. Names are allocated separately by
the replay harness, so their memory layout and cache behavior differ from the
production intern table. Replay times the lookup kernel only, excluding the
initializer's scanning, cache and allocation work.

| Captured input | Names | Base searched names | Filter candidates | Definite rejections | Exact hits | Searched misses after filter | Exact `memcmp` calls, base → filter |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | 11,159 | 11,159 | 638 | 10,521 | 292 | 346 | 132,274 → 7,275 |
| Small builtin input | 6 | 6 | 2 | 4 | 1 | 1 | 70 → 22 |
| Small ordinary identifiers | 3 | 3 | 1 | 2 | 0 | 1 | 36 → 12 |

The SQLite filter leaves 391 positive batches rather than all 1,395. The
summed `memcmp` length bound falls from 1,015,702 to 49,925 bytes; it is not a
count of actual bytes inspected by libc. Counts use a separate diagnostic
binary that wraps only the catalog's comparisons. No timings from that binary
are reported. Uninstrumented timing binaries verify each output pointer
against the unfiltered scalar oracle and retain stable catalog-row digests:
SQLite `b9dc68f745d400ba`, small builtin `fabc96ee5ddab5ab`, and small ordinary
identifiers `4cda56dc55e1df24`.

## Lookup replay timings

Every execution used the shared host lock and CPU 2, at the existing
performance governor and energy preference. Three independent processes per
case each collect seven samples. Each SQLite sample replays 100 passes; each
small builtin sample replays 100,000 passes. The ordinary-identifier control
collects costs and full setup/whole-process results, without a separate replay
timing campaign. Five warm-up passes precede samples.
The paired source order reverses in process two. A separate state performs at
least 200 ms of real public scalar lookup before every timed vector sample;
that conditioning is excluded from timing and its actual duration is logged.

These are ranges of the three process medians, in nanoseconds per name:

| Input/state | Unfiltered base | Corrected filter |
| --- | ---: | ---: |
| SQLite, back to back | 32.215–32.296 | 8.949–9.094 |
| SQLite, after 200 ms scalar | 32.063–32.511 | 8.988–9.016 |
| Small builtin, back to back | 36.493–37.338 | 30.565–31.239 |
| Small builtin, after 200 ms scalar | 36.827–37.223 | 30.482–31.029 |

These reductions establish the bounded warmed replay result, not a corresponding
whole-compile speedup. Hash/key loads, the generated 8 KiB bitmap, scalar bit
probes and the remaining exact searches are included in the corrected kernel.

## Whole compilation and initializer attribution

The shipping binaries run `measure-compile`, whose default, instrumented-stage
and unfiltered-reference processes rotate order each round. There are two
warm-up rounds and 21 measured rounds for SQLite, and five warm-up rounds and
51 measured rounds for each small input. Each placement has three independent
benchmark processes, with placement order rotated across processes. All 27
paired benchmark commands finish with zero failures. Every normal compile
matches its stage-reporting compile byte for byte. Separate target validation
also proves the SQLite and both small inputs' objects byte-identical across
both source versions, all three placements and scalar/vector compiler paths.
All 24 small executables return 21, matching the expected source behavior;
the builtin input's result was independently checked with Clang 23.1.4 at O0.

Ranges below are the three process medians at each placement. A negative
change means the corrected compiler took less time. The preliminary direct
unshifted run is retained but excluded from this final placement table.

| Shipping SQLite placement | Base wall ms | Corrected wall ms | Paired change |
| --- | ---: | ---: | ---: |
| 0 | 130.598–131.095 | 130.368–130.537 | −0.426% to −0.176% |
| 64 | 130.940–131.110 | 130.289–130.475 | −0.521% to −0.484% |
| 256 | 130.560–130.772 | 130.618–130.696 | −0.118% to +0.104% |

SQLite's observed whole-compile difference is small and changes sign in one
process at placement 256. This does **not** establish a placement-independent
whole-compiler gain, neutrality, or a corpus-wide speedup. The checker section
as a whole moves; the protocol does not independently attribute all changed
latency to this filter.

Across the same nine process/placement pairs, the small builtin input records
1.375–1.397 ms for the base and 1.313–1.360 ms for the corrected compiler
(paired changes −4.855% to −2.095%). The ordinary-identifier input records
1.348–1.367 ms and 1.293–1.299 ms respectively (−4.974% to −4.062%). At this
scale process startup and general code/data layout matter substantially. These
are observed complete-process results, not an attribution of those whole
differences to the lookup kernel.

The separate diagnostic adapter brackets the **complete existing**
`check_input_intrinsic_initialize` body with `CLOCK_MONOTONIC`: fresh-name
scanning, cache work, catalog lookups and intrinsic-table allocation are
included. Later call preparation and descriptor/type decoding are excluded.
It prints after timing. Only the checker object is rebuilt; the other 40
objects are unchanged. Its clock calls and changed code/register/layout
behavior disturb the measured implementation, and clock overhead is not
subtracted. These numbers are diagnostic attribution, not shipping latency.
The runner alternates base/fixed order, rejects malformed or missing rows,
and requires exactly **one** initializer row in every successful single-TU
invocation. Every recorded row satisfies that requirement. Adapter-produced
SQLite and both small objects also match shipping outputs byte for byte.

| Complete initializer diagnostic | Base median range | Corrected median range |
| --- | ---: | ---: |
| SQLite, 21 rounds × 3 processes | 1.258917–1.264248 ms | 0.874719–0.879808 ms |
| Small builtin, 51 rounds × 3 processes | 3.577–3.677 µs | 3.596–4.218 µs |
| Small ordinary identifiers, 51 rounds × 3 processes | 2.815–2.935 µs | 2.264–2.294 µs |

SQLite's complete initializer shows a consistent diagnostic reduction. The
small builtin case instead shows a small regression, including one process
with a larger gap; it must not be hidden by the warmed lookup replay or the
complete-process result. The other small case improves. These bounded results
support retaining the limited workload/state conclusions and leaving broader
performance acceptance to review.

## Reproduction and provenance

The `tools/` directory contains the original C replay harness, separate cost
mode, GDB counted capture, small input, build adapter and run scripts. The
replay includes the selected production catalog source from its exact Buster
checkout rather than a copied implementation. Build the base with
`BUSTER_LOOKUP_HAS_FILTER=0` and corrected source with `=1`; define
`BUSTER_INTRINSIC_CATALOG` to its absolute source path. Both use Clang 23.1.4
and the production optimization/semantic flags. `LOOKUP_COSTS=1` is diagnostic
only. `--format u32le`, `--passes`, `--samples`, `--warmup` and
`--after-scalar` select the recorded protocol.

Raw logs, captured spellings and source/host identities are retained. SQLite
and the pinned external header corpus are measurement inputs, not imported
compiler implementation or source fixtures. The capture is a sequence of
counted identifier-name facts from those inputs. The existing Buster LLVM
metadata and its generated bitmap keep their recorded provenance; they are
not relabeled as original first-party data. New measurement tools, the small
input and the bounded production correction are original work. The proof
tools are exact first-party snapshots shared by the concurrent #917 owner,
with source hashes recorded. No external implementation was copied.

`raw/build-tool-identity.txt` retains the build machine's compiler/linker
versions and binary hashes captured at packet completion. The actual compile
commands and binary hashes independently identify the produced artifacts.

The new compiler correction is signed under the session's existing compiler
opt-in. That authority does not retroactively certify the two original PR
commits and is not extended to this performance repository. This packet's
evidence commit carries no fabricated human DCO trailer.
