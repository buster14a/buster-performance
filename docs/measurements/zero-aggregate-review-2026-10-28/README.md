# Symbolic-zero aggregate review qualification

This record resolves the dense-input allocation and common-path review of
[Buster #627](https://github.com/buster14a/buster/pull/627), including its
integration with #656 retained payloads and #660 bounded byte bit-field writes.
The final candidate removes the old approximately 2 MiB dense scalar cache, but
retains a small measured ordinary-input cost. It is **not timing neutral**.

The final compiler is `0097ff1e116aa47a458172eceddc68b194db269f`; its matched
baseline is `6c0428b145fa5e9043d663880e1a89a8c68b82e9` (the reviewed retained
payload and bounded bit-field stack). Full tracked-file SHA-256 manifests from
both target directories match those exact Git trees. The exploratory compact
candidate is `92857a326f235c4e17bee5a4649d6bad91b1dadc`, also tree-verified.
These comparisons do not establish performance at later integration heads.

## Outcome and remaining cost

The conservative original issue controller retains separate base/head output
filenames. It measures three fresh rounds, seven samples per role per case after
one warmup, with rotating case and role order. Pooled measured medians are:

| Input | Baseline → final wall ms | Change | Baseline → final peak RSS KiB |
| --- | ---: | ---: | ---: |
| Dense byte array, 65,536 writes | 21.112682 → 21.235283 | +0.581% | 166,432 → 166,468 |
| Dense array ending in zero | 21.123303 → 21.204104 | +0.383% | 166,448 → 166,472 |
| Frozen SQLite, ordinary `--lanes 1 -c` | 142.579165 → 143.126451 | +0.384% | 506,088 → 506,076 |
| 256 MiB explicit zero | 18.274619 → 1.688908 | −90.758% | 283,928 → 21,816 |
| 256 MiB explicit TLS zero | 18.565084 → 1.693696 | −90.877% | 284,012 → 21,844 |
| 256 MiB overwritten nonzero | 18.257837 → 1.857154 | −89.828% | 283,924 → 21,796 |
| 256 MiB relocation-bearing aggregate | 25.240815 → 1.770581 | −92.985% | 283,984 → 21,880 |
| 256 MiB const zero (must materialize) | 85.458480 → 84.616039 | −0.986% | 546,068 → 546,196 |

`results.tsv` retains all 43 synthetic cases and SQLite, including all object
sizes and negative/final-zero/readonly controls. All 2,112 measured/warmup
processes return zero. Ten major faults, all in the initial round's warmups,
remain in the raw record. The controller also runs 258 separate stage-clock
processes; their outputs are in `stages/`. Stage observations are not added to
whole-process samples. For dense input, the three stage medians are static data
0.226 → 0.249 ms and publish data 1.006 → 1.096 ms; the tail-zero static-data
median is 0.231 → 0.221 ms. Three stage observations cannot precisely attribute
the residual whole-process cost.

The identical-baseline A/A repeat uses the same controller and distinct output
filenames. All 2,112 measured/warmup processes succeed, with no major faults.
Pooled role differences are −0.288% dense, +0.158% tail-zero, and −0.041%
SQLite. These controls quantify variation; they do not subtract away the
conservative A/B cost above.

An independent `time-runs` protocol uses a common output pathname, three roles
(baseline, final, repeated baseline), two fresh executable copies, and seven
runs across eight controls: 336 successful processes, no major faults. Dense
medians are 21.267 → 21.2745 → 21.2635 ms. Tail-zero is 21.367 → 21.318 →
21.2055 ms. Dense user instructions increase 349,451,921.5 → 350,566,909.5
(+0.3191%); tail-zero has the same relative increase. This stable extra work is
reported even though this protocol's timings overlap its baseline repeats.
Large-zero, TLS and overwritten cases improve about 89% in this protocol and
save approximately 262,000 KiB RSS. This is a bounded tradeoff for avoiding
unnecessary large zero images, not a general compiler throughput gain.

The compact-only candidate's earlier `time-runs` screen still costs +2.106%
dense / +1.609% tail-zero against the first baseline role, with approximately
7.47 million extra instructions. `logs/compact-control/` preserves that failed
candidate. The final direct-construction admission was added because compacting
the cache alone did not resolve the review concern.

## Implementation tested

- Cached scalar representations use the largest actual scalar width in that
  plan, capped at 32 bytes, instead of unconditional 32-byte slots. CLEAR/BYTES
  only plans allocate no scalar cache; mixed plans can still reserve stride
  positions for CLEAR/BYTES parts. Caches are released after replay, including
  successful symbolic-zero plans. Scratch payload fallback is compacted until
  exact-demand preflight rejects unavailable retained byte capacity.
- A bounded proof examines at most the last eight parts for a nonzero ordinary
  integer write untouched by later writes. If retained suffix capacity already
  fits, normal source-order validation constructs directly into that unpublished
  suffix. No scalar validation, relocation resolution, exact-demand check or
  transactional publication is skipped. Insufficient capacity stays on the
  validated symbolic path, preserving diagnostic order and rollback.
- Cached/direct bit-fields use #660's bounded byte helpers. Compact cached
  fields read only `ceil(width/8)` bytes and zero extend before writing.
- Nonzero scanning exits after the first nonzero 64-byte block, with guarded
  partial-byte handling. Boundary sorting reuses the existing stable binding
  radix twins over rotated 32-bit halves. Constant halves are skipped; scalar
  binding passes are selected below 65,536 boundaries and vector passes above.

## Scalar/vector decisions and assembly

`tools/pr627-kernels.c` calls the real helpers in compact candidate `92857a32`.
Three normal processes and a separate conditioned process (100 ms of untimed
scalar integer work before each measured sample) retain nine adaptive samples
per shape/variant. Sort timings include restoring the unsorted keys; allocation
and printing are outside the timed loop. These are small helper experiments,
not whole-compiler measurements. The wrapper build log did not retain the
original compiler argument vector; binary/source hashes and the source are
retained, and a reproduction compilation recipe is given below. Treat these
exploratory measurements as selection evidence with that limitation.

For 65,536 broad 64-bit keys, the pure vector wrapper is about 1.497 ms versus
2.295 ms for its scalar twin; for 4,096 keys it is 71.6 μs versus 17.6 μs.
For small broad-key ranges the vector histogram overhead loses. The final
hybrid threshold therefore keeps the scalar passes below 65,536. Low-half-only
keys and skipped constant halves improve further; the final hybrid policy is
not retroactively claimed as the pure-vector experiment's measured binary.

For 1 MiB all-zero data, the 64-byte scanner is about 6.8 μs, versus 5.95 μs
for 256-byte OR blocks and 189 μs for the scalar twin. The 256-byte control is
faster for long zero/late-nonzero ranges. For a first-byte nonzero the selected
64-byte path is about 0.66 ns versus 1.56 ns for 256-byte blocks and 14.66 ns
for 4 KiB blocks; full-range OR is about 6.2 μs. The 64-byte selection preserves
low early-exit latency; it is not optimal for every distribution. Conditioned
measurements preserve these principal orderings.

`assembly/` contains final executable disassembly of the planner, witness and
boundary sort. The planner's scanner uses unaligned ZMM loads, `vptestmq` and
mask extraction with an early branch; scalar-sized stores are inlined. The
sort wrapper calls the existing twins rather than adding a new histogram engine.

## Correctness and independent review

- Final locked target build: 41 translation units, Clang 23.1.1,
  `BUSTER_DEBUG_INFO=0`; `test-checker --seed 627`: **451,212 checks, zero
  failures**. Call graph: 24,916 functions, 147,194 calls, zero prohibited cycles
  and zero split variables (three documented allowed cycles).
- `tools/pr627-focused.c` against direct-admission revision `cba8b5ae` passes
  **118,231 ASan/UBSan checks** locally. It includes overwritten/final-zero,
  relocation removal, exact capacity and late rollback, plus bit-field widths
  1..128 at shifts 0..7 through both cached and direct paths. Exact 40-byte
  source/destination slices end at protected pages. This execution predates
  the later sort-selection-only change `0097ff1e`.
- Independent source review at `0097ff1e` found no blocker. The separate
  `review/` harness tests direct `cba8b5ae` versus a `92857a32` cached-module
  overlay under ASan/UBSan: 297 / 295 assertions pass and all 50 public semantic
  rows match. It covers malformed integers/types, mapped/unmapped/live TLS and
  overwritten references, full/no byte suffix, complete Link/symbol/prefix
  rollback, atom/fixup capacities and the guarded eighth/ninth-part cutoff.
  Its README distinguishes execution from later static review.
- All 43 final synthetic objects and SQLite are byte-identical to the matched
  baseline. Each synthetic object also passes independent runtime expectations
  for Buster and Clang objects: **86 successful native executions**. Readonly,
  TLS, relocation and symbol/size observations are included by the fixtures and
  verifier. Object identities/sizes are retained, not large object binaries.

The final native GitHub CI is a separate gate. Neither the local correctness
experiments nor this performance record fabricate a formal self-approval.

## Reproduction and provenance

Host: Ryzen 7 9700X, Zen 5, Linux 6.18.50-2-lts, Clang 23.1.1, Wild linker,
boost enabled. Full host and binary identities are in `identities/`. Builds and
measurements use the shared `~/buster-fast-bench/exclusive.sh` lock; measured
controllers use `taskset -c 2`. Local sanitizer experiments use Clang 23.1.4 on
Ryzen 9 7940HS and the local core allocator. No local timing is target evidence.

Create separate clean source directories at the pinned revisions and build each
under the lock with `BUSTER_DEBUG_INFO=0 ./build.sh`. From a copy of this record:

```sh
clang -O2 tools/compare.c -o compare
mkdir -p objects
# Repeat with ROUND=0, 1, 2; the lock and CPU pin wrap each controller invocation.
./compare BASE/build/compiler HEAD/build/compiler inputs "$PWD/objects" ROUND SQLITE
# For A/A pass BASE/build/compiler for both roles and use a separate object dir.
# tools/verify.sh expects compare.c, verify.c, inputs/ and objects/ at record root.
# Copy tools/verify.c and tools/verify.sh there; run verify.sh after the final round.
```

The frozen SQLite path used is
`~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c`;
its hash is retained. It is an external runtime input, not copied here. The
ordinary SQLite command adds no special corpus defines. The 43 small synthetic
inputs, original controller and independent expectation verifier are retained
from the project's #596 campaign under their existing terms.

The additional profile command is the final compiler's `time-runs --runs 7
--warmups 0 --copies 2 --build base BASE --build review HEAD --build base-again
BASE`, followed by eight `--list --lanes 1 -c INPUT` groups (dense, tail-zero,
zero256MiB, overwrite256MiB, const1MiB, reloc1MiB, negative16, TLS256MiB).
The controller is wrapped in the same lock and CPU pin.

To reproduce helper experiments, copy `tools/pr627-kernels.c` to compact revision
`92857a32`, compile with Clang `-O2 -march=znver5 -Isrc -fwrapv -funsigned-char
-fno-strict-aliasing -Wno-unused-function -Wno-unused-variable`, link `-lpthread
-ldl -lm`, and run `all` three times plus `scan conditioned` and `sort conditioned`
under the lock/CPU pin. This is a reproducible recipe, not a recovered command
line for the archived exploratory binary. For focused correctness, use the same
include/type flags with `-O1 -g -fsanitize=address,undefined
-fno-sanitize-recover=all`, and `ASAN_OPTIONS=detect_leaks=1`.

Original project changes and fixtures retain Apache-2.0 WITH LLVM-exception.
Harnesses include Buster components under their existing notices; the archive
does not relabel those components. No external implementation is imported.
