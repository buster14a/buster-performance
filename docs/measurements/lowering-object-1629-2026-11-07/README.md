# The `-c` path after checking: the publication's and the object's rest (#1629), 2026-11-07

This is the second record of Buster issue [#1629](https://github.com/buster14a/buster/issues/1629). The
[first](../lowering-definitions-1629-2026-11-07/README.md) brought the smallest units to parity with main before #418
and the selection of 2,000 definitions below it (buster#1658). What it left was the publication's and the object's
excess over main before #418. This record attributes it call by call and removes the part that was avoidable. It is
cited by Buster's `docs/c-lowering.md` ("The publication's and the object's rest").

Every number below is the 9700X's (`benchpress`), under the shared lock, each run pinned to CPU 2, except where a section
says the Xeon VM.

## Trees

| Tree | Source | What it is |
| --- | --- | --- |
| `main418w` | `3bfb4a72a51f4a7872090905d52f92b95b3e1375` | main just before #418's merge |
| `mainw` | `6c8b058993b97b868a3655805f600016e9849028` | main after buster#1658 |
| `c7w` | `mainw` with `patches/c7.patch` | the class sections' names' lengths as constants (buster's branch `claude/confident-hypatia-i2myfn`, `7a1ddd6d`) |

Each is `git archive` of its commit (with its patch), with the stage-split harness of #442's record added and registered
(`scripts/harness/build-trees.sh`), built with `BUSTER_DEBUG_INFO=0 ./build.sh` in a lock hold of its own
(`9700x/builds/`). The harness is #442's (`emit_ab.c` before #1057, `emit_ab_now.c` after), with one addition:
- `EMIT_AB_OBJECT_WARM=N` times the object stage a second time, right after the first, with the clock stopped after its
  Nth call: 1 `link_check`, 2 `object_prepare`, 3 `object_map_symbols`, 4 `object_build`.
- The differences between N give each call's own cost, warm.
- `EMIT_AB_OBJECT_REPEAT=R` runs that second run R times, for a profile of the object stage alone.

`manifests/` has each tree's source and executable hashes, the inputs' and the host.

## Runs

`scripts/rounds4.sh`: 4 rounds, each one lock hold, the trees in an order that rotates by round, 101 passes:
- c-testsuite's 220 programs and #442's synthetic units, each as the path runs (cold) and warm with N = 1 to 4;
- then `-c --lanes 1` of the 220 programs, twice, `mainw` and `c7w`.

Every run exited 0 (`9700x/logs/progress4.log`). `c7w`'s 220 objects by the units' path are `mainw`'s, byte for byte.
The analyses: `9700x/analysis/warm-calls.txt` (`scripts/warm_calls.py`), `paired-cold.txt` (`scripts/paired.py`) and
`units.txt` (`scripts/units_analyze.py`). The floor is each file's least per-run minimum over the 4 rounds, summed or
averaged.

## Results

c-testsuite's 154 programs under 300 tokens, ns a file:

| | `main418w` | `mainw` | `c7w` |
| --- | ---: | ---: | ---: |
| publication | 37.3 | 48.5 | 48.2 |
| object, as run | 184.8 | 257.9 | **245.8** |
| object warm: `link_check` | 6.5 | 10.4 | 10.7 |
| `object_prepare` | 38.9 | 54.2 | 54.1 |
| `object_map_symbols` | 0.6 | 0.6 | 0.4 |
| `object_build` | 68.3 | 100.1 | 104.9 |
| object warm, all | 114.4 | 165.2 | 170.1 |

- **`c7w` against `mainw`:**
  - the object stage is −12.0 ns a file (paired rounds −4.5 to −5.4%, every round);
  - the path's total is −58 ns a file under 300 tokens (−1.5 to −2.1%, and −18% in one round), and −1.26% over all 220;
  - its total under 300 tokens is now 1.8% below `main418w`'s (3,041.4 against 3,098.1 ns a file).
- **What runs warm doesn't show it:** the gain is in the object stage as run, from its first touches; the constants
  replace two `strlen` calls per section, about 3% of the stage on the Xeon.

**What stays over `main418w`** under 300 tokens:
- **the object:** +61 ns a file. Warm, it is +51 ns: `link_check` +4, `object_prepare` +15, `object_build` +32 to 37.
  The rest, about +5 ns, is the run as the path makes it over its warm second run (70.4 ns before #418, 75.7 now).
- **the publication:** +11 ns a file, 0 for the units without static objects and up to +60 for the ones with most.

The 2,000-definition synthetic units, ns a unit (`warm-calls.txt`):

| Unit | Stage | `main418w` | `mainw` | `c7w` |
| --- | --- | ---: | ---: | ---: |
| statics | publication | 70,472 | 87,354 | 87,534 |
| statics | object: `link_check` / `object_prepare` / `object_build`, warm | 30,006 / 19,617 / 47,499 | 33,112 / 25,217 / 51,045 | 33,162 / 25,248 / 51,105 |
| plain | publication | 70,612 | 86,422 | 87,664 |
| plain | object: `link_check` / `object_prepare` / `object_build`, warm | 29,425 / 17,273 / 38,462 | 32,751 / 21,020 / 42,099 | 32,591 / 21,080 / 41,798 |
| literals | publication | 194,355 | 257,072 | 260,449 |
| collisions | publication | 141,295 | 174,918 | 176,872 |

Each of the three calls is about 1 ns more per symbol (4,001 on statics and plain); the publication 8 to 9 ns more per
static object (16.5 on literals, whose 4,000 objects are file-scope compound literals).

## Where it goes

The Xeon VM's in-process sampler (`xeon/`) attributes the excess. It agrees with the 9700X's flat `perf` profiles of
00001 (`9700x/perf/`, whose DWARF unwinding failed, so they have no callers).

- **The object, profiled alone** (`EMIT_AB_OBJECT_REPEAT=200`, `xeon/object-stage-profile.txt`): +16% against main
  before #418, spread over:
  - `object_build` (+6.5k samples). It now passes through the COMDAT groups' count and fill (#1268), the debug
    sections' count and fill, the named sections' descriptors when a unit has them (#619), the options' validation,
    and a 520-byte builder (280 bytes before #418).
  - `link_groups_valid`, new with #1268, which `link_check` and `object_prepare` each call (2% of the stage, with no
    groups).
  - `object_prepare` (+1.5k), and the `strlen` calls that this change removes.
  - No line holds more than about 5% of the stage. The largest is `object_count_sections`' loop over its 14 classes.
- **The publication, on statics-2000** (`xeon/statics-2000-publication-object.txt`): +30%. Each object is now planned
  before its bytes are written (`check_data_plan_object`, then `check_data_emit` and `check_data_copy_scalar`), and
  `check_data_initializer_witness` proves an initialized object nonzero for clang's `.bss` placement (12.3k samples).
  The objects of these units differ from main before #418's: statics-2000's is 362,752 bytes against 351,864.

So the residue is the work of what main has added since #418: COMDAT groups, named sections, debug sections, and the
data's planning and placement. Each of these costs its few ns a unit or one a symbol in every compile, and none is one
avoidable pass.

One further opportunity is outside this change. `link_check` validates every atom's fixups again (`link_check_fixups`),
as it did before #418, though on `-c`'s one-lane path the adds have already checked them. Skipping that needs a record
of which columns lanes filled unchecked: a change to `link_check`'s contract, not to this path.

## The whole compiler

`-c --lanes 1` of all 220 programs, pinned to CPU 2, 8 runs each (`9700x/analysis/units.txt`):
- `mainw` took a median of 72.772 ms and `c7w` 72.231 ms;
- paired, −0.84% (7 of 8 faster).

## Correctness

On the Xeon VM, at `c7w`'s source: every c-testsuite program's and synthetic unit's object by `-c`, `-c -g`,
`-c --scalar` and `-c -funsigned-char` (912 objects) is byte for byte `mainw`'s. `test-object-writer`, `test-link`,
`test-check-lanes` and `test-c-testsuite --cross-check` (220 of 220) pass. On the 9700X, the units' path's 220 objects
agree, and the PR's CI.

## Limitations

- The warm second run sees the first run's data in the caches. Its sum is the stage's own cost; what the path pays over
  it is the first touches.
- The Xeon's sampler attributes shares, not the 9700X's nanoseconds. The 9700X's `perf` profiles here are flat.
- Code placement moves a build by about 2% (#442's record): `c7w`'s warm `object_build` is 4.8 ns over `mainw`'s,
  though the change runs there too.

## Reproducing

On the 9700X, in the directory of the [first record](../lowering-definitions-1629-2026-11-07/README.md)'s runs:
1. Put `scripts/harness/` in `scripts-w/`, and `patches/c7.patch` in `patches/`.
2. Run `scripts/setup2.sh`, then `scripts/rounds4.sh 4` and `scripts/manifests2.sh`.

The analyses: `scripts/warm_calls.py ROUNDS4 TREES`, `scripts/paired.py COLD_ROUNDS TREES` (the cold runs, renamed
`round-R-TREE.txt`) and `scripts/units_analyze.py RUNS TREES`.
