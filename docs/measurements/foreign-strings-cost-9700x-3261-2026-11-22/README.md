# Foreign string merging's no-benefit cost on the 9700X, buster #3261 (#3044)

Compiler PR: [#3261](https://github.com/buster14a/buster/pull/3261), issue
[#3044](https://github.com/buster14a/buster/issues/3044). Every timing here is from the Ryzen 7 9700X
(`benchpress`), Release builds by `./build.sh shifts` with the 9700X job's clang 23.1.4, each build, run and perf
session under `exclusive.sh` alone, pinned to CPU 2 (2026-11-22).

David's answers (2026-11-22): keep the block-head rule as written; first bring the shapes that gain nothing back to
main's cost (`lengths`, `duplicate`, clang -O2's `build_regression.o`), then take the 9700X figures.

## Trees

| Name | Commit | What |
| --- | --- | --- |
| main | `9a2cd4b80` | main when the branch was merged |
| old ("before") | `a9a3041ed` | the branch's `b9a1c58e2` with that main merged in |
| fix2 | old + `patches/fix2.patch` | refusal check, locals, a vector first pass (dropped) |
| fix4 | old + `patches/fix4.patch` | the block heads out of line, scalar first pass, vector second pass, exact check |
| fix5 | old + `patches/final.patch`'s code | fix4 + the probe table takes the block heads' pages: the PR's code |
| fix6 | old + `patches/fix6.patch` | fix5 with count and entries always inlined (slower, dropped) |

The PR's head `f5f4beaa5` is fix5's code with comment and documentation changes only (`patches/final.patch` holds
the code as built; its documentation part predates the figures).

## Method

`scripts/inputs.sh` and `scripts/inputs2.sh` keep `benchmark-foreign-strings`' objects of every shape at 4,096 and
131,072 literals (main's executable for `unique` and `duplicate`, the branch's for the shapes main lacks) and compile
`tools/ci/build_regression.c` with clang -O2 (`br`, linked as `results/br.ld`); `results/inputs.txt` has each link
line. `scripts/stage.sh NAME ROUNDS EXE...` runs `scripts/round.sh` under the lock once a round: every input, every
executable in an order shuffled by the round, one `link-foreign --merge-strings --time --lanes 1` process each, its
merge-strings line kept (`results/rN.tsv`: round, input, executable, position, ms; `rN.ps` the busiest processes and
load as each round took the lock and left it). Executables are each tree at six placements of
`main_unit_executable.c`'s code (`scripts/shifts.sh`): pages, shifts 0 to 3,520 in steps of 704, and lines, shifts 0,
16, 32, 48, 2,064 and 3,120; `mainx` is main's same files again, the floor. `scripts/summary.sh` gives each build's
median, interquartile mean and minimum over all placements and rounds, and both against main (`results/rN-summary.txt`).

| Run | Placements | Rounds | Trees |
| --- | --- | ---: | --- |
| r1 | pages | 15 | main, mainx, old |
| r2 | pages | 15 | main, mainx, old, fix2 |
| r3 | lines | 12 | main, mainx, old, fix4 |
| r4 | lines | 12 | main, mainx, old, fix5 |
| r5 | lines | 8 | main, mainx, fix6 |
| r6 | pages | 10 | main, mainx, old, fix5 (rebuilt from the same code) |

## Results: the merge-strings stage, µs (r6 pages / r4 lines, medians)

| Input | Main | Before | Now | Now / main |
| --- | ---: | ---: | ---: | ---: |
| `lengths`, 4,096 | 43 / 43 | 69 / 69 | 62 / 62 | 1.44 / 1.44 |
| `lengths`, 131,072 | 1,714 / 1,722 | 2,427 / 2,427 | 2,201 / 2,215 | 1.28 / 1.29 |
| `duplicate`, 4,096 | 84 / 86 | 89 / 87 | 90 / 87 | 1.07 / 1.01 |
| `duplicate`, 131,072 | 2,850 / 2,890 | 2,943 / 2,897 | 2,958 / 2,888 | 1.04 / 1.00 |
| `unique`, 4,096 | 43 / 43 | 47 / 48 | 46 / 46 | 1.07 / 1.07 |
| `unique`, 131,072 | 1,904 / 1,893 | 1,998 / 1,988 | 1,917 / 1,934 | 1.01 / 1.02 |
| clang -O2 `build_regression.o` | 27 / 27 | 138 / 138 | 30 / 29 | 1.11 / 1.07 |
| `suffix`, 4,096 | 43 / 43 | 179 / 178 | 190 / 187 | 4.42 / 4.35 |
| `suffix`, 131,072 | 1,732 / 1,724 | 6,475 / 6,421 | 6,553 / 6,475 | 3.78 / 3.76 |
| `repeats`, 4,096 | 109 / 110 | 183 / 181 | 193 / 191 | 1.78 / 1.74 |
| `repeats`, 131,072 | 3,870 / 3,923 | 6,994 / 6,917 | 7,084 / 6,996 | 1.83 / 1.78 |
| `tie`, 4,096 | 43 / 43 | 208 / 207 | 223 / 220 | 5.17 / 5.12 |
| `tie`, 131,072 | 1,904 / 1,915 | 7,878 / 7,814 | 7,971 / 7,929 | 4.19 / 4.14 |

`mainx` read 0.988 to 1.009 of main in r4 and r6. `--time` prints the stage to the microsecond. On `duplicate` at
4,096, main's own six line placements spread from 83.2 to 87.8 µs (interquartile means), which is why the two
families disagree there.

## Attribution

- `results/p1-pstat.txt`, `p2-pstat.txt` (`scripts/pstat.sh`): page faults, user instructions and cycles of 200
  whole processes, with and without `--merge-strings`. Before, `lengths` at 131,072 ran 13.2 million more user
  instructions in the stage than main; fix2 4.05 million.
- `perf/` (`scripts/perf.sh`, `scripts/periods.sh`, `scripts/insn.sh`): user cycles by symbol. The `perf-*` files are
  main, old and fix2; `perf4-*` main and fix4; `perf5-*` main and fix4 at fixed periods. fix2's vector first pass
  stalled on reading back its stored slots (`perf-fix-lengths-4096-flag.ann`).
- `results/p1-probe.txt`, `p2-probe.txt`, `p3-probe.txt` (`scripts/probe.sh`): the producer's phases in TSC ticks
  (3.79 GHz) from builds with timers (`patches/probe-main.diff`, `patches/probe-final.diff`), 15 processes a tree and
  input, interleaved, and the page faults during the block heads (`getrusage`). p2 is the PR's code; p3 compares its
  vector second pass with a scalar one (`patches/scalar-pass2.diff`): 1,948,412 against 2,286,498 ticks on `lengths`
  at 131,072.
- `results/thp.txt` (`scripts/thp.sh`): huge-page faults (as many for fix4 as for main) and kernel cycles (no more).

With the PR's code, `lengths`' block heads (the groups' map, and the prefilter, which flags nothing) took 64,296
ticks (17 µs) at 4,096 literals with 11 page faults, and 1,965,968 (518 µs) at 131,072 with 138; count, entries and
interning took 144,818 ticks against main's 147,630, and 6.38 million against 6.70 million. That is the remaining
cost: two passes over a multi-length group's entries and the first touch of the bitmaps.

## Outputs and tests

- `results/identical.txt` (`scripts/identical.sh`): every input linked by main, old and the PR's code; `unique`,
  `duplicate`, `lengths` and `br` are main's byte for byte, the sharing shapes old's
  (`results/identical-sharing.txt`), and the PR's outputs ran and exited 0 (`br`'s was not run).
- `results/benchsame-cmp.txt` (`scripts/benchsame.sh`): `benchmark-foreign-strings --keep`'s outputs of `unique` and
  `duplicate` at 4,096 and 131,072 by every variant, main's and the PR's: 16 files, all identical; the PR's run of
  every shape passed its own checks (`results/benchsame.txt`).
- `results/fix5-test-foreign.log`: `test-foreign --cross-check`, string merging 30,378 checks, 0 failed.
- `results/fix5-blocks.log` (`scripts/tests.sh`): the foreign inputs, the foreign linker against lld and mold, and the
  link representation blocks of `tools/ci/correctness.tests`, 3 passed.
- `results/ownership.log` (`scripts/ownership.sh`): the unity fixture ownership block on the Develop build, passed.
