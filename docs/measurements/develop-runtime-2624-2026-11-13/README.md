# Develop's run time and build time (2026-11-13)

[buster#2624](https://github.com/buster14a/buster/issues/2624), widened by the owner to "optimize both build times and
run times for Develop as much as you can". Develop is `./build.sh`'s default since buster#2633. This record measures
where Develop's executable loses to Release's, what #2559's splitter fixes recover for Develop, and what bounds its
builds.

## Results

**The gap.** Develop's executable runs the compile path **+3.0%** instructions on `-c sqlite3.c` and **+3.2%** on
`-fsyntax-only` of the checker's unit over Release's, and 2.1% and 1.6% more cycles (`results/k5d.tsv`, 11 rounds).

**What recovers it.** The import limit, not the splitter's other fixes:

| Develop variant | `-c sqlite3.c` instructions | cycles | checker's unit instructions | cycles | clean build | edit of `c_check_input.c` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| base (`--import 100`) | 0 | 0 | 0 | 0 | 27.4 s | 14.6, 14.1, 12.3 s |
| readable strings alone (k3) | -0.005% | -0.61% | -0.017% | -0.26% | | |
| k5's splitter (k1 to k4, `--keep-statics`) | -0.35% | +0.08% | -0.26% | +0.26% | 27.0 s | |
| k5's splitter at `--import 300` | **-3.07%** | **-2.00%** | **-2.74%** | **-1.54%** | 31.1 s | 16.8, 15.9, 14.0 s |
| Release | -2.92% | -2.07% | -3.11% | -1.59% | | |

Percentages are medians over 11 rounds against the base's, at one placement each; the cycles' noise between rounds is
about ±0.5% (`min..max` in the analysis below). k5 at `--import 300` runs as Release does: instructions at or below
Release's, cycles within 0.1 points. It costs **+13%** on a clean build (31.1 s against 27.4 s) and **+13% to +15%**
on an edit (`results/edits-k5d300.tsv`: about 2 s on 12 to 15 s). k5 at `--import 100` gains nothing in cycles.

That is a trade between the edit loop and the tests' run time, not a free gain: buster#2633 leaves Develop at
`--import 100`, and #2624 records the choice for the owner.

**What bounds a clean Develop build.** `results/head-develop-ninja-log.txt`: 208 CPU-seconds on 8 jobs, 26.0 s,
against 27.5 s of wall time: the build is bound by its work, not by a chain. By kind of work: the checker's 48 parts
76.9 s, the backend's 29.4 s, the `main.c` units' front ends 21.4 s, the front end's parts 11.6 s, `presplit` 11.3 s,
then the smaller units' parts, and `c_preprocessor_benchmark.c` 7.4 s, Develop's longest single compile, which it kept
only for one test (buster#2633 leaves it out, as it leaves out 27 other benchmark units).

**What bounds an edit.** An edit of the checker's unit runs its front end (7.2 s here), then `presplit` (4.6 s in the
clean build), then the changed parts. `local/presplit-checker-report.txt` (the 4-CPU container, not the 9700X):
`presplit` read the checker's 47 MB of bitcode in 5.61 s, planned in 0.29 s and wrote its 49 parts in 7.23 s;
`llvm-nm`'s read of the same bitcode took 0.45 s. Every part is cloned and written on every edit, then compared with
the last; skipping unchanged ones needs a key that changes whenever a part's bitcode would, which buster#2627 (the
units in pieces) makes smaller instead.

## Method

- **Sources:** buster at `0a55fb99` (buster#2633's branch: Develop as the default, CI's toolchain), the base; each
  variant is that tree with a patch of `patches/`: `k3-develop.patch` (the readable strings' propagation alone),
  `k5d.patch` (buster-performance's `release-in-parts-2559-2026-11-13` k5 `presplit.c`, with `--keep-statics` in
  Develop's options), `k5d300.patch` (the same at `--import 300`). Release is the base tree's Release configuration.
- **Builds:** on the 9700X (`benchpress`), each its own hold of the lock, as `./build.sh` builds by default (Develop,
  CI's staged Clang 23.1.4) at `BUSTER_HOST_ARCH=znver5`; `logs/build-*.log`.
- **Runs:** `scripts/round.sh`, each round one hold of the lock, the sides' order rotating (`run.sh`, `run2.sh`,
  `run3.sh`, `chain.sh`): each side's `-c sqlite3.c` with the 9700X job's `measure-compile` options and the checker's
  unit's `-fsyntax-only`, on CPU 2, with `perf stat`'s user instructions and cycles; `results/*.tsv` has a line a run:
  round, side, workload, instructions, cycles.
- **Edits:** `scripts/edit.sh`, each round and side one hold: a function appended to `c_check_input.c`, `./build.sh`
  timed, then the file put back and built again outside the timing. The parts each edit optimized are the same for both
  sides (25, 21, 13: `c_check_input.c` is in three units).
