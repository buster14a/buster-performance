# The deferred reader's lane rule after the post-merge rounds (#447), 2026-11-06

The 9700X's measurements for Buster issue [#447](https://github.com/buster14a/buster/issues/447): how many lanes
`check_input_deferred` should read a unit's function bodies on, measured against every fixed lane count on the same
revision, with absolute times, raw samples, the resident memory and a real C library's sources. They found that the rule
#683 fitted (one lane, and one more per 1,024 tokens and a quarter of the top level's beyond the bodies' critical path)
now reads 15 of 76 units more than a point slower than one lane: #1404 later put four post-merge rounds on the bodies'
lanes, beside the merge's pass (#697), by the same rule, so a second lane pays six lane rounds' dispatch and wake-ups,
where campaign A7 (#847) last fitted the rule's constants without the four. They then
fit and validate its replacement, one lane per 3,072 tokens and a third of the top level's beyond the critical path, and
at least one. Cited by Buster's `docs/c-deferred-bodies.md` ("The rule after the post-merge rounds (#447)").

## Sources

| Tree | Buster commit | What it is | Source manifest | Its SHA-256 | `build/compiler`'s SHA-256 |
| --- | --- | --- | --- | --- | --- |
| `tree` | `7997476e17e4fa4df45fb017cd4485872a4939a2` | main `ec5f0f6b` with `benchmark-checker-deferred`'s absolute times, `--raw` and `--rss`: #683's rule | `source-7997476e.sha256` | `66128d7824afc5d91536d2f1ea4a6d99bd2cbd56dd10402c512b792057265ecd` | `56a0fedd3a61b5c8c279d1d7fdec9e945a9b2e26788266d6ccc14dbb94c4e024` |
| `cand` | `a2f11bd8eb17d24dbfd7dbd0de62e95dff13ad90` | `tree` with the refitted rule and its fixtures | `source-a2f11bd8.sha256` | `8a9091fc030f490de368eb17f16c7b67915ef4374db4437fb0096ca93db9ca2f` | `d52268a306ca7e4acae2fe1d43e30a0493a97ef0e2509001becad79581aa7039` |

Each manifest lists the SHA-256 of `build.sh` and of every file under `src/` (872 lines), in the order
`sha256sum build.sh; find src -type f | LC_ALL=C sort | xargs sha256sum` writes them; each matches `git archive` of
its commit. Both were built on the host by `./build.sh` with `BUSTER_DEBUG_INFO=0` and the default native host, as the
9700X job builds them (`logs/build.txt`, `logs/build-cand.txt`; the wrappers are `scripts/build-tree.sh`, which ran as
`~/buster-fast-bench/447-claude/build.sh`, and `scripts/build-cand.sh`). `cand-asan` and `tree-asan` are worktrees of
the same commits for the AddressSanitizer builds.

## Inputs

`inputs.sha256` has the SHA-256 of every file read (295):

- c-testsuite's `tests/single-exec` at `5c7275656d751de0e68b2d340a95b5681858ed07`: the 220 programs of Buster's
  `tests/c-testsuite/subset.txt`; the grid reads six of them (`00001.c`, `00169.c`, `00182.c`, `00200.c`, `00204.c`,
  `00213.c`, #448's and #683's).
- The frozen corpus `/var/lib/buster-9700x/corpora/preprocessor-391e729af658` (its `MANIFESTS.sha256`:
  `corpus-manifest.sha256`): SQLite 3.53.2's amalgamation `sqlite/sqlite3.c`
  (`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), its pinned GNU17 predefines
  (`a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`) and headers; and Zig 0.14.1's vendored musl
  1.2.5 (with Zig's patches, not pristine upstream) with the corpus's generated-header overlay: 31 files of its `src`.
- The 38 synthetic units of [the deferred-lane-costs-113-2026-10-27 record](../deferred-lane-costs-113-2026-10-27/README.md),
  regenerated from their names by that record's generator (`synthetic/gen2.c`, a byte copy of its
  `scripts/first-gen2.c`) with `synthetic/make.sh`, which checks them against that record's `synthetic.sha256`
  (copied here): every one matches.

c-testsuite's programs, the synthetic units and SQLite take the corpus's pinned options, as the earlier records and the
9700X job do: `--predefines provenance/gnu17-pinned-predefines.txt --clang-features --no-default-config
--target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc` and the corpus's three `-isystem` directories. musl takes
its build's (the corpus's `config/musl.args` without `-E`'s own flags and `-pipe`): `--clang-features
--no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os`
and its seven `-I` directories (`scripts/bench.sh`). `SOURCE_DATE_EPOCH=1792454400`; `CPATH` and `C_INCLUDE_PATH` are
unset. The corpora are runtime inputs: none of their code is copied into this record.

## Host

`host.txt`: AMD Ryzen 7 9700X (CPU 10 offline), Linux 6.18.50-2-lts, clang 23.1.1, transparent huge pages `always`
(defrag `madvise`). CPU 2 has the performance governor and energy preference; CPUs 0, 1 and 3 to 7 have powersave and
`balance_performance`, as in the earlier records.

## Method

Every run is

```sh
./build/compiler benchmark-checker-deferred --passes P --lanes L --cpus 2,0,1,3,4,5,6,7 --raw [--every-lane] [--rss --cold] OPTIONS FILE
```

(`scripts/bench.sh`), with 24 passes (12 for SQLite; 6 with `--rss --cold`), each unit and configuration in a process
of its own. A process preprocesses the unit once, then each pass parses it and reads it three times, in the six orders
of the three readings in turn: in source order (`check_input`), by the deferred reader on one lane, and by the deferred
reader on `L` lanes, by its rule (`rule:L`) or on every lane the bodies can take (`every:L`). A change on `L` lanes is
the median of that reading's absolute nanoseconds against the one-lane reading's in the same process. `--raw` prints
every pass's samples (`checker-deferred:   pass=` lines), from which the medians come.

The host's lock (`~/buster-fast-bench/exclusive.sh`) was busy with 20 to 25 other sessions' and CI jobs' runs waiting.
Each hold ran one batch of processes (`scripts/batch.sh`, from `scripts/queue.sh`): a round's units and
configurations, in orders that rotate by round. The benchmarks' holds lasted 2 to 37 seconds, from their first process's
start to their last one's end; each waited 8 to 15 minutes for the lock. `logs/*.queue` give each hold's start (when it began to wait), end and status.

### The campaigns

| Log | Build | Units | Configurations | Rounds |
| --- | --- | --- | --- | ---: |
| `survey.log` | `tree` | 38: the six c-testsuite programs, SQLite, 31 musl files | `rule:8` | 1 |
| `grid.log` | `tree` | 22: the six c-testsuite programs, SQLite, 15 musl files | `rule:8`, `rule:3`, `rule:2`, `every:2`, `every:3`, `every:4`, `every:8` | 5 |
| `fit.log` | `tree` | 55: the 38 synthetic units, 17 more musl files | `every:2`, `every:3`, `every:4`, `every:8` | 3 |
| `validate.log` | `tree`, `cand` | 39: the 35 units of the grid and the fit whose lanes the two rules give differently, and four they give alike (SQLite, `b16x77.c`, `00213.c`, musl `string/strlen.c`) | `rule:8` by each build | 5 |
| `ctsweep.log` | `tree`, `cand` | the 220 c-testsuite programs | `rule:8` by each build | 1 |
| `memory.log` | `tree`, `cand` | the grid's 22 | `--rss --cold` with 6 passes: `tree`'s `rule:8`, `every:2` and `every:8`, `cand`'s `rule:8` | 2 |

The survey's first attempt queued a hold per unit; it ran two units before the queue was stopped for batches of units
and run again whole (`logs/aborted/`). The grid's and the fit's first rounds ran in two and three holds; their
queues were then continued with each round in one hold (`scripts/continue.sh`), which changes no process's command.

### The analysis

`scripts/summarize.c` reads the logs and writes `tables/`: one row per process (`runs-*.tsv`), per unit and
configuration (`summary-*.tsv`: the median, lowest and highest change over the rounds and the absolute medians),
the grid's choices (`choice-grid.tsv`), and the validation's pairs (`pair-validate.tsv`). `scripts/fit.c` reads the
grid's and the fit's rows and scores rules (`tables/fit*.txt`). Both are C, built with
`clang -std=gnu17 -O2 -Wall -Wextra -Werror`:

```sh
./summarize logs/grid.log logs/fit.log > tables/runs-grid-fit.tsv
./summarize --table summary logs/grid.log > tables/summary-grid.tsv
./summarize --table summary logs/fit.log > tables/summary-fit.tsv
./summarize --table choice logs/grid.log > tables/choice-grid.tsv
./summarize --table pair --pair rule:8,cand+rule:8 logs/validate.log > tables/pair-validate.tsv
./summarize logs/survey.log > tables/runs-survey.tsv
./summarize logs/ctsweep.log > tables/runs-ctsweep.tsv
./summarize logs/memory.log > tables/runs-memory.tsv
./fit --top 15 --units --rule 3072 3 lane tables/runs-grid-fit.tsv > tables/fit.txt
./fit --top 15 --fit-groups syn/,cts/,sqlite tables/runs-grid-fit.tsv > tables/fit-musl-held-out.txt
./fit --top 15 --fit-groups musl/,cts/,sqlite tables/runs-grid-fit.tsv > tables/fit-synthetic-held-out.txt
```

`fit` takes each unit's median change over its rounds on each forced count (one lane is 0), interpolates the lane
counts between 4 and 8 linearly, as #683's campaign A2 did, and scores a grid of 1,144 rules: `a` tokens and one per
`b` of the top level's per lane, beyond a threshold `c` the first extra lane must clear (or `c` = `lane`, the lane's
own tokens: `max(1, excess / lane_tokens)`), where the excess is the bodies' tokens beyond the larger of the largest
body's and twice the second largest's, and no more lanes than 8 or the bodies. A rule's score: the worst unit's change
against one lane, the units within one point of their best (one lane or a forced count), those more than a point
slower than one lane, and the gains forgone, each unit's change by the rule minus its best, summed. And as the C driver
applies it (`--deferred-bodies`): a unit the rule gives fewer than 4 lanes reads in source order, and the driver's
forgone gains are each unit's distance from the best of source order, one lane and the forced counts.

## Results

### The grid (`tables/summary-grid.tsv`, `tables/choice-grid.tsv`)

Medians over the five rounds: source order's and one lane's absolute times, each configuration's change against one
lane, and the lanes:

| Unit | Bodies | Tokens | Source order | One lane | `rule:8` | `rule:3` | `rule:2` | `every:2` | `every:3` | `every:4` | `every:8` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 2,608 | 706,237 | 56.0 ms | 66.3 ms | −26.23% (8) | −19.94% (3) | −13.03% (2) | −12.94% (2) | −19.66% (3) | −22.99% (4) | −26.36% (8) |
| musl `locale/iconv.c` | 46 | 149,607 | 15.1 ms | 16.6 ms | −0.05% (1) | +0.01% (1) | +0.05% (1) | +0.27% (2) | −0.94% (3) | −0.71% (4) | +0.98% (8) |
| `00200.c` | 2 | 23,466 | 890.4 µs | 1,069.4 µs | +0.28% (1) | +0.22% (1) | −0.01% (1) | +13.23% (2) | +13.07% (2) | +13.47% (2) | +13.06% (2) |
| musl `regex/regcomp.c` | 41 | 19,745 | 1,006.3 µs | 1,268.4 µs | −3.41% (6) | −4.95% (3) | −2.28% (2) | −0.69% (2) | −6.32% (3) | −5.53% (4) | +0.97% (8) |
| `00001.c` | 1 | 9 | 7.0 µs | 43.8 µs | +0.25% (1) | +0.44% (1) | +1.05% (1) | −0.60% (1) | +0.66% (1) | +0.87% (1) | +0.73% (1) |
| `00169.c` | 1 | 3,054 | 237.6 µs | 308.8 µs | +0.20% (1) | +0.21% (1) | −0.17% (1) | −0.28% (1) | −0.00% (1) | +0.12% (1) | −0.36% (1) |
| `00182.c` | 11 | 7,497 | 582.2 µs | 702.9 µs | +0.07% (1) | +0.07% (1) | −0.19% (1) | +9.87% (2) | +12.77% (3) | +15.46% (4) | +35.93% (8) |
| `00204.c` | 108 | 7,653 | 489.2 µs | 684.9 µs | +3.16% (2) | +2.61% (2) | +2.68% (2) | +2.12% (2) | +1.74% (3) | +3.42% (4) | +21.64% (8) |
| `00213.c` | 5 | 460 | 49.5 µs | 113.4 µs | +0.14% (1) | −0.30% (1) | +1.12% (1) | +23.70% (2) | +45.72% (3) | +59.45% (4) | +75.75% (5) |
| musl `string/strlen.c` | 1 | 819 | 73.8 µs | 135.2 µs | −0.10% (1) | −0.26% (1) | −0.07% (1) | −0.12% (1) | −0.19% (1) | −0.28% (1) | −0.36% (1) |
| musl `stdlib/qsort.c` | 29 | 4,120 | 248.3 µs | 354.4 µs | +0.15% (1) | −0.03% (1) | −0.05% (1) | +6.36% (2) | +8.06% (3) | +12.24% (4) | +35.41% (8) |
| musl `stdio/vfprintf.c` | 36 | 16,184 | 958.3 µs | 1,191.8 µs | +2.20% (2) | +1.23% (2) | +1.57% (2) | +1.29% (2) | +1.30% (3) | +3.23% (4) | +15.89% (8) |
| musl `regex/regexec.c` | 6 | 9,090 | 459.2 µs | 600.6 µs | +0.06% (1) | +0.06% (1) | −0.11% (1) | +2.46% (2) | +3.05% (3) | +8.46% (4) | +14.78% (6) |
| musl `malloc/mallocng/malloc.c` | 62 | 14,324 | 979.1 µs | 1,247.3 µs | +4.12% (2) | +2.36% (2) | +3.43% (2) | +1.68% (2) | +5.63% (3) | +7.88% (4) | +23.52% (8) |
| musl `math/lgamma_r.c` | 30 | 6,186 | 363.0 µs | 491.7 µs | +4.56% (2) | +4.56% (2) | +3.94% (2) | +5.12% (2) | +4.14% (3) | +7.04% (4) | +24.07% (8) |
| musl `math/j0.c` | 33 | 6,406 | 385.5 µs | 512.9 µs | +3.56% (2) | +3.05% (2) | +3.55% (2) | +3.14% (2) | +3.58% (3) | +4.42% (4) | +18.61% (8) |
| musl `crypt/crypt_blowfish.c` | 7 | 5,671 | 507.1 µs | 624.6 µs | −0.14% (1) | +0.08% (1) | +0.41% (1) | +1.71% (2) | +4.10% (3) | +6.84% (4) | +19.40% (7) |
| musl `thread/pthread_create.c` | 47 | 14,213 | 1,016.8 µs | 1,256.9 µs | −0.20% (1) | +0.16% (1) | −0.31% (1) | +3.06% (2) | +2.67% (3) | +5.55% (4) | +17.75% (8) |
| musl `internal/floatscan.c` | 30 | 10,822 | 607.2 µs | 792.3 µs | +0.81% (3) | −2.31% (3) | +3.16% (2) | −0.39% (2) | −0.62% (3) | +1.84% (4) | +19.55% (8) |
| musl `math/fmal.c` | 33 | 6,158 | 342.2 µs | 468.5 µs | +6.31% (2) | +6.31% (2) | +5.51% (2) | +5.95% (2) | +6.26% (3) | +9.50% (4) | +26.51% (8) |
| musl `math/exp2l.c` | 29 | 5,866 | 310.4 µs | 427.0 µs | +6.55% (2) | +6.96% (2) | +6.02% (2) | +7.29% (2) | +7.76% (3) | +9.38% (4) | +29.59% (8) |
| musl `math/__rem_pio2_large.c` | 29 | 7,555 | 349.0 µs | 477.8 µs | +4.94% (2) | +4.91% (2) | +4.65% (2) | +4.95% (2) | +6.18% (3) | +10.14% (4) | +26.97% (8) |

On every one of the 22 units, source order reads faster than the deferred reader on one lane (by 9.8% for musl's
`iconv.c` to 84.1% for `00001.c`); only SQLite's 8 lanes read faster than source order (12.6%).

### The rules (`tables/fit*.txt`)

| Rule | Worst unit against one lane | Units within a point of their best | More than a point slower than one lane | Gains forgone | The driver's |
| --- | ---: | ---: | ---: | ---: | ---: |
| #683's: `a` 1,024, `b` 4, `c` 0 | +7.29% | 46 of 76 | 15 | 120.33 points | 147.09 points |
| the best of `c` 0: `a` 6,144, `b` 2 | +0.98% | 59 | 0 | 52.05 | 18.98 |
| the best with a threshold: `a` 3,072, `b` 3, `c` 6,144 (and `a` 4,096, `b` 3, `c` 3,072) | +0.98% | 64 | 0 | 35.51 | 7.50 |
| `a` 3,072, `b` 3, `c` `lane`: one lane per 3,072 tokens and a third of the top level's, at least one | +0.98% | 65 | 0 | 33.95 | 2.66 |

The last is the best of the 1,144 and the rule `cand` builds; its neighbours forgo 35.51 (`a` 4,096, `b` 4) to 38.28
(`a` 3,072, `b` 4). The unit it reads slowest against one lane is `h16x19.c`, on 2 lanes (+0.98%). Fitted on the
synthetic units, c-testsuite and SQLite alone, it is still the best rule there (26.72 points forgone), and on the 31
musl units held out it reads 30 within a point of their best and none more than a point slower than one lane, where
#683's rule reads 7 of them more than a point slower (+7.29% the worst) and forgoes 34.43 points against its 7.23
(`fit-musl-held-out.txt`). Fitted without the synthetic units, the grid's rules don't generalize to them: musl's units
pay for no lane but `regcomp.c`'s, so the fit is loose (`fit-synthetic-held-out.txt`, 2.99% the worst held-out unit).

### The validation (`tables/pair-validate.tsv`)

Each build by its own rule on 8 permitted lanes (`rule:8` and `cand+rule:8`), each process's reading against its own
one-lane reading, the two builds' processes alternating in order by round, five rounds: the medians over the rounds,
the median of each round's difference (with its lowest and highest), and the median absolute reading on the rule's
lanes. The last four units are the controls, which both rules read on the same lanes.

| Unit | `tree`'s lanes | Its change | `cand`'s lanes | Its change | `cand` against `tree`, points (lowest, highest) | `tree`'s reading, µs | `cand`'s, µs |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| musl `regex/regcomp.c` | 6 | −2.61% | 2 | −1.18% | +0.12 (−1.98, +1.69) | 1,237.3 | 1,218.4 |
| `00204.c` | 2 | +2.29% | 1 | −0.22% | −2.81 (−5.10, −1.93) | 701.7 | 655.0 |
| musl `stdio/vfprintf.c` | 2 | +0.91% | 1 | −0.16% | −1.07 (−2.31, +0.14) | 1,213.1 | 1,152.5 |
| musl `malloc/mallocng/malloc.c` | 2 | +2.47% | 1 | +0.06% | −2.16 (−3.88, −1.13) | 1,275.8 | 1,214.0 |
| musl `math/lgamma_r.c` | 2 | +4.93% | 1 | −0.07% | −5.71 (−6.23, −3.48) | 523.0 | 469.5 |
| musl `math/j0.c` | 2 | +5.68% | 1 | −0.06% | −5.57 (−8.15, −3.74) | 540.3 | 488.1 |
| musl `internal/floatscan.c` | 3 | −0.93% | 1 | −0.00% | +0.90 (−1.05, +1.73) | 786.4 | 764.1 |
| musl `math/fmal.c` | 2 | +7.34% | 1 | −0.27% | −8.07 (−8.20, −6.07) | 505.0 | 446.8 |
| musl `math/exp2l.c` | 2 | +6.32% | 1 | −0.17% | −6.49 (−7.80, −3.80) | 457.5 | 408.1 |
| musl `math/__rem_pio2_large.c` | 2 | +5.60% | 1 | +0.22% | −5.27 (−8.73, −4.53) | 507.8 | 454.1 |
| `b16x19.c` | 8 | −8.08% | 4 | −19.75% | −11.44 (−15.30, −10.21) | 660.6 | 550.0 |
| `b16x5.c` | 4 | +3.33% | 1 | +0.03% | −3.30 (−5.44, −2.66) | 285.5 | 260.8 |
| `d16x19f384s192.c` | 8 | −3.48% | 3 | −10.48% | −6.19 (−9.89, −4.79) | 2,585.4 | 2,294.4 |
| `d16x19f384s288.c` | 6 | −8.27% | 3 | −11.73% | −3.00 (−5.04, −2.12) | 2,627.4 | 2,461.1 |
| `d2x1f384s288.c` | 2 | −2.73% | 1 | +0.16% | +2.81 (+0.15, +4.16) | 2,140.1 | 2,165.6 |
| `d2x1f480s240.c` | 4 | −1.72% | 2 | −3.46% | −1.45 (−1.98, −0.97) | 2,287.5 | 2,195.7 |
| `h16x10.c` | 3 | +1.54% | 1 | +0.24% | −1.21 (−4.34, −0.87) | 1,273.1 | 1,210.5 |
| `h16x19.c` | 5 | −2.24% | 2 | +0.73% | +2.95 (+0.87, +3.81) | 1,531.1 | 1,544.9 |
| `h16x38.c` | 8 | −10.46% | 4 | −10.88% | −0.21 (−1.62, +1.18) | 1,957.0 | 1,859.1 |
| `h16x5.c` | 2 | +5.66% | 1 | −0.07% | −5.81 (−6.28, −5.28) | 1,154.4 | 1,069.9 |
| `h64x1.c` | 2 | +4.79% | 1 | +0.04% | −4.91 (−5.74, −4.15) | 1,173.3 | 1,093.8 |
| `h64x10.c` | 8 | −12.08% | 5 | −12.70% | −0.56 (−2.27, −0.28) | 2,037.0 | 1,967.1 |
| `h64x3.c` | 3 | +1.01% | 1 | +0.07% | −0.94 (−1.41, +1.54) | 1,389.9 | 1,338.8 |
| `l16x10f192.c` | 3 | −2.74% | 1 | −0.05% | +2.90 (+0.56, +3.79) | 1,605.7 | 1,597.0 |
| `l16x10f384.c` | 3 | +0.28% | 1 | +0.14% | −0.28 (−0.59, +0.18) | 1,985.9 | 1,925.5 |
| `l16x19f192.c` | 5 | −5.48% | 2 | −2.59% | +3.01 (+1.85, +4.06) | 1,776.1 | 1,778.2 |
| `l16x19f384.c` | 5 | −3.66% | 2 | −4.62% | −1.08 (−1.83, +0.03) | 2,182.7 | 2,103.5 |
| `l16x38f192.c` | 8 | −10.74% | 4 | −13.07% | −2.33 (−4.15, +1.04) | 2,205.8 | 2,091.5 |
| `l16x38f384.c` | 8 | −7.80% | 4 | −13.81% | −6.04 (−6.31, −5.46) | 2,685.5 | 2,447.3 |
| `l16x5f384.c` | 2 | +2.26% | 1 | +0.29% | −2.10 (−2.24, −1.22) | 1,860.0 | 1,785.7 |
| `l4x38f384.c` | 2 | +0.54% | 1 | −0.02% | −0.87 (−1.48, +0.11) | 1,876.5 | 1,831.2 |
| `l8x38f384.c` | 5 | −2.70% | 2 | −3.32% | −0.79 (−2.70, −0.42) | 2,153.8 | 2,075.2 |
| `x16x19.c` | 2 | +2.51% | 1 | +0.04% | −2.50 (−2.61, −1.76) | 4,143.5 | 3,998.0 |
| `x16x38.c` | 4 | −3.15% | 2 | −0.47% | +2.60 (+0.87, +4.83) | 4,740.4 | 4,815.1 |
| `x16x77.c` | 7 | −7.99% | 4 | −9.27% | −1.12 (−1.89, −0.61) | 6,170.4 | 6,018.2 |
| `sqlite3.c` | 8 | −26.39% | 8 | −26.77% | −0.36 (−0.59, +0.16) | 48,752.4 | 48,126.7 |
| `b16x77.c` | 8 | −28.14% | 8 | −28.94% | −0.98 (−2.61, +1.12) | 1,771.6 | 1,761.0 |
| `00213.c` | 1 | +0.85% | 1 | −0.22% | −0.32 (−2.22, +0.81) | 115.0 | 114.5 |
| musl `string/strlen.c` | 1 | −0.22% | 1 | +0.24% | +0.34 (−0.99, +1.64) | 135.7 | 133.1 |

Of the 35 units whose lanes change, `cand` reads 22 more than a point faster than `tree` against one lane, 8 within a
point and 5 more than a point slower: synthetic units on which `tree`'s 2 to 5 lanes read 2.24 to 5.48% faster than
one lane, and `cand`'s 1 or 2 within +0.73% of it. Summed over the 35, `cand` gains 77.99 points. `cand` reads no unit
more than 0.73% slower than one lane (`h16x19.c`); `tree` read musl's `fmal.c` 7.34% slower. On the ten musl units, the
rule's readings take 6,616 µs by `cand` and 7,046 µs by `tree` (−6.11%; absolute times compare processes of two builds,
the changes readings of one process). The controls came within −0.98 to +0.34 points of each other.

### c-testsuite (`tables/runs-ctsweep.tsv`)

On the 220 programs, one process each by each build, `cand`'s rule reads every program on one lane. `tree`'s read
`00204.c` on two, 5.10% slower than its one-lane reading in that process, and the others on one.

### The memory (`tables/runs-memory.tsv`)

With `--rss --cold`, each reading starts from fresh caller arenas and reports its peak resident set and its growth
over its start (`/proc/self/status`'s `VmHWM`, reset through `/proc/self/clear_refs`, and `VmRSS`). The growth of each
configuration's two rounds differs by at most 0.2 MiB. The peaks include the process's own pages, which differ by
about 3 MiB between the two builds on small units (`cand`'s are lower in every configuration, the deferred reading's
growth alike), so the comparisons are of growth. Medians of the processes, in MiB:

| Unit | Source order | One lane | `tree` by its rule | `tree`, 2 forced | `tree`, 8 forced | `cand` by its rule |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 195.6 | 237.0 | 257.5 (8) | 248.4 (2) | 257.5 (8) | 257.5 (8) |
| musl `locale/iconv.c` | 80.3 | 111.3 | 111.3 (1) | 106.0 (2) | 108.6 (8) | 111.3 (1) |
| `00200.c` | 16.1 | 20.9 | 20.9 (1) | 21.2 (2) | 21.2 (2) | 20.9 (1) |
| musl `regex/regcomp.c` | 12.2 | 16.8 | 18.7 (6) | 17.4 (2) | 19.3 (8) | 17.4 (2) |
| `00001.c` | 0.1 | 0.2 | 0.2 (1) | 0.2 (1) | 0.2 (1) | 0.2 (1) |
| `00169.c` | 5.9 | 6.3 | 6.3 (1) | 6.3 (1) | 6.3 (1) | 6.3 (1) |
| `00182.c` | 8.0 | 8.5 | 8.5 (1) | 8.9 (2) | 10.2 (8) | 8.5 (1) |
| `00204.c` | 7.9 | 8.9 | 9.4 (2) | 9.4 (2) | 11.4 (8) | 9.0 (1) |
| `00213.c` | 6.0 | 6.3 | 6.4 (1) | 6.5 (2) | 6.7 (5) | 6.4 (1) |
| musl `string/strlen.c` | 6.0 | 6.3 | 6.3 (1) | 6.3 (1) | 6.3 (1) | 6.3 (1) |
| musl `stdlib/qsort.c` | 5.9 | 6.4 | 6.5 (1) | 6.7 (2) | 8.3 (8) | 6.5 (1) |
| musl `stdio/vfprintf.c` | 12.2 | 14.9 | 15.3 (2) | 15.4 (2) | 17.5 (8) | 15.0 (1) |
| musl `regex/regexec.c` | 8.1 | 8.6 | 8.6 (1) | 8.9 (2) | 9.9 (6) | 8.6 (1) |
| musl `malloc/mallocng/malloc.c` | 10.3 | 15.2 | 15.8 (2) | 15.9 (2) | 18.7 (8) | 15.3 (1) |
| musl `math/lgamma_r.c` | 8.1 | 8.6 | 9.0 (2) | 8.9 (2) | 10.4 (8) | 8.6 (1) |
| musl `math/j0.c` | 8.1 | 8.6 | 8.9 (2) | 8.8 (2) | 9.9 (8) | 8.6 (1) |
| musl `crypt/crypt_blowfish.c` | 7.9 | 8.4 | 8.5 (1) | 8.8 (2) | 9.9 (7) | 8.5 (1) |
| musl `thread/pthread_create.c` | 10.2 | 15.0 | 15.0 (1) | 15.5 (2) | 17.8 (8) | 15.0 (1) |
| musl `internal/floatscan.c` | 10.0 | 12.8 | 13.5 (3) | 13.2 (2) | 15.0 (8) | 12.8 (1) |
| musl `math/fmal.c` | 8.0 | 8.5 | 8.8 (2) | 8.8 (2) | 10.3 (8) | 8.5 (1) |
| musl `math/exp2l.c` | 8.0 | 8.5 | 8.7 (2) | 8.8 (2) | 10.0 (8) | 8.6 (1) |
| musl `math/__rem_pio2_large.c` | 8.0 | 8.5 | 8.9 (2) | 8.8 (2) | 10.4 (8) | 8.6 (1) |

### Correctness

`scripts/gates.sh` (on `tree`) and `scripts/gates-cand.sh` then `scripts/gates-cand-steps.sh` (on `cand`), each step in
a lock hold of its own (`logs/gates.queue`, `logs/gates-cand.queue`, `logs/gate-*.log`). On `cand`, the head this
record qualifies:

| Step | Command | Result |
| --- | --- | --- |
| `fixtures` | `test-checker-deferred` | 152 fixtures, 3,400 checks (456 with the ids in another order), 1,464 merged, 54,288 bodies read apart, 0 failures |
| `c-testsuite` | `test-checker-corpus --clang clang --deferred 8 --id-order 153` on the 220 programs | 220 units merged, 449 bodies, 0 differences; 220 accepted by both, 0 acceptance or path differences |
| `sqlite` | `test-checker-corpus --clang clang --deferred 8 --symbols` with the pinned options | 1 unit merged, 2,608 bodies, 0 differences; its functions and objects clang's (1 documented inlined, 0 unexplained) |
| `musl-1` to `musl-4` | `test-checker-corpus --clang clang --deferred 8` with musl's options, on all 1,524 C files of `src` in four parts | 1,486 units merged, 21,918 bodies, 0 differences; 38 left to source order, 37 where a body reports an error and 1 that doesn't parse, as clang rejects them; 0 acceptance or path differences |
| `asan-build` | `BUSTER_SANITIZER=address ./build.sh` (AddressSanitizer with UBSan, `-O3`) in `cand-asan` | built |
| `asan-fixtures` | `test-checker-deferred` | 152 fixtures, 3,400 checks, 0 failures, no sanitizer report |
| `asan-c-testsuite` | `test-checker-corpus --clang clang --deferred 8` on the 220 programs | 0 differences, no sanitizer report |
| `asan-sqlite` | `test-checker-corpus --clang clang --deferred 8` on SQLite | 2,608 bodies, 0 differences, no sanitizer report |

`test-checker-corpus --deferred N` reads the bodies on every lane they can take up to N (`every_lane`), so the rule's
constants change none of its readings; the fixtures check the rule's own lanes (eight fixtures on each side of its
steps, and the grouped-part fixtures at 2 and 6 lanes).

On `tree`, the same fixtures (54,096 bodies read apart: its rule's lanes), c-testsuite, SQLite and musl's first three
parts gave 0 failures and 0 differences. Its `musl-4` passed `src/include`, which holds no C file, among its
directories, and `test-checker-corpus` refused the command (usage, 0 files): it checked nothing. `gates-cand-steps.sh`
leaves directories without C files out, and `cand`'s `musl-4` above is its run (331 files). The first `cand` `musl-4`,
queued with the same list, was stopped before it ran (`logs/gates-cand.queue`). `tree`'s AddressSanitizer steps were
stopped before its build ran (`logs/gate-asan-build.log` has the lock's waiting messages alone) and run on `cand`
instead.

## Limitations

- Lane counts between 4 and 8 are interpolated in the fit; the validation measures the rules' own lanes.
- The fit's 55 units have three rounds; a unit's median change there carries about a point of noise on small units.
  Readings of the same work (a unit both builds read on one lane) differ by up to 2.2 points in a round (`00213.c`).
- The fit scores `check_input_deferred` alone, a process's first reading of a state (the default; the state released
  after every reading). A state's later readings (`--warm`, #697's item 3) and the C driver's whole compile
  (`--deferred-bodies`, off by default, #151) are not refitted here; the driver column applies the driver's own
  4-lane floor to the reader's measured times.
- The commit `a2f11bd8`'s message quotes the fit on the grid's first three rounds (63 of 76 within a point, 35.1 points
  forgone against 123.7, the worst +6.4%); the tables here are the final five rounds'.

## Provenance

The scripts, `summarize.c`, `fit.c` and this README are original project work under `Apache-2.0 WITH LLVM-exception`.
`synthetic/gen2.c` is the earlier record's original generator, copied unchanged. The corpora are external runtime
inputs whose files keep their own notices in the frozen corpus; none of their content is copied here. Logs are the
host's output, unedited.
