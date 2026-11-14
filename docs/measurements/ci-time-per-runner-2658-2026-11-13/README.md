# CI time per runner (#2658): the merge queue's candidate and the 9700X, 2026-11-13

Where a passing merge-queue candidate's runner time goes, which levers shorten it without new shards, rows or runners,
and the measurements of the first two (buster#2660): the CI glue's fixtures beside the rows, and test-ssa-source on
the CPUs the parallel runner grants it. buster's issue #2658 has the ranked plan.

## Contents

| Path | What |
|---|---|
| `queue/run-43481767714-jobs.json` | The candidate's jobs and steps (the API's, slimmed): run 43481767714, #2647's, 33.2 min, 962 runner-minutes |
| `queue/lines/JOB.txt` | From each of its 93 test, build and vector jobs' logs: the job's name, its CPU, each command's report line (`TITLE: passed in W s, C s of CPU`) and the runner's shard and summary lines |
| `queue/evidence-job-132079771503.log` | The candidate's evidence job, whose fixture step took 236 s of its 246 s |
| `queue/commands.json`, `queue/shards.txt` | `scripts/parse.py`'s reading of the lines: 1,700 commands with their job, row and CPU; each shard's summary |
| `queue/scripts/` | `parse.py`; `simulate.py` (each shard's schedule as the runner runs it, against bounds); `redeal.py` (the scheduled deal with fresh costs at the EPYC 7763's speed, finer driver parts, saturation); `saturation.py` (each row's work against its shards) |
| `queue/results/` | Their output |
| `9700x/scripts/` | The 9700X runs' scripts; every run one hold of the host lock through `~/buster-fast-bench/exclusive.sh` |
| `9700x/runs/` | Each run's `time.txt` (bash's `time`: real, user, sys), output and load before and after |
| `9700x/runs-*.stderr` | Each run's lock receipt |

## The candidate (run 43481767714)

- 106 jobs, 962 runner-minutes, 33.2 minutes. Its test commands held 81,405 CPU-seconds and used 61,976 (0.76).
- The rows started at 298 s: the evidence job's fixture step ("Test the nightly glue and the 9700X's caches against
  fixtures") took 236 s of its 246 s, and every row waits for it through `prepare-hosted-tools`. Over main's last 10
  passing candidates the evidence job took 180 to 264 s and the first shard started at 224 to 313 s.
- The commands that left the most of their CPUs idle, summed over the 8 rows (granted minus used CPU-seconds):
  the c-testsuite comparison (2,423, kept 0.71 of its 4), the functions' lanes (1,762, 0.30 of 8 capped at 4), SQLite's
  Tcl subset (1,041, 0.52), the random programs' promotion (936, 0.35), the runtime snapshot (892, 0.25). Each
  command's utilization is the same in every row: it comes from how the command is built, not from the sanitizer.
- `simulate.py` reproduces each shard's test step from its commands' times (1,361 s against 1,362 s for native TSan
  shard 4). `redeal.py` scales every time to the 7763's speed (the table's speeds: 9V45 0.64, 6973P-C 0.64, 9V74 0.79,
  8573C 0.80, 8370C 0.89) and deals the row again by those times: the longest native TSan shard would be 1,106 s rather
  than 1,361 s. Saturating each shard (used CPU over 4) leaves each row bound by its longest command: the semantic
  driver's part 3 (1,046 s) in the TSan rows, the C lexer as C++ heading (962 s) in x86-64 MSan.

## The 9700X runs

Host: `benchpress`, Ryzen 7 9700X, Linux 6.18.50, clang 23.1.1. The hosted runner's shape: `taskset -c 4,12,5,13`
(2 cores of 2 threads), `BUSTER_PARALLEL_CPUS=4`, CI's sanitizer options (`tools/ci/sanitizers.sh`'s), and a fresh
oracle cache in `check` mode for each run. Trees: `base` is main at `b7a95eed`; `glue` is the branch (`96d8ff03`,
then its files as `6047bbb5` and `b6d66728` have them; `b6d66728` changes no test, only `test_process_finish`'s
unused attribute and the ownership pin, after which the Release and Debug builds and the ownership check pass:
`build-branch4-x86-64`, `build-branch-debug`, `ownership-2.txt`).

### Per-child costs (`child-cost.sh`)

40 runs of a one-line `-fsyntax-only` and `-c` on CPU 4: per process, TSan 9 and 23 ms, MSan 7 and 17 ms, ASan 24 and
24 ms, the plain build about 0.5 ms. The driver parts' 1,000 s under TSan is not their children's start-up.

### test-ssa-source (`run-ssa.sh`)

| Command | Build | main | branch |
|---|---|---:|---:|
| c-testsuite comparison, 220 files (`compare`) | x86-64 MSan | 263.0 s (736.1 user + 6.0 sys) | 229.5 s (759.2 + 8.7) |
| 48 random programs (`random`) | x86-64 MSan | 32.4 s (43.1 + 3.6) | 17.9 s (62.8 + 5.6) |
| 24 random programs with lifetimes (`lifetimes`) | x86-64 MSan | 15.7 s (18.8 + 1.6) | 8.5 s (29.9 + 2.6) |
| c-testsuite comparison | x86-64 plain | 24.8 s (81.3 + 0.7) | 23.5 s (78.6 + 0.8, `compare-none-glue3`) |

