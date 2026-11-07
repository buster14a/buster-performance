# #447: what the deferred reader's remaining lane-choice gap costs

After #1644, the deferred reader's lane rule was still more than a point behind a unit's best fixed lane count on 13 of
the 76 units of [deferred-post-lanes-447-2026-11-07](../deferred-post-lanes-447-2026-11-07/README.md). The largest
gaps were musl `regex/regexec.c` (3.35 points), c-testsuite `00204.c` (3.25) and musl `stdio/vfprintf.c` (3.03):
2 lanes read them about 3% faster than one lane, and the rule gives them one. This record asks:

- which readings that gap reaches, given that the C driver reads a unit apart only where the rule gives it 4 lanes or
  more, and in source order otherwise;
- whether anything the rule can count without another pass over the tokens tells the units 2 lanes pay on from those
  they don't.

Cited by Buster's `docs/c-deferred-bodies.md` ("What the remaining gap costs (#447)").

## Sources

| Tree | Buster commit | What it is | Source manifest | `build/compiler`'s SHA-256 |
| --- | --- | --- | --- | --- |
| `main3` | `25a3fdb1d76ed4f440e8b4e99e10722a0f1304a7` | main on 2026-11-07, with #1644 | `source-main3.sha256` | `212f5abfd84aa6c763389d0ea39b646ea18a1440d3328cacef39721cef79a094` |

