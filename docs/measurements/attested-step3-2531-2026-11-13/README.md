# Attested declarations, step 3's first part: what a skipped unit still clears and scans (2026-11-13)

[buster#2531](https://github.com/buster14a/buster/issues/2531)'s step 3 (`docs/attested-declarations.md` in buster)
takes the reader's unit-wide passes out of the skipped declarations' tokens. Its gate: a skipped token costs
`check-input` at most 20 user cycles, and musl's command at least 1.26 times and the glibc units' at least 1.7 times
faster than without attested declarations. This record measures its first part, the branch
`claude/dazzling-noether-ayffn9` of buster (its pull request has the code): the intrinsics' pass leaves the skipped
declarations' operands out, and the bindings table's heads aren't cleared in the reading's own zero arena. **The gate
isn't held**: 1.219 and 1.528.

- **Sources.** Base is buster main's `26f0bb0e`; the final head is the branch's `fe3cd74b`, whose `src/` is the host
  tree's to the byte (the SHA-256 of every file's SHA-256 under `src/`, `b24439a8…`, the same on both; base's `src/`,
  `6a9e4712…`, is main's). The host's trees took their documentation from main. `final/env.txt` has the executables'
  SHA-256 and the trees' hashes outside `build/`. Each tree was built on the host by `scripts/build.sh` (Release, the
  host's native target, `BUSTER_DEBUG_INFO=0`): `builds/`.
- **Host:** the Ryzen 7 9700X, `final/env.txt`. Every step of `scripts/run.sh` ran in a hold of the lock
  (`exclusive.sh`), a few short steps a hold (under a minute), from a cloud session (`scripts/bp3.sh`); one lane is
  pinned to CPU 2, eight to CPUs 0 to 15, all with `setarch -R`.
- **Workloads:** musl's 1,336 units and the 512 generated units over the host's glibc headers, `-c`, one command,
  as [the steps 1 and 2 record](../attested-skip-2531-2026-11-13/) has them; `-c sqlite3.c` alone; a small unit 50
  times a round.

## The probe (`probe/`, `scripts/probe.py`, `scripts/probe-report.py`)

Before any change, a measurement patch (`scripts/probe.py`, applied to `c_check_input.c` and never committed) summed
the TSC ticks of each phase of `check_input_run` over musl's command, in a cloud VM (2.1 GHz TSC, a Develop build of
main), reported as ticks a token of the units. With the skip (`probe/probe3-on.txt`): the walk 126, and the rest 196:
the bindings table's initialization 36 (the heads' clear: three namespaces a name of the lane's intern table, 14,569
names a unit against 3,772 tokens), the columns' clears and fills 30, the expressions' walk 53 (driven by the bodies:
the skip doesn't change it, `probe2-*.txt`), the intrinsics' pass 17, the tree's derived columns 16, the release at
the end 10, the bindings' pass 7. Later files are the same probe on the changes as they were made: `probe-heads.txt`
(the heads), `probe-names.txt` (and the names' columns moved), `probe-intrinsic*.txt` (and the intrinsics' pass),
`probe-glibc-*.txt` (the glibc units). VM ticks are noisy (the walk moves by 10 to 15 from run to run); the 9700X's
counts below decide.

## The batches, in order (each directory's `medians.txt` is `scripts/stats.py`'s medians)

| directory | queue | trees | what |
| --- | --- | --- | --- |
| `1-ab-noint/` | `queue3.sh` | `base`, `head`, `noint` | one lane, 5 rounds: the three changes (`head`: the heads, the names' columns moved into the zero arena, the intrinsics) and without the intrinsics' (`noint`) |
| `2-gate-names/` | `queue4.sh`, `queue5.sh` | `base:off`, `base`, `head` | the same `head` against main with `--attested=off`: one lane and eight, 5 rounds each; every object compared; `sqlite`, `small` |
| `3-variants-nonames/` | `queue6.sh` | `base`, `head`, `nonames` | 5 rounds by one lane and eight: `nonames` is `head` without the names' columns' move |
| `4-variants-intr/` | `queue7.sh` | `base`, `intr`, `nonames` | 7 rounds by one lane and eight: `intr` is the intrinsics' pass alone |
| `final/` | `queue8.sh` | `base:off`, `base`, `head` (= `nonames`, the branch) | every object compared; one lane, 5 rounds; `sqlite`, `small` |

`base:off` is main run with `--attested=off`. The trees named `head` differ by directory: the first three changes in
`1-ab-noint/`, `2-gate-names/` and `3-variants-nonames/`; the final two in `final/`.

## Results

### Every object and diagnostic (`final/compare.txt`)

By the final head, `--attested=on` against `--attested=off` and against `--scalar`: musl's 1,336 objects and 321
warnings, the glibc units' 512 objects, `sqlite3.c` with `shell.c`, by one lane and by eight, with `-Wall -Wextra`
(1,867 warnings), and `--attested=verify` (with `-g`): the same bytes, no contradiction, no unlisted event, no unit
read again.

### Times (`final/medians.txt`, `4-variants-intr/medians.txt`)

| one lane, the median of 5 (`final/`) | main, `--attested=off` | main | the branch | against main | against `off` (gate) |
| --- | ---: | ---: | ---: | ---: | ---: |
| musl: ms (M cycles) | 1,014.0 (5,616.6) | 858.1 (4,752.6) | 831.6 (4,605.9) | 1.032 | **1.219** (1.26) |
| musl: M user instructions; page faults | 11,525.6; 343,035 | 9,062.8; 331,098 | 8,973.9; 290,116 | | |
| glibc units: ms (M cycles) | 835.3 (4,629.9) | 560.2 (3,104.2) | 546.5 (3,028.6) | 1.025 | **1.528** (1.7) |
| glibc units: M user instructions; page faults | 11,182.9; 171,159 | 6,748.7; 153,938 | 6,637.6; 151,431 | | |

| seven rounds (`4-variants-intr/`) | main | the intrinsics' pass alone (`intr`) | and the heads (`nonames`, the branch) |
| --- | ---: | ---: | ---: |
| musl, one lane: ms | 856.6 | 847.1 (1.011) | 831.0 (1.031) |
| glibc units, one lane: ms | 560.2 | 546.9 (1.024) | 546.4 (1.025) |
| musl, eight lanes: CPU ms; wall ms | 1,450.0; 199.6 | 1,426.4; 196.4 | 1,425.6; 198.4 |
| glibc units, eight lanes: CPU ms; wall ms | 969.0; 135.0 | 959.1; 135.6 | 963.6; 135.1 |
| musl, eight lanes: M kernel cycles | 2,595.6 | 2,524.4 | 2,592.4 |
| glibc units, eight lanes: M kernel cycles | 1,202.5 | 1,188.7 | 1,275.3 |

- `-c sqlite3.c`: 124.1 against 123.2 ms; a small unit's process 1.3 ms each (`final/`): A/A.
- **Left out, the names' columns' move** (`2-gate-names/`, `3-variants-nonames/`): one lane on musl was faster, but
  the glibc units' command took 16,600 more page faults (153,938 to 170,520), and by eight lanes 230 to 280 M more
  kernel cycles, 4.6% (musl) and 3.4% (glibc units) more wall time than main in `2-gate-names/`.
- **The cumulative figure moves with the `--attested=off` run:** 1,060.6 ms on musl in `2-gate-names/` and 1,014.0 in
  `final/`, the same instructions; main's rounds and the branch's alternate within each hold, so their ratio (1.03)
  holds across batches. The eight lanes' wall times are bimodal for some trees (musl `nonames` in
  `3-variants-nonames/`: 199 to 230 ms): `4-variants-intr/`'s seven rounds are the eight lanes' figures above.

## Limitations

- The probe ran in a cloud VM, not on the 9700X; it located the costs, and the 9700X's counters measured the changes.
- Eleven other holders shared the lock; each step held it for under a minute, and the trees' runs alternate within it.
- The step's gate isn't held, and the passes left for it (the columns' clears and the tree's derived columns, about 45
  ticks a token in the probe) are read by some 20 files by token.