Every test line is the same but for the work directory's name; the oracle's `runs as children` line counts one more
oracle child per part, about 33 ms each (96 against 49 for the 48 programs). `compare-none-glue` (45.9 s) and
`compare-none-glue2` (31.9 s) are the branch's first two versions: the first reported its parts in order through a
window of 8 per CPU, which one long program held (`parts-debug.sh`: 31 parts ended and waiting, one running); the second
ran a part's forms in turn when no token was free. On 2 cores of 2 threads, four busy threads give less than four
cores: the comparison's CPU time rose with its parallelism, so its ceiling is lower than its 0.71 suggested.

### The eight-CPU headings, alone and shared (`run-shared.sh`, `queue-shared.sh`, `queue-plain.sh`, `queue-control.sh`)

Each command alone with a grant of 4, as the runner runs a heading of 8 CPUs on a hosted runner, and beside 3
single-threaded CPU-bound processes (`sh -c 'while :; do :; done'`) on the same 4 CPUs with a grant of 1, as it would
run holding one CPU in a full shard. The serial control, one thread (`test-lexer`), gives what sharing a core's
siblings costs any command there.

| Command | Build | Alone (user s) | Shared | Shared / alone |
|---|---|---:|---:|---:|
| `test-lexer --fuzz 20000` (control) | x86-64 MSan | 15.5 (15.5) | 29.7 | 1.92 |
| `test-lexer --fuzz 100000` (control) | plain | 2.3 (2.3) | 3.9 | 1.65 |
| `test-check-lanes` (`shared-1`, `plain-1`) | MSan / plain | 45.8 (46.4) / 9.5 (7.4) | 84.0 / 19.2 | 1.83 / 2.02 |
| `test-snapshot` (`shared-2`, `plain-2`) | MSan / plain | 40.1 (39.9) / 10.2 (10.1) | 71.6 / 17.1 | 1.79 / 1.67 |
| `test-check-units` (`shared-5`) | MSan | 23.7 (31.3) | 47.5 | 2.00 |
| `test-calling-convention --cross-check` (`shared-10`) | MSan | 30.7 (96.8) | 50.9 | 1.66 |
| `test-static --cross-check` (`shared-9`) | MSan | 10.1 | 24.6 | 2.42 |
| `test-files` (`shared-4`) | MSan | 12.3 (18.3) | 30.8 | 2.51 |
| `test-executable` (`shared-6`) | MSan | 3.9 (4.4) | 12.6 | 3.26 |
| `test-foreign --cross-check` (`shared-3`) | MSan | 11.3 (7.3) | 51.7 | 4.57 |
| `test-link` (`shared-8`) | MSan | 0.21 | 1.15 | 5.41 |
| `test-lanes` (`shared-7`) | MSan | 1.1 | 59.2, failed | - |

`test-check-lanes`, `test-snapshot` and `test-check-units` keep about one CPU busy and lose no more than the control
when they share: in a full shard they would cost about half the CPU-seconds they hold now. The lanes of `test-foreign`,
`test-link`, `test-executable` and `test-lanes` wait for each other: they need the CPUs they hold. Shared, `test-lanes`
failed 10 of its 142 arena checks (its pages' advice and huge pages, `shared-7-shared/stdout.txt`), which pass alone; CI
gives it every CPU.

## After buster#2660: its merge-queue candidate (`queue-after/`)

[Run 43574311146](https://github.com/buster14a/buster/actions/runs/43574311146), the candidate that merged buster#2660
as `d2b1b238` on 2026-11-14, read as `queue/` reads 43481767714 (`queue-after/lines/`, `commands.json`, `shards.txt`;
the same 1,700 commands of the same headings).

| | 43481767714 (before) | 43574311146 (after) |
|---|---:|---:|
| Evidence job | 246 s | 10 s |
| CI glue fixtures | in the evidence job | 244 s, beside the rows, passed |
| First shard starts | 298 s (224 to 313 s over main's 10 candidates before) | 93 s |
| Whole run | 33.2 min, 962 runner-minutes | 30.6 min, 923 runner-minutes |
| Shard commands' CPU used over held | 0.76 | 0.77 |

The test-ssa-source commands kept more of their CPUs busy in every row:

| Command | Before (8 rows) | After |
|---|---|---|
| c-testsuite comparison [4 CPUs] | 0.69 to 0.80 | 0.79 to 0.88 |
| 48 random programs [4 CPUs] | 0.33 to 0.41 | 0.73 to 0.81 |
| 24 random programs with lifetimes [3 CPUs] | 0.42 to 0.48 | 0.79 to 1.02 |

On the same CPU model: the comparison in x86-64 ASan 225 to 208 s (9V74); the lifetimes 16 to 10 s (x86-64 ASan, 9V74)
and 55 to 36 s (x86-64 MSan, 7763). The plain rows' logs name no CPU, and each native row's compiler takes the vector
or scalar path by its runner's CPU, so neither compares across models. Main changed between the two runs (#2680's
admission by memory among them), so the whole-run figures are not this PR's alone.

## Limitations

- One candidate's logs for the analysis, one run for each 9700X measurement.
- The 9700X's cores are faster than every hosted CPU; the shape and the job counts are the runner's.
