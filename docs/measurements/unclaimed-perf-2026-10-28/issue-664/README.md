# #664 bounded register-home selection: local work record

Source base: `bc1b486150850fe00bad1361a19f57d67706bb3b`.
Local implementation: `be441ff8786d47f56cc2d6e05bb416e8091d1bdc`, branch `codex/perf-664`.
No branch was pushed and no pull request was created.

The unbounded insertion sort is replaced by each kind's stable prefix of at most
16 eligible locals. General and floating homes are independent, so their prefixes
can be handed to the unchanged greedy allocator separately. Vector eligibility
and threshold masks reject blocks; qualifying locals insert into 16 register
lanes. Scalar insertion is bounded by the same 16 candidates. The existing vector
rank path for functions with at most 64 locals remains. Candidate scratch is 32
u32 identities rather than a local-sized arena allocation.

All implementation, fixtures, generators and runtime oracles in this record are
original project work under Apache-2.0 WITH LLVM-exception. The standalone test
fixture is copied from this project's own permanent `tier0_test.c`, preserving its
meaning; Clang, libc and binutils are external tools. No external implementation,
corpus or generated data was imported. `identities.sha256` identifies local
executables and inputs; `clang-version.txt`, `local-cpu.json`, and
`local-uname.txt` identify the local environment.

## Validation

- Local normal release build: 41 units, success; Clang 23.1.4,
  `BUSTER_DEBUG_INFO=0 ./build.sh`, through `cores -n 2`. This build precedes only
  a static assertion, comment movement and spelling a test's increment as a
  separate statement; no production executable statement changed afterward.
- `test-tier0 --seed 664 --count 64 --cross-check --cross-count 12`:
  **95,965 checks, zero failures**, including **2,671** new home checks.
- Current-source `build.sh check-call-graph`: 41 units, 25,108 functions,
  149,530 calls, zero disallowed cycles, three existing allowed cycles,
  zero split variables.
- ASan and UBSan, standalone permanent home fixtures, seeds 664 and 20261028:
  **5,342 checks, zero failures**.
- Five generated inputs: baseline and candidate objects are byte-identical.
  Candidate objects also link and execute against `run_builtin.c`'s independent
  unsigned semantics: **1,285 cases, zero failures** (257 each).
- Changing the vector insertion comparison from strictly greater to greater-or-equal
  reverses tie precedence and is rejected: the permanent fixtures report
  **988 failures in 5,342 checks**. `tie-mutation.patch` and its build/result logs
  preserve this negative control.

The home checks cover every count 0–80, then 81/127/255/1024/4097/16384/65536/
100000. Every column ends at a protected page. Ten count patterns cover zero,
one, two, increasing, decreasing, builtin-recipe, tied, near-UINT32_MAX, arbitrary
u32 and sparse references. They compare both candidate prefixes with the full
stable order and complete homes/save masks with the original greedy policy;
small cases additionally compare full ordering with the former insertion sort.
Prefilled register homes and address-taken exclusions are checked separately.

The source-level final partial-block high-home pointer is formed only when that
half contains lanes. The optimized assembly retains a masked load, as permitted
by that valid source. `assign-homes.asm` shows best counts and indices retained in
vector registers, masked unsigned comparisons and `vpermd` insertion, followed
by `vpcompressd`. No local-sized ordered list is materialized.

## Local performance screen

These are screening results on the Ryzen 9 7940HS with other sessions active on
other granted cores. They are not 9700X performance acceptance or a broad corpus
speedup claim. Each command had two physical cores through the allocator; the
compiler uses one lane. One optimized image per source was used; no placement or
A/A campaign was done.

`measure-compile --runs 7 --warmups 2 --reference OTHER_COMPILER -- --lanes 1 -c INPUT`
was run with each compiler as the measured executable. Every command reported
zero failures and checked its instrumented/default object equality. Raw samples,
ranges and resource use are in `local-popcount-{4000,8000}-{base,head}.log`.

| Popcount calls | Baseline Tier 0 median | Candidate Tier 0 median | Candidate whole compile | Paired baseline reference |
|---:|---:|---:|---:|---:|
| 4000 | 22.350 ms | 3.649 ms | 20.399 ms | 40.518 ms |
| 8000 | 87.659 ms | 7.224 ms | 37.403 ms | 125.027 ms |

The stage grows **3.92×** in the baseline and **1.98×** in the candidate when
calls double. These medians come from separate stage-report processes; the
paired whole-process controls are reported separately in the last two columns.

## Reproduction

Build `generate_builtin.c` with any C compiler, then generate:

```
generate_builtin popcount 4000 popcount-4000.c
generate_builtin popcount 8000 popcount-8000.c
generate_builtin overflow 2000 overflow-2000.c
generate_builtin overflow 4000 overflow-4000.c
generate_builtin expect 8000 expect-8000.c
```

For each compiler and input, compile with `--lanes 1 -c`, compare the resulting
objects, then link each candidate object with `run_builtin.c`, passing
`-DCOUNT=N -DOP=K` (popcount 0, overflow 1, expect 2). Every executable must
report zero failures.

`home_checks.c` includes the compiler's own `tier0_benchmark.c` and the exact
permanent-fixture range captured as `home_fixture.inc`. Build from the compiler
checkout with `-Isrc -march=native -fwrapv -funsigned-char -fno-strict-aliasing
-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer`; unused-function
warnings are suppressed because this standalone adapter selects only its home
fixtures from the included module. The log records the complete command.

For 9700X acceptance, build frozen base and candidate with ordinary flags and
run each measurement separately through the shared lock, pinned to CPU 2.
Retain popcount4k/8k and overflow2k/4k stage scaling, the expect8k control,
ordinary SQLite and backend benchmark controls, output validity, and exact
source/executable/input identities. The parent session coordinates that campaign.
