# Where the node machine's cost is: #2524's step 1, a follow-up (2026-11-12)

This follows [the shadow's record](../node-machine-shadow-2524-2026-11-12/) for
[buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1. The shadow's sweeps cost 166.6 cycles a taken
node on `sqlite3.c`, against the step's gate of 120. Its profiles suggested two causes: the type table's random lookups
(`check_action_source_complete` among them) and cold inputs. This record tests both. `docs/node-machine.md`'s
"Step 1: the shadow" summarizes it.

Everything ran on the Ryzen 7 9700X (`benchpress`), each run in a hold of the lock, pinned to CPU 2, with the scripts in
`scripts/`. These are the earlier record's scripts, plus `repeat.sh`.

## Sources and binaries

- **The measured commit:** buster
  [`9d81a231a13abcf56d326a4d8c3378a3bea9aa7b`](https://github.com/buster14a/buster/commit/9d81a231a13abcf56d326a4d8c3378a3bea9aa7b),
  on main `a7ca9e8e`. It was checked out by its id after `git checkout -- . && git clean -fd`, with no local change left,
  and built as `logs/build-9d81a231.log` shows.
- **`v7` and `v8`** are its working tree before the commit, sent by tar onto the host's checkout of `a7ca9e8e`:
  - `v7` has the per-type completion positions and the leaves' own path;
  - `v8` adds `--repeat`.

  The commit differs from `v8` in comments alone.
- **Binary hashes:** `results/compilers.txt`.
- **Host:** as the earlier record's `results/env.txt` lists it (Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1, the
  performance governor).

## What changed in the machine

- **A per-unit table of each type's first complete source position.** It answers `check_action_source_complete` for
  the member and pointer rules in one load. The function's walk read four of the type table's columns and the tag
  history.
- **A path of their own for leaves in T,** without the operand records and the argument count.
- **`--repeat N`:** each expression's sweeps run N times in a row in the timing passes. The runs after the first find
  their inputs in the caches, as the reader leaves them in step 2.

## Results at `9d81a231` (`results/9d81a231/`)

| `sqlite3.c`, a taken evaluated node | T: cycles, instructions | T+C+X: cycles, instructions |
| --- | ---: | ---: |
| the shadow at main `2db047f3` (`c3494a5f`, the earlier record) | 96.5, 391.0 | 166.6, 693.1 |
| this commit, one run (`sqlite3.txt`) | 95.2, 368.1 | 172.0, 669.9 |
| this commit, two runs in a row (`sqlite3-repeat2.txt`) | 173.7, 733.1 | 324.9, 1,336.8 |
| the second of two runs (their difference) | 78.5, 365.0 | 152.9, 666.9 |

- **The lookups:** T runs 6% fewer instructions and `check_action_source_complete` is gone from the profile, but T's
  cycles barely move (96.5 to 95.2). The whole sweeps' cycles read 172.0, within the about 3% that placement alone
  moves this figure (the earlier record).
- **Cold inputs:** with its inputs in the caches, the sweeps cost 152.9 cycles a node against 172.0 in one run. Cold
  data is 11% of the shadow's cost. The rest is the sweeps' own work, about 670 instructions a node at an IPC of 4.4.
- **Lua:** its second run's difference (189 cycles, against 178.0 for one run) is within the noise. Its 34 units are
  small enough to stay in the caches from one pass to the next, and each sweep set's least of 11 passes is taken
  apart.
- **`v7` and `v8`** give the same picture (`results/v7`, `results/v8`): 176.7 and 171.7 cycles for one run, and
  `v8`'s second run 152.8.

The gate then asks for fewer instructions a node, about a fifth fewer at the sweeps' IPC. That leaves the design's
28-byte records and baked context and template tables as the levers.

The machine's records and entries are still the pipeline's: `--verify` on `sqlite3.c`, Lua 5.4.8 and musl's 1,336 units,
without and with `-g` (`results/9d81a231/verify-*.txt`, each hold's owner line in `verify-holds.txt`), has 0 differences
in values, entries and the twin, and every run exited 0.

The lock's messages naming other sessions' holds were removed from the logs (the `exclusive.sh: waiting` lines).

## Limits

- **One process a figure.** Each is the least of 11 passes of one process, and placement moves it by about 3%.
- **The warm cost is a difference of two minima,** each of its own process. It holds for `sqlite3.c`; it doesn't for
  Lua's small units.
- **The sweeps run in the shadow's position**, after the pipeline. `--repeat` approximates the reader's position,
  where the inputs are just made; it doesn't measure it.
