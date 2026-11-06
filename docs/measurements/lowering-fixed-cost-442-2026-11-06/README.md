# The `-c` path after checking: #418 rebaselined, and a small unit's fixed cost removed (#442), 2026-11-06

Buster issue [#442](https://github.com/buster14a/buster/issues/442) asked for #418's cost on the work `-c` does after
checking to be measured against main, attributed by stage and removed where avoidable. The
[first record](../lowering-scans-442-2026-10-26/README.md) (buster14a/buster#517) did that against main as it was on
2026-10-26. This one runs the same harness again on today's main, with the same baselines, and attributes and removes
the fixed cost that main's path after checking had since gained on small units. It is cited by Buster's
`docs/c-lowering.md` ("A small unit's fixed cost after checking").

Every number here is from the approved Ryzen 7 9700X (`benchpress`), under the shared lock, each run pinned to CPU 2.
Three comparisons are kept apart, as the issue asks:

- **#418 against main** (`pr418` against `main418`): what #418's merge costs on the same work.
- **Today's main and this work against main before #418** (`now` and `fix1` to `fix4` against `main418`), and this work
  against today's main (`fix4` against `now`).
- **The post-checking path against the whole compiler**: every table but the last section's times the path after
  checking alone, checking outside the time; the last section's times `-c` of all of c-testsuite at once on one lane,
  checking and all. Selective lowering against `--lower-all` within one tree is `benchmark-lowering-source`'s question,
  not this record's.

## Sources and trees

| Tree | Buster commit | What it is |
| --- | --- | --- |
| `main418` | `3bfb4a72a51f4a7872090905d52f92b95b3e1375` | main just before #418's merge (the merge's first parent), as in the first record |
| `pr418` | `54703dcf6607ecc1c7267869e46e59ab225ab393` | #418's merge |
| `now` | `ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b` | main on 2026-11-06 |
| `fix1` | `now` with `patches/fix1.patch` | lane 0's writer's columns kept from one emission to the next |
| `fix2` | `now` with `patches/fix2.patch` | `fix1`, and the runtime functions' names' lengths and hashes baked |
| `fix3` | `now` with `patches/fix3.patch` | `fix2`, and the builtin types' classes and facts copied |
| `fix4` | `now` with `patches/fix4.patch` | `fix3`, and a units' lane keeping lane 0's columns through `check_driver_object`: this work's change as reviewed |

`fix4.patch` is `git diff ec5f0f6b 3c681c4d` of buster14a/buster#1568's branch (`claude/confident-hypatia-i2myfn`),
whose later commits change only documentation, `fix3.patch` its head before review (`27d6a7b5`), and `fix1.patch` and
`fix2.patch` its first steps. `fix4` changes only
the units' path, which the harness doesn't take: its harness numbers are `fix3`'s again, within the build's code
placement. Each tree is `git archive` of its commit (with its patch applied), with the stage-split
harness added and registered (`scripts/build-trees.sh`), built with `BUSTER_DEBUG_INFO=0 ./build.sh` (clang 23.1.1),
each build under the lock. `manifests/source-*.sha256` lists every file of each tree as built, `manifests/trees.txt`
each manifest's SHA-256 and each executable's, `manifests/host.txt` the host.

Inputs: c-testsuite's `tests/single-exec/*.c` at `5c7275656d751de0e68b2d340a95b5681858ed07`
(`manifests/c-testsuite.sha256`), 220 programs, every one of which every tree lowers; and the first record's synthetic
units (`scripts/synthetic.py`, 200 and 2,000 definitions of block-scope statics, the same with asm labels taking every
made name first, file-scope compound literals, and plain functions and globals; `manifests/synthetic.sha256`).

## The harness

The old trees, before #1057's `check_source_prepare`, take the first record's `scripts/emit_ab.c` unchanged
(`scripts/register.py`, with `check_program_emit`'s arguments of that time). Today's main and this work's trees take
`scripts/emit_ab_now.c` (`scripts/register_now.py`): the same command, `benchmark-emit-ab`, the same timed stages and the
same output, with each file prepared by `check_source_prepare` as `-c` prepares it. Each file is checked outside the
time; then each of 101 passes times the driver's selection, the emission (`check_program_emit` without lanes, unwind
tables and debug information: lowering, Tier 0, branch sizing, encoding and the link's code), the static data's
publication, and the object (today's trees also place the definitions' named sections, `check_program_sections`, which
#619 added to `-c`), with every arena put back after each pass. Every pass must lower its warm-up's counts and object
bytes. `emit_ab_now.c` also has an optional sampler (`EMIT_AB_SAMPLES`), off in every run here.

Each round takes the lock once, for half a minute (phase B) to two minutes (phase C), and runs every tree in an order
that rotates by round, each run pinned to CPU 2 with 101 passes (`scripts/phaseB.sh`, `scripts/phaseC.sh`); c-testsuite's
rounds then run the units' path (below). Each build took the lock on its own, and the probe's and phase A's runs too. As in the first
record, the tables give each file's **floor**, its least per-run minimum over every round, summed
(`scripts/floor442.py`); the paired rounds' sums of per-file medians are in `analysis-*.txt`
(`scripts/analyze.py`) and the per-file quantiles in `distribution-*.txt` (`scripts/distribution.py`).

## Runs

| Run | Trees | Rounds | Where |
| --- | --- | --- | --- |
| probe | `main418`, `pr418`, `now`, 7 files, twice | | `9700x/probe/` |
| phase A | every tree to `fix2`, 7 files, once; perf of `now` and `fix2` on a 9-token unit | 1 | `9700x/phaseA/` |
| phase B | `main418`, `pr418`, `now`, `fix1`, `fix2` | c-testsuite 6, synthetic 4, units' path 6 × 2 | `9700x/phaseB/` |
| phase C | `main418`, `pr418`, `now`, `fix1` to `fix4` | 4 (c-testsuite, synthetic and units' path in each) | `9700x/phaseC/` |

Every run exited 0, and every timed pass lowered its warm-up's counts and object bytes (`progress.log`). Today's main and
every change lower each of the 220 programs to the same counts and object sizes (`9700x/analysis/floor-phase*.txt`);
the units' path made the same 220 objects, byte for byte, in every tree (`units/runs.txt`). Phase A's perf profiles are
dominated by the harness's 200 ms clock calibration and were not used; the attribution below is by stage and by
ablation (each change a tree of its own), with off-host profiles that the PR describes.

## Results

c-testsuite, the sum of the 220 programs' floors, phase C (`9700x/analysis/floor-phaseC.txt`), against `main418`:

| Subset | `main418` (ns) | `pr418` | `now` | `fix1` | `fix2` | `fix3` | `fix4` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| all 220 | 1,865,081 | +1.6% | +54.4% | −13.6% | −19.0% | −23.5% | **−23.1%** |
| output #418 kept, 216 | 1,727,545 | +1.5% | +58.8% | −12.0% | −17.8% | −22.6% | −22.2% |
| output #418 changed, 4 | 137,536 | +3.3% | −1.2% | −32.9% | −33.8% | −35.0% | −35.4% |
| under 300 tokens, 154 | 481,282 | −0.3% | +177.3% | +33.2% | +18.3% | +5.8% | +7.6% |
| 300 to 3,000 tokens, 6 | 77,755 | +1.4% | +37.4% | −20.6% | −24.4% | −27.0% | −27.0% |
| 3,000 tokens or more, 60 | 1,306,044 | +2.4% | +10.1% | −30.4% | −32.4% | −34.1% | −34.2% |

By stage, all 220 (`fix4` against `main418` and against `now`): selection 287,822 ns, −47.8% (`now` −43.2%); emission
1,467,963 ns, −21.8% (`now` +73.9%); publication 24,757 ns, +12.6% (`now` +33.7%); the object 70,032 ns, +25.2%
(`now` +38.4%). The four programs whose output #418 changed are 00150, 00182, 00208 and 00216 (#418 names its local
symbols as clang does, and lowers 00208's unreferenced block-scope static).

**Paired rounds** (`9700x/analysis/analysis-phase*.txt`, the sums of each run's per-file medians):

- phase C: `pr418` against `main418` +0.06 to +2.86% (median +1.59%); `now` +57.5 to +60.1% (+59.4%); `fix3` −22.8 to
  −24.4% (−23.5%); `fix4` −22.6 to −23.8% (−23.2%). Every round agrees.
- phase B: `pr418` −2.9 to +2.8% (+1.3%); `now` +52.9 to +59.4% (+59.0%); `fix1` −13.2 to −16.3% (−13.5%); `fix2`
  −18.7 to −22.6% (−19.3%). Phase B's floors (`floor-phaseB.txt`) agree with phase C's within 0.6 points.

**Per file** (`9700x/analysis/distribution-phaseC.txt`, the median over rounds of each run's minimum), `fix4` against
`main418`: p10 −34.5%, p50 +3.1%, p90 +32.8%; under 300 tokens p10 −12.4%, p50 +16.0%, p90 +37.5%, +240 ns a file in
sum; from 3,000 tokens p10 −41.4%, p50 −33.8%, p90 −29.4%. `fix4` against `now`: −50.2% in sum, every file faster (p90
−46.0%), and −61.1% under 300 tokens, −5,336 ns a file.

**Where the fixed cost was.** A 9-token unit (00001, phase A, each run's least of 101 passes) took 1,703 ns in
`main418` and 6,833 ns in `now`; `fix1` 3,566 ns, `fix2` 2,805 ns. Over the 154 programs under 300 tokens, against
`now`: `fix1` (lane 0's columns kept) −52.0%, then `fix2` (the runtime names' hashes) a further −11.2%, then `fix3`
(the builtin types' rows) a further −10.6% (floors, phase C).

**What remains under 300 tokens**: `fix4` takes +36,788 ns over `main418` on the 154 programs, +240 ns a file. The
emission is +22,019 ns (+5.6%): the runtime names' probes, about 185 a unit, and the rest of the setup that main's
lowering has added since #418 (its writer's columns, Tier 0's). The object is +10,368 ns (+36.4%), which now also places
the definitions' named sections (#619), and the publication +1,451 ns (+25.9%). The selection is −1,511 ns (−3.3%).
`pr418` against `main418` there: −0.3%.

**The synthetic units** (`9700x/analysis/synthetic-phaseC.txt`, the floor's total):

| Unit | `pr418` | `now` | `fix4` | `fix4` against `now` |
| --- | ---: | ---: | ---: | ---: |
| statics, 200 / 2,000 | +5.9% / +5.1% | +19.1% / +21.1% | +3.8% / +11.9% | −12.8% / −7.6% |
| collisions, 200 / 2,000 | +7.4% / +7.8% | +15.8% / +19.4% | +4.4% / +13.7% | −9.9% / −4.8% |
| literals, 200 / 2,000 | +6.1% / +6.7% | −1.3% / −4.0% | −14.5% / −7.3% | −13.4% / −3.4% |
| plain, 200 / 2,000 | +1.5% / +1.2% | +15.8% / +13.3% | +0.9% / +4.5% | −12.9% / −7.8% |

(Against `main418`, but the last column.) These units have 2,000 functions and few tokens. `fix4`'s emission is within
2.6% of `main418`'s on the 2,000-definition ones (plain −1.6%, statics +2.6%, collisions +2.1%); what keeps them above
`main418` is the selection, about twice `main418`'s there (plain 172,053 ns against 108,073; statics 247,845 against
115,036; collisions 356,028 against 171,892), and the publication and the object, about +25% and +13%: per-definition
work that main's selection and object have added since #418, not #418's (`pr418`'s selection is +5 to +12% on them, as
the first record found) and not the fixed cost this work removes.

## The whole compiler: the units' path

Each c-testsuite round also ran `-c --lanes 1` of all 220 programs at once, pinned to CPU 2: the whole compiler,
preprocessing and checking included, through the units' lanes (`9700x/analysis/units-phase*.txt`, each run's wall
time):

| Tree | Runs | Median (ms) | Against `now`, paired |
| --- | ---: | ---: | --- |
| `now` (phase C) | 8 | 77.025 | |
| `fix3` | 8 | 76.446 | −0.64% (−0.12 to −1.30%), 8 of 8 faster |
| `fix4` | 8 | 75.814 | **−1.51%** (−0.64 to −2.11%), 8 of 8 faster |
| `fix1` (phase B) | 12 | 76.764 | +0.12%, 5 of 12 faster |
| `fix2` (phase B) | 12 | 76.365 | −0.47%, 8 of 12 faster |

A small unit's compile is mostly its checking, so the path after checking is a small share of it. Before review
(`fix1` to `fix3`) a units' lane didn't keep lane 0's columns: `check_driver_object` released its lanes' arenas before
`check_units_compile` could keep them; `fix4` keeps them, and the 220 programs' compile makes 219 fewer `madvise` calls
(one per unit after the first; strace on the Xeon). The old trees can't compile several files at once (#152 came after
#418), so this table is today's main against this work only.

## Correctness

On the Xeon VM (the PR's testing section): every c-testsuite object by `-c`, `-c -g`, `-funsigned-char`, `--scalar` and
the units' path, and `main.c`'s, byte for byte today's main's; `test-checker` (785,723 checks, with the builtin rows'
copy compared with the rules in both char modes, and failing 606 checks with plain char's patch removed),
`test-check-lanes` (with the kept columns' settle checked), `test-check-units`, `test-calling-convention`,
`test-baked-tables` and `test-c-testsuite --cross-check` (220 of 220). On the 9700X, the PR's CI.

## Limitations

- The harness times the path after checking without lanes, as the first record's did; the driver's `-c` of one file
  runs it with lanes, once per process, cold. The units' path's table is the whole compiler's on the units' lanes.
- The harness differs by tree in how it prepares a file (before and after #1057), not in what it times.
- Code placement moves a build by about 2% on the 9700X (Buster's `docs/profiling.md`): `fix4` against `fix3`, whose
  harness path is the same code, is +0.5% in all and +1.9% under 300 tokens.
- c-testsuite's units are small, and the synthetic ones stress names and definitions; `main.c`'s lowering is #129's.

## Reproducing

On the 9700X, in a directory with a bare clone of Buster (`buster.git`) and this directory's `scripts/` and `patches/`:
`scripts/setup.sh` (the c-testsuite checkout, the synthetic units and the baseline trees), then `scripts/phaseA.sh`,
`scripts/phaseB.sh 6 4` and `scripts/phaseC.sh`, each taking the shared lock for each build and each round alone, and
`scripts/manifests.sh`. The analyses: `scripts/floor442.py ROUNDS --pair main418,pr418 --identical ... TREES`,
`scripts/analyze.py ROUNDS TREES`, `scripts/distribution.py ROUNDS A B min_ns`, `scripts/synthetic_floor.py ROUNDS
TREES` and `scripts/units_analyze.py RUNS TREES`.
