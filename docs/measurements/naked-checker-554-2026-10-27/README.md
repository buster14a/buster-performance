# Naked-function checker constraints (#554)

Qualification and a bounded syntax-only cost screen on October 27, 2026.

The [main-merge follow-up](merge/README.md) records qualification after
integrating main's naked-function lowering, including updated lowering-boundary
fixtures. Earlier review and initial-head results remain below.

The [review follow-up](review/README.md) qualifies the later compiler head
`1193571fd09b3a2c35a74b07371070e37068721b`, including the VLA/type-only and
inline register-type review cases. The results below retain the initial head.

- Compiler baseline: `buster14a/buster` at `b7f444eb52bb53495da751f188b6bba883bbf891`.
- Qualified compiler: `fa7cae05018ebd6281a6a7fbcfd64c138b3fd3e9`, branch `codex/554-naked-function-diagnostics`.
- Host: benchpress, AMD Ryzen 7 9700X, Linux/x86-64, Clang 23.1.1. `host.txt` records its identity.
- Builds: `BUSTER_DEBUG_INFO=0 ./build.sh`, the repository's normal optimized native-ISA flags. The two source snapshots were transferred as archives. `source-sha256.txt` and `source-verify.log` verify every changed source/document against the qualified commit.
- Every build, qualification and timed screen used `~/buster-fast-bench/exclusive.sh`, with owner `codex-554`, a descriptive `EXCLUSIVE_TITLE`, and `EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/554`. Each run held the shared lock separately. Timing was pinned to CPU 2; tests used the runner's eight-CPU budget.

## Qualification

`qualification.list` is the exact command list. From the candidate checkout:

```sh
EXCLUSIVE_OWNER=codex-554 \
EXCLUSIVE_TITLE='Buster 554 final source qualification' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/554 \
~/buster-fast-bench/exclusive.sh env -u CPATH -u C_INCLUDE_PATH \
./build/compiler parallel --jobs 8 --timeout 180 ../qualification.list
```

`qualification.log`: five commands passed in 21.9 seconds, zero failed.

| Check | Result |
|---|---|
| `test-checker-asm` | 954 checks, 612 source fixtures, zero failures; exact Clang messages/columns for naked diagnostics |
| `test-checker-deferred` | 66 fixtures, 1,045 checks, 6,384 bodies read apart; zero failures |
| `test-checker --seed 133` | 255,763 checks, zero failures |
| `test-call-graph` | 37 fixtures, zero failures |
| Frozen SQLite, Clang comparison and `--deferred 8` | Accepted by both; 2,608 deferred bodies; zero diagnostic, path or resource differences |

The local Linux/Zen 4 run additionally checked the original three issue inputs
through syntax-only, object and direct modes, each with the scalar and vector
path: all 18 returned exactly 1, with the requested message and column (39,
62, 38 respectively), empty stdout and no output artifact. The local full
checker had four `fpclassify` oracle mismatches; the target-host full checker
above had none. `qualification-local.list` and `qualification-local.log`
record the final local focused and compiler-source call-graph checks.

## Syntax-only cost screen

`measure.sh` contains the complete workload and command. It uses the frozen
SQLite source, pinned predefines and headers at
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`. Both untimed
preflights must succeed before timing. `measurement.log` records input and
binary hashes and every process status; all timed processes returned 0.

The existing C `time-runs` tool rotates the baseline/candidate and three fresh
executable copies, with two warmups and nine runs per copy: 27 timed runs per
build. This is one code placement per build, with copies to expose mapping
variation; it is not a placement-independent performance result.

| Metric | Baseline | Candidate | Observed change |
|---|---:|---:|---:|
| Median wall time | 142.709 ms | 143.538 ms | +0.58% |
| Median user cycles | 652.380 M | 657.328 M | +0.76% |
| User instructions, approximately | 1.589340 B | 1.589691 B | +0.022% |
| Peak RSS | about 598,000 KB | about 598,000 KB | no material change in this screen |

The wall-time comparison over the copies ranges from +0.45% to +0.82%.
The screen observed a small slowdown; no performance improvement is claimed.
It does not distinguish implementation cost from code-placement effects or
establish end-to-end compilation performance. SQLite has no naked functions,
so it screens the ordinary path, not the rare naked-body scan. The latter
uses the existing resolved metadata and visits the source-ordered asm list
once; no new token column is allocated.

## Earlier development runs

- `qualification-before-linear.log` and `measurement-before-linear.log` are from `bdc3b6ba40d92cbea46b86c721336313e7e5f55f`, before the linear asm-list cursor and its interleaved-body fixtures. They are not qualification of the final head.
- `qualification-before-binding-guard.log` records the existing synthetic binding-capacity fixture catching unconditional access to optional reader state. `development-before-guard.patch`, applied to `bdc3b6ba`, reproduces that earlier development version. The submitted implementation gates inheritance on the presence of naked functions.
- `measurement-invalid-options.log` is excluded: an initial harness passed benchmark-only driver options, and all processes exited 1 without compiling the workload. Its sub-millisecond values are refusal timings, not compiler performance. The final harness removes those options and requires successful preflights.

## Provenance and limits

The checker, fixtures and run glue are original project material under
Apache-2.0 WITH LLVM-exception. Clang/LLVM `llvmorg-23.1.1`'s `SemaDecl.cpp`
and `SemaStmtAsm.cpp` supplied behavior references; no LLVM implementation or
test fixture was copied. Installed Clang is an external oracle. The frozen
SQLite source and headers are external runtime inputs and are not included.
This record changes no CI harness pin and does not claim source-corpus or
backend acceptance beyond the commands above.
