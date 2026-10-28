# #590 backend startup: local implementation and qualification

Frozen native target qualification is complete in `target/README.md`:
lanes/startup 2,335/0, 110/110 object pairs identical, empty backend setup
0.000 ms at recorded clock precision under default and per-process
THP-disabled controls. Body-bearing native RSS remains stable; the laptop
layout-dependent increase below did not reproduce. TCC remains faster on
tiny inputs. The target report supersedes pending target instructions below.

Base: `bc1b486150850fe00bad1361a19f57d67706bb3b`.
Local branch: `codex/perf-590`.
Implementation: `8b815992da557a33b91c5efee809723d4e7f2df6`.
No PR, push or external branch was created.

## Change and invariants

`check_program_emit_timed` initializes encoder, operand-semantics and Tier 0
tables only when the selected program has at least one body. Unwind table
initialization uses the same guard when requested. The selected program's
builtin/asm helpers also come only from selected bodies, so no-body units
have no encoding, sizing or unwind consumer. Data/symbol publication,
attributes, normal error handling and rollback still execute.

The first function-bearing unit in a reusable caller initializes the tables
before its workers. Data-only units preserve already initialized state.
Table layouts and lookup loops are unchanged. The existing encoder guide's
fixup-copy decision retains its historical measured 2.4% cost for removing
that copy from the hot lookup design. Lazy/subset tables or readonly snapshots
require separate coverage/serialization/build/identity work; none is implied
by this focused startup fix.

## Provenance

Implementation, permanent fixtures and focused C adapters are original
project material under Apache-2.0 WITH LLVM-exception. `main-standalone.c`
is the same project's main.c with foreign entry macros and its unused driver
made static for a focused single-unit adapter. Clang, TCC and the pinned
c-testsuite run externally; no external implementation or corpus is imported.
The c-testsuite pin is `5c7275656d751de0e68b2d340a95b5681858ed07`.

## Local qualification

Ryzen 9 7940HS / Zen 4; Clang 23; BUSTER_DEBUG_INFO=0 and normal build.sh flags
(`-O3 -march=native`). Build, CPU, THP and executable identities are retained.
Every queued build/test uses `cores`, one grant per run.

- Release build: 41 units, success (`build.log`).
- `test-check-lanes --seed 590 --programs 1`: 2,307 checks, zero failures.
  New startup child: 150 checks, zero failures, both paths, cold/warm data
  objects equal, rows/unwind on/off, a lane team requested, resource failures,
  dropped static helper body and later real function initialization.
- Driver: 21,639 checks, zero failures (`driver.log`).
- Asm: 992 checks, zero failures across 632 source fixtures (`asm.log`).
- Pinned c-testsuite with Clang cross-check: 220/220 (`corpus.log`).
- Focused ASan/UBSan startup: 150 child checks plus parent, zero failures
  (`sanitizer.log`).
- Mutation restoring only both unconditional startup guards: 32 child
  failures; parent exits 1 (`mutation.patch`, `mutation.log`).
- Five fixtures on scalar and vector paths: all 10 baseline/head object pairs
  byte-identical (`object-equality.log`); hello's runtime output equals TCC.

## Local screens; these are not 9700X claims

Three warmups, 21 rotated samples per executable/input in `time-runs.log`,
432 successful processes total. Header-free original sources and pinned
c-testsuite's `00001.c` use identical command lines (`-c INPUT -o OBJECT`):

| Source | Base ms | Head ms | TCC ms |
| --- | ---: | ---: | ---: |
| empty | 3.332 | 2.077 | 0.902 |
| initialized data | 3.453 | 2.272 | 0.905 |
| dropped static helper body | 3.422 | 2.249 | 0.960 |
| tiny main | 3.562 | 3.442 | 0.950 |
| hello | 3.535 | 3.392 | 0.963 |
| c-testsuite 00001 | 3.561 | 3.341 | 0.929 |

Function-bearing controls retain table setup and near-identical retired
instructions. Their peak RSS in these particular executable layouts rises
about 3.4 MiB; no RSS neutrality or broad small-file speedup is claimed.
Rebaseline integrated target layouts before attributing a timing or RSS effect.

Separate 21-run `measure-compile` controls preserve stage clocks:

| Empty backend setup | Base ms | Head ms | Base/head minor faults |
| --- | ---: | ---: | ---: |
| Host default `[always]` | 1.000 | 0.001 | 11 / 0 |
| Process THP disabled | 1.824 | 0.001 | 1,099 / 0 |

`thp_off.c` changes only its process using PR_SET_THP_DISABLE and verifies it
with PR_GET_THP_DISABLE; an exec'd `/proc/self/status` control records
THP_enabled=0. It does not change shared host settings. This is a base-page
process control, not a claim that the host was changed to THP `madvise`.
Both measure-compile comparisons report zero failures, including equality of
normal versus instrumented objects. Setup work is structurally absent in the
no-body path regardless of the host's page policy.

## Target recipe

The parent owns all remote 9700X operations. Build base/head under the shared
exclusive lock, with one lock hold per build/test/measurement run. Pin timing
to CPU 2. Retain exact source, binary, CPU, THP and corpus identities.

For each original fixture and representative small c-testsuite files, run
rotated base/head/TCC `time-runs --runs 41 --warmups 3` using only common
arguments `-c INPUT -o OUTPUT`. Independently run each Buster's
`measure-compile --runs 41 --reference /usr/bin/tcc -- -c INPUT` for stage
clocks and normal/instrumented object equality. Repeat the empty control with
`thp_off BUSTER measure-compile ...` for per-process base pages without a host
policy change. Keep any actual `madvise` host run distinct from this control.

Compare objects across base/head and both scalar/vector paths, and keep
function-bearing controls separate: this fix removes setup only when no
function is selected. Run final integrated driver/lanes/corpus checks; neither
local passes nor the cold/warm flag assertions replace target measurements.
