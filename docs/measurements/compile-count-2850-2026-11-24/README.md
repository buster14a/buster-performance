# #2850 on 2026-11-24: main read on the 9700X, and its instructions against the baseline

Records of the session that claimed the pre-merge instructions check of
[buster14a/buster#2850](https://github.com/buster14a/buster/issues/2850)
([claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7130772588)). Everything under `9700x/` is the
9700X (`benchpress`) under the lock, one lane on CPU 2, the frozen `sqlite3.c` with the 9700X job's options
(`-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`). `scripts/` has
what ran, each one hold of the lock.

## Main's instructions against the stated baseline (`9700x/main-ef3d4475f/`)

`tools/ci/compile-instructions.txt` stated 1,279,713,338 user instructions (main `90bb2d83`, 2026-11-23, #3471), and
the 9700X job's last step fails a run whose count is more than 0.5% from it.

| build | revision | user instructions, median | against 1,279,713,338 |
| --- | --- | ---: | ---: |
| the job's own, on its 9700X run 45381090551 | `fd12fac5` (a branch whose base is 91 commits behind main) | 1,273,235,371 | -0.506%, **the step failed** |
| `scripts/main-count.sh`: built on the 9700X as the job builds it (`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`) | main `ef3d4475f` | 1,274,733,397 | -0.389% |
| built in a cloud container with the same settings and shipped (`main-16ccdccd/`) | main `16ccdccd` | 1,271,150,776 | -0.669% |

- Main's own count is inside the band with 0.11% left below it. Main's merges since the baseline moved it there; no
  single one is identified here.
- The third row isn't the job's count: the executable is linked statically, so a build made on another machine carries
  that machine's C library. The two rows are also 35 commits apart, and the 0.28% between them isn't divided between
  the two causes here. Only a build made on the 9700X can be held to the file.
- buster14a/buster's baseline moves to 1,274,733,397 with this record (the pull request names it).

`measure.txt` is `measure-compile --runs 3 --instructions-baseline`; `build.log` the build (70.3 s for 43 units).

## Main at `16ccdccd`, with and without `--node-bodies` (`9700x/main-16ccdccd/`)

`scripts/main-state.sh`: one warm-up, `measure-compile --runs 7`, then five `--time-stages` runs of each setting,
alternating. The executable is the container's build (above), so its instructions aren't the job's; its times are the
9700X's.

- The default compile: **112.73 ms** (112.06 to 113.29), 545.9 M user cycles, 244 MB peak.
- The object is the same with `--node-bodies` (`cmp.txt`), which takes 1,752 of 2,674 bodies and 174,408 tokens.

| `--time-stages`, ms, medians of 5 | plain | `--node-bodies` | |
| --- | ---: | ---: | ---: |
| preprocess | 9.447 | 9.518 | +0.071 |
| parse | 4.834 | 4.779 | -0.055 |
| check-input | 41.799 | 69.861 | +28.062 |
| check-expressions | 11.246 | 8.058 | -3.188 |
| check-declarations | 2.124 | 1.727 | -0.397 |
| check-program | 23.075 | 17.884 | -5.191 |
| select | 0.991 | 0.928 | -0.063 |
| lower | 11.559 | 10.670 | -0.889 |
| tier0 | 3.585 | 3.613 | +0.028 |
| total | 112.337 | 130.576 | +18.239 |

The option still costs 18 ms more than it saves: the producer adds 28 ms to the reader and the pipeline's later
stages give back 9.8.

## The count before a merge (`count/`, `mutants/`)

Hosted runners count no instructions, so the pre-merge check
([specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7116632319)) counts another way: the sum
of the region counters that the compiler built with clang's `-fprofile-instr-generate` writes after one `-c` of the
frozen `sqlite3.c`. Everything here ran in a cloud container (4 CPUs, Intel Xeon at 2.10 GHz) with CI's clang 23.1.4,
the corpus's headers and predefines, on one lane. `count/sums.txt` has every count below.

| what was asked | answer |
| --- | --- |
| Is it the same from run to run? | Of 32 runs, 27 repeat their executable's count to within 3 and 5 are lower by 315 to 1,105 of 315 million; one more, whose profile wasn't kept, read 1,476 lower (0.0005%). |
| Does it depend on the build's optimization? | No: `-O0` and `-O1` builds of main `16ccdccd` both count 315,115,704. The `-O0` build takes 27 s (87 s of CPU), the `-O1` build 211 s. |
| On the host target? | No: a `native` build of main `ef3d4475f` counts 315,170,857 and the explicit vector target's 315,170,858. |
| On the directory, the environment, address randomization? | By 2 counts. |
| On the lanes? | Yes: without `--lanes 1` on 4 CPUs it counts 309,004,327 (-1.9%), so the check pins one lane. |
| What does the process's start cost? | An empty unit counts 413,762 and a one-function unit 5,387,397 (1.7%): the tables a real executable has baked, which the instrumented one builds. |
| Does it see #3381, the regression the check was asked for? | Yes: its merge `94ec1ca8c` counts 344,377,491 against its parent's 321,096,842, **+7.25%** (the instructions rose 7.0%), and the one-function unit's count is 5,352,606 on both. |

The specification's third prediction (more than 5% at #3381) holds. Its first (runs within 0.01%, refuted past 0.05%)
holds here at 0.0005% and is still to be read on hosted runners; its second (under 12 hosted minutes) is the hosted
step's to show: here the two builds take 28 s each and the six compiles 1 s each.

- `count/build-count.sh` and `count/sum.py` are the first builds' script and reader, before buster's
  `tools/ci/compile-count.sh` and `tools/ci/compile-count.c` existed; the later rows are those tools'.
- `count/small.c` and `count/small.profraw` are the 17-line program and the 368-byte raw profile its clang 23.1.4
  build wrote, which the reader's self-test holds as its real file: 15 counts.
- `mutants/run.py` changes the reader, the verdict and the script one place at a time and runs
  `tests/ci/compile-count.sh` on each copy; `mutants/result.txt` is its last run, 77 of 77 killed. Its first run left
  10 alive, each a test the fixtures lacked (two bounds, the spread's boundary, a low run, a statement as long as its
  base's, the lane option, a stale profile, a stale object, a counter that wraps the sum) or a branch the code didn't
  need, which is gone.

## What the default warnings cost (`9700x/warnings-ef3d4475f/`, `warnings/`)

The count's raw profile also says where the compile's work goes, function by function (`count/by-function.txt`, read
by `count/byfunc.py`): it is flat, the largest function `type_kind` at 3.6% (11.3 million calls, 16 a token). Taken
again with `-w`, it says what the warnings that are on by default add, on a unit that prints none
(buster14a/buster#1340):

| the frozen `sqlite3.c`, main `ef3d4475f` | default | `-w` | the default warnings |
| --- | ---: | ---: | ---: |
| wall on the 9700X, medians of 4 x 5 runs in ABBA order | 112.58 ms | 101.01 ms | **11.6 ms, 10.3%** |
| user cycles | 546.4 M | 483.5 M | 62.9 M |
| user instructions | 1,274.7 M | 1,135.8 M | 138.9 M, 10.9% |
| region counts (the container's `-O0` build) | 315,170,780 | 273,827,975 | 41,342,805, 13.1% |

- The object is the same with and without `-w` (`cmp.txt`), and neither compile prints a diagnostic. The 9700X rows
  are `scripts/main-w.sh`, one hold, with the job's own build of `ef3d4475f`.
- `warnings/by-function.txt` is the difference by function, all 603 of them: the first is 6.4% of it, the first 45
  hold 75%. `check_common_edge_slot`, `check_common_edges_reach`, `check_common_candidate_bits`,
  `check_common_root_frames` and `check_common_own_reach` lead.
- By how often the code runs for the warnings, 16% of the counts are in regions that run 200,000 times or more (loops
  over every node or token), 46% in regions that run 50,000 to 200,000 times (a root, a statement or a candidate at a
  time, 238 regions) and 37% below that. So what is left is mostly work a candidate at a time, not whole-unit scans.
- A compile with `-Wno-return-type` was to give that group's share. It failed: the option makes the compiler reject
  every array's decay to a pointer (buster14a/buster#3559).

## Where the default warnings' time is (`9700x/warn-prof-e347ec526/`, `9700x/warn-skip-e347ec526/`)

Main `e347ec526` (after buster14a/buster#3543), built on the 9700X as its job builds it.

**By function** (`scripts/warn-prof.sh`: eight `perf record` runs of each, alternating; `by-function-diff.txt`): the
warnings add 66.5 M user cycles a run. `check_common_graph_warnings` 8.2 M, `check_driver_common_warnings` (its
inlined token passes) 8.0 M, `check_common_own_reach` 4.5 M, `check_common_edges_reach` 4.1 M, `check_cfg_try` 3.3 M,
`check_common_parents` 3.1 M, `check_common_body_reached` 2.6 M, `check_common_facts` 2.2 M,
`check_program_branch_truth` 1.9 M lead. The counters (`stat-*.csv`): 2.1 M more L1 data misses, 0.4 M more cache
misses and 0.5 M more branch misses than `-w`.

**By pass** (`scripts/warn-skip.sh`, with `scripts/experiment-skip.patch`, a switch that leaves one pass out, not for
merge; `passes.txt`). Nothing left out: 111.69 ms.

| left out | ms saved | M cycles | M instructions |
| --- | ---: | ---: | ---: |
| `-w` | 11.62 | 63.9 | 129.4 |
| all of `check_driver_common_warnings` | 11.20 | 62.1 | 125.7 |
| the facts and the walks that need them | 9.49 | 52.4 | 105.1 |
| the root walk alone (`check_common_graph_warnings`) | 3.00 | 16.7 | 32.8 |
| every token pass together | 1.47 | 8.2 | 21.2 |
| one token pass at a time | within 0.4 of nothing each | | |
| the return facts (`-Wreturn-type`) | 0.05 | | |

So the facts are about 6.5 ms (the reach of the candidates about 3.0, which nodes are evaluated about 2.5, the
parents 0.6), the root walk 3.0 and the token passes 1.5.

**Counts don't measure this code.** buster14a/buster#3543 took 11.9 M instructions out of the reach's edge test and
saved 0.13 ms: the test's row of conversions is still loaded, and the load is what costs. By the counters above about
seven tenths of the warnings' cycles are cache misses. A step here is judged by its 9700X reading alone.

## The parts of the facts and the root walk (`9700x/warn-facts-e347ec526/`, `count/facts-counts-e347ec526.txt`)

Main `e347ec526` again, with `scripts/experiment-facts.patch` (switches that leave one part out, not for merge),
built on the 9700X as its job builds it (`scripts/warn-facts.sh`: 17 variants, three rounds of 11 runs each, forward,
reverse, forward, in one hold; `scripts/warn-facts-reduce.py` gives `reduced.txt`). Every variant's object is the
default compile's and none prints a diagnostic. Nothing left out: 111.85 ms; `-w`: 100.19 ms (11.66 less).

| left out | ms saved | M cycles | M instructions | k L1 misses |
| --- | ---: | ---: | ---: | ---: |
| the reach scan (`check_common_own_reach` over its candidates, and the climbs) | 2.92 | 15.7 | 40.2 | 358 |
| the edges' family alone, inside it | 0.14 | 0.8 | 15.9 | 111 |
| the batched range candidates | 0.33 | 1.4 | 0.8 | 47 |
| reachability (`check_common_unreachable`) | 1.72 | 9.2 | 17.6 | 199 |
| the operand masks' candidates | 0.46 | 2.3 | 7.2 | 72 |
| the unselected roots | 0.25 | 1.5 | 1.6 | 23 |
| the root loop | 2.34 | 12.9 | 26.8 | 267 |
| `check_common_root_frames` alone, inside it | 1.51 | 8.5 | 14.3 | 103 |
| the ignored statements alone, inside that | 0.25 | 1.2 | 1.5 | 33 |
| `-Wunsequenced`'s marks | 0.69 | 3.7 | 5.9 | 106 |
| the unevaluated scan before the roots | none (+0.13) | | | |
| all of the above together | 8.31 | 45.6 | 92.6 | 1012 |

The rounds agree to 0.2 ms or better for each row but the two smallest. The parts add up (8.58 one at a time, 8.31
together), so little of a part's cost is a cache miss the next part would take in its place; the edges' family is the
exception, 15.9 M instructions for 0.14 ms.

**What the scalar tests find** (`scripts/experiment-facts-counts.patch`, counters printed at exit; an instrumented
build in a cloud container, whose object is the same):

| the test | items visited | items it finds |
| --- | ---: | ---: |
| a reach candidate's own bits | 78,304 nodes | 2,292 with a bit (2.9%), which climb 5,640 parents |
| a root's frames | 58,732 roots | 1,458 with reach (2.5%), 8,696 work entries |
| a branch condition's truth | 16,964 conditions | 61 decided (0.4%) |
| a body's reachability | 2,674 bodies, 63,542 controls | 2,031 controls unreached, in 1,746 bodies |
| a root's unsequenced modification | 19,478 roots whose marks say modifies | |

The reach candidates by operator, visited and with a bit: `ASSIGN` 16,601 and 274, `CALL` 13,690 and 113, `CONDITION`
12,540 and 5, `SUBSCRIPT` 7,130 and 0, the six comparisons 11,258 and 9, `INITIALIZE` 3,982 and 109, `CONVERT` 3,888
and 87, `LOGICAL_AND` and `LOGICAL_OR` 3,414 and 1, `DEREFERENCE` 1,243 and 0, `NOT` 824 and 0, `CONDITIONAL` 672 and
548, the shifts 873 and 764, `COMMA` 362 and 362, `DIVIDE` and `REMAINDER` 475 and 0. Each of the three tests visits
tens of thousands of items to find a few percent of them; at 176 cycles a reach candidate, 219 a root and 430 a
condition, the visits are the cost.

## The token passes' scans against their candidates (`9700x/warn-scans-e347ec526/`)

`scripts/warn-scans.sh` with `scripts/experiment-scans.patch` (not for merge), same build and host, three rounds of 15:
ten more full scans of the tokens' roles and kinds cost 0.30 ms and twenty 0.67 ms, so one scan is 0.03 ms. Leaving
out what the three largest passes do at their candidates saves 0.15 ms (`sizeof`'s decay), 0.02 ms (empty bodies) and
0.29 ms (parentheses), 0.38 ms together. The token passes' 1.5 ms is ten passes of 0.1 to 0.3 ms each, not their
scans: fusing the scans would save about 0.3 ms.

## The count's hosted runs, and the fault round's last state

buster14a/buster#3560's two runs of "Count the compile against its base's":

| run | runner | the base's three runs | the change's | builds | the step |
| --- | --- | --- | --- | --- | --- |
| [first](https://github.com/buster14a/buster/actions/runs/45403050541/job/138477312336), head `bcbe4c5ce` | AMD EPYC 9V45 | 309,155,349 to 309,156,454 | 309,156,142 to 309,156,454 | 21 s, 20 s | 46 s |
| [second](https://github.com/buster14a/buster/actions/runs/45405015104/job/138484476111), head `29864d459` | AMD EPYC 9V74 | 309,156,490 three times | 309,156,490 three times | 31 s, 28 s | 66 s |

The two runners' counts are 0.00005% apart; a cloud container's was 0.01% from them. `mutants/run.py` is the fault
round as it ended: 83 mutants of the reader, the verdict and the script, each killed by a test (`mutants/result-83.txt`;
`mutants/result.txt` is the first round's, which left the survivors that the added tests now kill).

## #3553's regression and #3564's fix (`9700x/ab-main-3553/`, `9700x/ab-fix-3553/`, `9700x/ab-fix-3553-pr/`, `count/added-by-3553.txt`)

`scripts/ab-pr.sh NAME BASE HEAD` builds two revisions on the 9700X as its job builds them and runs `sqlite3.c`'s
`--lanes 1 -c` compile with the default warnings and with `-w`, base and head interleaved in three rounds (forward,
reverse, forward) of 11 runs, in one hold; `scripts/ab-patch.sh` does the same for a revision and a patch;
`scripts/ab-reduce.py` gives each directory's `reduced.txt`. Every run exited 0 and each pair's objects are identical.

| run | base | head | default, base to head, ms | by round | `-w`, ms |
| --- | --- | --- | ---: | --- | ---: |
| `ab-main-188cef807` (the script's first run) | `e347ec526` | main `188cef807` | 111.80 to 111.72 | -0.14, +0.03, -0.14 | 100.01 to 100.12 |
| `ab-main-3553` | main `dc8efaacd` | main `b4fda31b9` (#3553 merged) | 112.20 to **123.02** | +10.81, +10.93, +10.73 | 100.40 to 100.70 |
| `ab-fix-3553` | main `64e88df4d` | the same with `fix-3553.diff` (the first four reorderings) | 123.02 to 115.48 | -7.40, -7.74, -7.46 | 100.62 to 100.79 |
| `ab-fix-3553-pr` | main `31fd25ce8` | buster14a/buster#3564's head `eb000ae5d` | 122.99 to **114.71** | -8.33, -8.53, -7.98 | 100.72 to 100.72 |
| `ab-pr3569` (an independent run of a child session's pull request) | main `5cd20effd` | buster14a/buster#3569's head `0c6ae9dd8` | 115.50 to 113.71 | -2.91, -0.95, -1.53 | 100.93 to **101.50** (+0.37, +0.59, +0.74) |
| `ab-pr3568` (the same for another) | `188cef807`, its base then | buster14a/buster#3568's commit `e02c2cb9a` | 112.38 to 111.13 | -0.63, -0.70, -2.40 | 100.27 to 100.87 (+1.06, +0.41, +0.31), no instruction added |
| `ab-pr3572` (and the third) | main `5cd20effd` | buster14a/buster#3572's head `2bbb637e2` | 114.60 to 114.11 | -0.42, -0.44, -0.61 | 100.61 to 100.85 (+0.22, +0.25, +0.27), no instruction added |

#3553's pass put 10.82 ms on the default compile of a file with no diagnostics; the warnings went from 11.80 to
22.32 ms. `count/added-by-3553.txt` has the counts it added by function, in a cloud container: 44.07 M (+14.40%), of
which `check_common_token_descendant` 31.4 M (417,962 calls, from 874) and `check_semantic_member_token` 5.4 M (3,143
calls, from 366). #3564 runs the same tests cheapest first: 8.28 ms back, the warnings at 13.99 ms. The count's check
on main against that head (`tools/ci/compile-count.sh check`, cloud container): 350,285,104 to 312,364,924, stated
-10.830%, moved -10.825%, passed. `count/expression-forms.c` is the file of the four families' forms compared between
main's compiler and the fix's (62 warnings by default, clang 23.1.4's count too).

## A merge-queue candidate lost to one slow runner (`hosted/queue-candidate-45410258620.txt`)

buster14a/buster#3560's second queue candidate failed in one job: `test-checker --seed 133 --part 6/8` timed out at 600 s
on item n1. The file compares that job's blocks with the same item's in the pull request's own run. Six blocks, the
long ones that ran together, took 1.6 to 34 times their CPU time; the other 38 a median of 1.02. The next
candidate on the same base ran the same parts in their usual time on four runners of the same CPU model, and a
container reproduces no slowdown from the base. Nothing in the code explains it; the third candidate passed and
merged.

## buster14a/buster#3566's direct path against the full pipeline (`direct-3566/`)

`direct-3566/summary.txt`: the pull request's fast path changes the object and the diagnostics. On `sqlite3.c` the
object is 2,056,840 bytes against 2,063,760. Of the 4,576 C files under `tests/` it takes 783, and for 755 of them
its verdict differs from the same executable's with `--no-direct`: 411 that the full pipeline rejects are accepted in
silence, 343 lose their warnings and one dies with SIGFPE. `x == x`, `if (array)` and `printf("%s\n", 42)` compile
without their warning. Its count is 51.4 M against 312.4 M, which it doesn't state.

`ab-pr3569` ran with the host's load average near 3, so its rounds spread; the instructions don't: -12.60 M with the
default warnings and +5.14 M with `-w`. The pull request's pass ran on every compile, a `-w` one included, which
asks no branch's truth: 0.57 ms slower there. Its session was asked to build the bits where they are first asked for.

`ab-pr3568` ran with the load average between 1.4 and 2.2. Its `-w` row adds no instruction (0.00 M), so the 0.59 ms
it reads there is the hold's noise or the code's placement, not work; with the default warnings it takes 16.55 M
instructions out, as its own record (`root-loop-1340-2026-11-24`) says.

`ab-pr3572` ran on a quiet host (load average 0.06 at its start). The reach scan's filter takes 24.37 M instructions
and 3.00 M cycles out for 0.49 ms; its session's record (`reach-scan-1340-2026-11-24`) says why it isn't the 2 ms the
plan asked for: a tenth of the visits cost four times as much each, because the cost is the cold lines of the
conversions' rows, which the filter has to read too. That record also corrects this one: leaving the reach scan out
(the 2.92 ms above) left the roots without reach as well, so it counted some of the root walks' work; by profile the
scan itself was 2.0 to 2.5% of the compile's user cycles.
