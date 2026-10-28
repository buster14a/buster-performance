# Invocations inside arguments expanded in place (buster #117 / PR #643)

Retained Ryzen 7 9700X campaign from October 27, 2026, completed at 23:26 UTC,
published during the October 28 completion review. Raw logs are preserved under
`results/`, including lock-wait messages. No new timing observations were
generated while preparing this report.

The measured baseline is Buster `92c025e71856d13eb34247477c5294d2cead139e`;
the candidate is `0a5c57621297ecd743a680f69fc520d623d4362b`. Remote snapshots
have no `.git` directory. Their 646 tracked file hashes each match the
respective Git revision exactly (`main-files.sha256`, `head-files.sha256`).
Clang 23.1.1 release builds use `BUSTER_DEBUG_INFO=0 ./build.sh shifts` and
normal native flags. Twelve executable identities are in `results/sha.txt`.

`queue1.sh` documents the executed campaign. Every build and measurement takes
the ordinary shared host lock separately (`locked.sh`); measurements run on
CPU 2. Each source has six placements of `main_unit_frontend.c`, shifted by
0/704/1408/2112/2816/3520 bytes. `again` executes the baseline binaries again.
Kernel observations rotate source roles over two rounds, with 21 internal
passes per process. Whole drivers rotate roles in three rounds, with three
fresh executable copies and three observations per copy/placement. Exact
frozen SQLite/header and frozen main.c arguments are in `source-inputs.txt`
and `input-host-identity.txt`; the latter includes input hashes and host/tool
identity. External corpus implementations are not incorporated here.

## Deferred preprocessor kernel

Each cell is the median of twelve process medians (six placements, two rounds).
Ranges span those twelve observations. Instructions are per input token. The
command is `benchmark-preprocessor --history-cost --only scalar`; its deferred
run uses the optimized engine while the benchmark's scalar option chooses
which history-cost variant is measured.

| Input / measure | Main | Candidate | Main again |
| --- | ---: | ---: | ---: |
| SQLite main loop, ms | 4.319 (4.256–4.436) | 4.224 (4.177–4.268) | 4.317 (4.263–4.395) |
| SQLite directives + loop, ms | 4.630 (4.566–4.768) | 4.534 (4.488–4.588) | 4.630 (4.575–4.720) |
| SQLite full kernel, ms | 9.084 (9.014–9.354) | 9.006 (8.964–9.037) | 9.083 (9.028–9.440) |
| SQLite instructions/input | 102.68 | 101.07 | 102.68 |
| Frozen main.c main loop, ms | 20.605 (20.484–20.923) | 20.603 (20.434–21.339) | 20.497 (20.452–20.675) |
| Frozen main.c directives + loop, ms | 20.913 (20.789–21.233) | 20.907 (20.738–21.648) | 20.803 (20.762–20.979) |
| Frozen main.c instructions/input | 276.68 | 277.53 | 276.68 |

SQLite's loop is about 0.095 ms shorter, and its directive-plus-loop budget
improves about 2.1%. Distributions overlap at their edges. The 2 ms #117 target
remains unmet. Frozen main.c does not establish a timing gain: instructions
increase 0.31%, and loop medians lie within placement/round spread and repeated
main drift. That cost is retained openly.

## Whole SQLite driver processes

All 1,458 recorded processes exit zero: 162 per role per command. Medians pool
all recorded observations, including every placement/copy/round. Raw wall
ranges overlap for every command. Original `time-runs` placement/copy summaries
remain in `results/drivers.txt`; pooling does not replace them.

| Command / measure | Main | Candidate | Main again |
| --- | ---: | ---: | ---: |
| `-E`, wall ms | 18.314 | 18.267 | 18.309 |
| `-E`, user cycles M | 85.608 | 85.374 | 85.601 |
| `-E`, user instructions M | 304.511 | 302.480 | 304.511 |
| `-E`, peak KiB | 58,124 | 58,164 | 58,124 |
| `parse -fsyntax-only`, wall ms | 18.305 | 18.226 | 18.312 |
| `parse -fsyntax-only`, user cycles M | 62.991 | 62.540 | 62.991 |
| `parse -fsyntax-only`, user instructions M | 170.222 | 168.227 | 170.222 |
| `parse -fsyntax-only`, peak KiB | 141,976 | 141,868 | 141,998 |
| `-fsyntax-only`, wall ms | 115.904 | 115.935 | 115.938 |
| `-fsyntax-only`, user cycles M | 530.356 | 530.610 | 530.884 |
| `-fsyntax-only`, user instructions M | 1,179.495 | 1,177.502 | 1,179.495 |
| `-fsyntax-only`, peak KiB | 483,286 | 483,414 | 483,288 |

The compiler-wide effect is small and placement/copy dependent. No whole
compilation timing improvement is claimed. Syntax-only instructions fall
0.17%; its +0.027% pooled wall and +0.048% cycles versus main lie inside the
retained distributions, with candidate medians below repeated-main. Peak RSS
points are included rather than omitted from the acceptance record.

`summarize.c` produces `summary.txt`: compile with `cc -O2 summarize.c -o
summarize`, then run `./summarize results`. It sums each observation's
directive-plus-loop times before taking the median. Printed phase precision
limits the budget's last digit.

## Completion review and mutation coverage

`previous-full-preprocessor-clang.log` records 382 fixtures and 3,000 generated
C17/C23 Clang comparisons with no differences or unverified cases.
`previous-mutants.log` retains six detected mutants and three initial build
failures; a failure to build is not a kill. Native current-head qualification
was also green before this followup.

The three corrected mutants initially built and survived the original fixture
suite. Three original regressions were added (`review-fixtures.patch`):

- Removing repainting of the nested macro's self name fails when the outer
  body rescans through another invocation, so direct output cannot repaint
  the argument incidentally.
- Dropping pending flags before an intervening plain run fails when an empty
  invocation precedes that run and another invocation, with later
  stringification observing the missing space.
- Allowing a nested template whose body still names an expanding macro fails
  its output comparison against the ordinary expansion path.

All three mutants compile at `-O1` and fail their new fixture
(`review-mutant-*.log`, `review-mutations-summary.log`, `mutant-*.patch`). All
nine intended mutation checks are therefore detected by tests, not build
failures. The unchanged production implementation with all 385 fixtures passes
under AddressSanitizer and UndefinedBehaviorSanitizer. The three new cases
also agree with external Clang (`review-baseline-sanitize.log`). `focused.c`
and `lexer_home.c` retain the harness. Build from the corresponding Buster tree:

```sh
clang -O1 -g -fsanitize=address,undefined -march=native -Isrc \
  -fwrapv -funsigned-char -fno-strict-aliasing -Wno-unused-function \
  -ffunction-sections -fdata-sections focused.c lexer_home.c \
  -Wl,--gc-sections -o focused
env -u CPATH -u C_INCLUDE_PATH ASAN_OPTIONS=detect_leaks=0 ./focused
```

Apply `review-fixtures.patch` to the measured candidate first; each mutant
patch changes one production condition. Review additions change tests/docs
only. They do not turn the measured executable into a new exact-head timing
observation. Integration with #631/#639 is checked separately in the source PR.

Implementation, fixtures and the new summarizer are original project work
under existing Apache-2.0 WITH LLVM-exception terms. Clang is an external
behavior oracle. This report neither closes #117 nor certifies future heads.