`main3` is `git archive` of the commit (the host's checkout is shallow), and its manifest matches the archive: the
SHA-256 of `build.sh` and of every file under `src/`, in the order `sha256sum build.sh; find src -type f | LC_ALL=C
sort | xargs sha256sum` writes them. It was built on the host by `./build.sh` with `BUSTER_DEBUG_INFO=0` and the
default native host, in a lock hold of its own (`scripts/build-main3.sh`, `logs/build-main3.txt`).

The timing analyses read the earlier record's tables and logs at buster-performance
[`bdc1b0204`](https://github.com/buster14a/buster-performance/tree/bdc1b0204efded13a4bde0d2eb5104d7a12636cf/docs/measurements/deferred-post-lanes-447-2026-11-07):
its builds `main2` (`53854a7c2`), `post1` (`main2` with the post-merge rounds on the calling thread) and `cand2`
(`96a8d57ea`, #1644's code, which is main's). No new timings were taken.

## Inputs, options and host

The earlier records' inputs and options (`scripts/shape.sh` takes `bench.sh`'s): every C file of the frozen corpus
`preprocessor-391e729af658`'s musl `src` (1,524) with its build's options, c-testsuite's 220 single-exec programs at
`5c7275656d751de0e68b2d340a95b5681858ed07`, the frozen SQLite 3.53.2 and the 38 synthetic units, the last three with
the corpus's pinned GNU17 options. `host.txt`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1. CPU 2 has the
performance governor and energy preference; the other CPUs have powersave and `balance_performance`.

## Method

- **The survey** (`scripts/survey.sh`, `scripts/shape.sh`): `benchmark-checker-deferred --passes 6 --lanes 8` on each
  of the 1,783 units, eight at a time, in one lock hold of 9 seconds (`logs/survey.queue`). The `active` lanes of the
  reading on 8 permitted lanes are the lanes the rule gives the bodies. The driver's reading, with
  `--deferred-bodies`, takes the same rule on the command's lanes (its CPUs or `--lanes N`), and reads apart only where
  it gives `BUSTER_CHECK_DEFERRED_COMPILE_LANES` (4) or more; with more than 8 permitted, the rule gives the same count
  wherever it gives fewer than 8 here. Without `--deferred-bodies`, the default, the driver reads every unit in source
  order. The counts are deterministic; the timings of these runs aren't used. `tables/survey.tsv`.
- **The driver's view** (`scripts/driver.c`, `tables/driver.txt`): the earlier record's runs against source order in
  the same process. For each unit, the driver's reading is `cand2` on its rule's lanes where the rule gives 4 or more,
  and source order where not. The best is the least of source order, deferred on one lane, and each forced lane count
  of both builds. Medians over the rounds; the gap is in points of the best's time.
- **Two lanes' parts** (`scripts/phases.c`, `tables/phases-2.txt`): from the earlier record's `logs/post.log`, the
  medians over its three rounds of `post1` on 2 forced lanes against one lane, each phase in µs. Below 4 lanes, `post1`
  runs main's code: the post-merge rounds on the calling thread.
- **Fits** (`scripts/lsq.c`, `tables/oracle-2.txt`): least squares of the change 2 lanes make, in µs, over the 64 units
  whose one-lane reading takes 150 to 2,500 µs. The first fit uses only what the rule can count. The second uses each
  unit's measured walks and merge pass on one lane, which a reading knows only once it has read the unit.

## Results

### Which units the driver reads apart (`tables/survey.tsv`)

The lanes the rule gives on 8 permitted lanes:

| Units | Count | No bodies | 1 lane | 2 | 3 | 4 or more |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| musl `src` | 1,524 | 25 | 1,496 | 1 (`internal/floatscan.c`) | 1 (`regex/regcomp.c`) | 0 |
| c-testsuite single-exec | 220 | 0 | 220 | 0 | 0 | 0 |
| `sqlite3.c` | 1 | 0 | 0 | 0 | 0 | 1 (8 lanes) |
| synthetic | 38 | 0 | 13 | 7 | 6 | 12 |

The 1,496 include 37 files of other architectures, which the checker rejects (`status=1`), as the corpus gates of the
earlier records found; one more, `unistd/mipsn32/lseek.c`, is rejected before the reader reports its shape.

So no musl or c-testsuite unit reaches the driver's floor: with `--deferred-bodies`, the driver reads all of them in
source order. Of the real units, only `sqlite3.c` is read apart. The largest body among musl and c-testsuite is
`00200.c`'s, 20,420 tokens. Buster's own `main_unit_*.c` have a `#pragma clang section` line, which sends a unit to
source order before the top level's walk.

### The driver's reading against the best (`tables/driver.txt`)

On every musl and c-testsuite unit of the earlier record, source order reads faster than the deferred reader on any
lane count. Deferred on one lane is 12% (`locale/iconv.c`) to 614% (a program of 9 tokens) slower than source order,
and no lane count of 2, 3, 4 or 8 saves more than 8.0% of one lane's time (`regex/regcomp.c` on 3 lanes). The
driver's reading is therefore the best one on every real unit. On `sqlite3.c`, the rule's 8 lanes read 16.50% faster
than source order, and the best fixed count, 8 lanes in `main2`, 16.33%.

Six units are more than a point behind the best, all synthetic:

| Unit | Rule | Driver's reading against source order | Best | Gap |
| --- | ---: | ---: | --- | ---: |
| one body of 19,973 tokens beside one of 14,981 and fifteen of 993 (`d16x19f384s288`) | 4 | +4.61% | source order | 4.61 |
| one of 19,973 beside one of 9,989 and fifteen of 993 (`d16x19f384s192`) | 4 | +3.33% | source order | 3.33 |
| sixteen of 4,009, no headers (`b16x77`) | 8 | −20.13% | 8 lanes in `main2`: −22.51% | 3.07 |
| sixteen of 8,013 (`h16x154`) | 8 | −24.90% | 8 lanes in `main2`: −26.33% | 1.95 |
| sixteen of 1,981 (`h16x38`) | 5 | +1.51% | 4 lanes in `main2`: −0.28% | 1.80 |
| one of 19,973 beside fifteen of 1,981 (`l16x38f384`) | 5 | +0.39% | 4 lanes in `main2`: −1.18% | 1.59 |

`b16x77` and `h16x154` read on the same 8 lanes in both, in processes and builds of the same code. Their gaps of 3.07
and 1.95 points are the spread between processes, as are the two gaps of 1.6 and 1.8 points, which compare 5 lanes in
one process with 4 in another. The two units with one dominant body are the clear gaps: the rule gives them 4 lanes,
and the deferred reader on 4 lanes is 3.3 and 4.6% slower than source order. Their largest body is 41 and 45% of their
body tokens.

### What 2 lanes do on mid-sized units (`tables/phases-2.txt`)

On 2 lanes against one, from the earlier record's three rounds. *Excess / lane* is the rule's measure: the body tokens
beyond the critical path over the tokens a lane costs, which must reach 1 for 2 lanes. *Walks* are the bodies' walks
on one lane; *slowdown* is how much slower the woken lane walks a body token than the first lane, if the first lane
reads the larger of the largest body and half of them.

| Unit | Body tokens | Bodies | Top level | Excess / lane | Walks (µs) | ns per body token | Merge's pass, 1 / 2 lanes (µs) | 2 lanes against one | Slowdown |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `00204.c` | 3,246 | 108 | 4,407 | 0.50 | 75.8 | 23.4 | 30.2 / 18.0 | −19.6 µs, −3.25% | 1.47 |
| musl `regex/regexec.c` | 5,371 | 6 | 3,719 | 0.24 | 67.2 | 12.5 | 30.0 / 15.9 | −18.5 µs, −3.35% | 1.48 |
| musl `stdio/vfprintf.c` | 8,436 | 36 | 7,748 | 0.78 | 124.1 | 14.7 | 41.1 / 32.0 | −32.9 µs, −3.03% | 1.62 |
| musl `thread/pthread_create.c` | 3,713 | 47 | 10,500 | 0.37 | 104.9 | 28.2 | 50.2 / 39.7 | −14.3 µs, −1.26% | 1.71 |
| musl `malloc/mallocng/malloc.c` | 5,020 | 62 | 9,304 | 0.64 | 101.0 | 20.1 | 53.3 / 37.9 | −13.9 µs, −1.22% | 1.73 |
| musl `math/fmal.c` | 3,559 | 33 | 2,593 | 0.72 | 53.0 | 14.9 | 15.3 / 12.8 | +7.0 µs, +1.61% | 1.42 |
| musl `math/lgamma_r.c` | 3,531 | 30 | 2,655 | 0.66 | 48.9 | 13.8 | 15.4 / 11.4 | +8.8 µs, +1.91% | 1.47 |
| musl `math/j0.c` | 3,514 | 33 | 2,892 | 0.76 | 49.6 | 14.1 | 15.8 / 11.9 | +6.7 µs, +1.43% | 1.67 |
| musl `math/exp2l.c` | 2,872 | 29 | 2,994 | 0.61 | 41.9 | 14.6 | 13.7 / 9.7 | +11.0 µs, +2.78% | 1.56 |
| musl `crypt/crypt_des.c` | 2,045 | 8 | 4,942 | 0.21 | 34.5 | 16.8 | 15.6 / 10.2 | +12.6 µs, +3.32% | 1.80 |
| musl `time/strftime.c` | 2,990 | 39 | 8,691 | 0.34 | 72.3 | 24.2 | 38.6 / 29.4 | +0.3 µs, +0.03% | 1.73 |

The rule's measure doesn't separate the two groups. The units 2 lanes pay on range from 0.24 to 0.78, those they lose
on from 0.21 to 0.76; `00204.c` (0.50) gains 3.3% where `fmal.c` (0.72) loses 1.6%. What separates them is the time
the units' bodies take, which tokens don't give. A body token costs 12.5 to 28 ns to walk on one lane, and the merge's
pass 2.2 to 3.9 ns per token of the unit. The units 2 lanes pay on walk their bodies in 67 to 124 µs, with a pass of 30
to 53 µs. Those 2 lanes lose on take 35 to 53 µs, with a pass of 14 to 16 µs; `strftime.c`, 72 and 39 µs, breaks even.

The woken lane walks a body token 1.4 to 1.8 times slower than the first lane, which reads on CPU 2. Its CPU has
powersave and `balance_performance`, and a core that waited more than about 0.7 ms runs at half its clock from 0.1 to
0.2 ms after it resumes until about 1 ms later (Buster's `docs/object-writer-and-linker.md`, "How long to wait before
sleeping"). The slowdown varies with the unit; compute-bound walks such as the synthetic units' slow down most.

### What a model of the 2-lane change can predict (`tables/oracle-2.txt`)

Over the 64 units whose one-lane reading takes 150 to 2,500 µs, the 33 real ones among them:

| Fitted from | Terms | Real units whose sign the fit gets wrong |
| --- | --- | ---: |
| what the rule counts | body tokens a second lane takes, top-level tokens, all tokens, a constant | 8 of 33: `00200.c`, `00204.c`, `malloc.c`, `pthread_create.c`, `lgamma_r.c`, `fmal.c`, `lookup_name.c`, `__tz.c` |
| the measured walks and pass | the walks' time a second lane takes on, the pass's time on one lane, top-level tokens, a constant | 3 of 33: `00200.c`, `lookup_name.c` and `__tz.c`, changes of +42, −8 and −4 µs |

So a per-unit estimate of the walks' and the pass's time would choose the gap units' lanes, and token counts can't.
Such an estimate needs another pass over the bodies' tokens, such as the per-kind weights proposed on #447. #81's
fit of such weights (buster-performance#81) generalized worse than token count on every held-out group. The second fit
is in-sample: it shows what the times would decide, not a rule.

## Conclusion

- The remaining gap is in `check_input_deferred`'s readings: the benchmark's and the corpus tests'. The driver's
  reading, with `--deferred-bodies`, reads every musl and c-testsuite unit in source order, which is faster than the
  deferred reader on any lane count. The only real unit it reads apart, `sqlite3.c`, reads on its best lane count.
- In the driver's view, two synthetic units with a dominant body remain clear gaps: the rule gives them 4 lanes, where
  source order is 3.3 and 4.6% faster.
- Token counts and the bodies' token distribution, which the rule reads without another pass, can't tell the gap
  units from those 2 lanes lose on. The difference is the bodies' walk time and the merge's pass time.

## Limitations

- The timing results are the earlier record's three rounds (post experiment) and five (validation). Readings of the
  same work in two processes differ by up to about 2.4 points.
- The driver's view uses `check_input_deferred`'s reading at the rule's lanes as the driver's, and source order's
  reading for the units the driver reads in source order. The driver decides before the top level's walk, so it adds
  nothing to source order's reading there; the record doesn't time `-c` or `-fsyntax-only`.
- The slowdown estimate assumes an even split; with many bodies, the woken lane takes fewer of them, so the estimate
  understates its slowdown.
- The survey's counts come from one build; a change to the rule or the floor changes them.

## Provenance

The scripts, `phases.c`, `lsq.c`, `driver.c` and this README are original project work under
`Apache-2.0 WITH LLVM-exception`. The corpora are the earlier records' external runtime inputs; none of their content
is copied here. `tables/survey.tsv`, `logs/` and `host.txt` are the host's output, unedited.
